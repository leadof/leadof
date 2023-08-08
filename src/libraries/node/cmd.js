const util = require("node:util");
const execFile = util.promisify(require("node:child_process").execFile);

const log = require("./log");

const runCommand = async (cmd, argv) => {
  const fullCommand = cmd + (argv ? " " + argv.join(" ") : "");

  log.debug(fullCommand);

  let exitCode;
  let commandStdOut;
  let commandStdErr;
  let err;

  try {
    const { stdout, stderr } = await execFile(cmd, argv ? argv : []);
    exitCode = 0;
    commandStdOut = stdout;
    commandStdErr = stderr;
  } catch (e) {
    // capture errors for return (functional style)
    err = e;

    if (e.code) {
      exitCode = e.code;
    }

    if (e.stdout) {
      commandStdOut = e.stdout;
    }

    if (e.stderr) {
      commandStdErr = e.stderr;
    }
  }

  log.debug("Command result", {
    command: fullCommand,
    stdout: commandStdOut,
    stderr: commandStdErr,
    exitCode,
  });

  if (err || exitCode !== 0) {
    log.error("Command error", {
      command: fullCommand,
      error: err ? JSON.stringify(err) : "",
      stdout: commandStdOut,
      stderr: commandStdErr,
      exitCode,
    });
  }

  return {
    stdout: commandStdOut,
    stderr: commandStdErr,
    error: err,
    exitCode,
  };
};

const runAndExpectStdOutCommand = async (cmd, argv) => {
  const { exitCode, error, stdout, stderr } = await runCommand(cmd, argv);

  if (error) throw error;

  if (stderr) throw new Error(`Error running command: ${cmd}\n\n${stderr}`);

  if (exitCode !== 0)
    throw new Error(
      `Non-zero exit code without additional detail: ${cmd}\n\n${stdout}`,
    );

  return String(stdout);
};

const runAndExpectStdErrCommand = async (cmd, argv) => {
  const { exitCode, error, stdout, stderr } = await runCommand(cmd, argv);

  if (error) throw error;

  return { stdout: String(stdout), stderr: String(stderr), exitCode };
};

module.exports = {
  default: runCommand,
  run: runCommand,
  runAndExpectStdOutCommand,
  runAndExpectStdErrCommand,
};
