const util = require("node:util");
const execFile = util.promisify(require("node:child_process").execFile);

const log = require("./log");

const runCommand = async (cmd, argv) => {
  const fullCommand = cmd + (argv ? " " + argv.join(" ") : "");

  log.debug(fullCommand);

  return await execFile(cmd, argv ? argv : []);
};

module.exports = {
  default: runCommand,
  run: runCommand,
};
