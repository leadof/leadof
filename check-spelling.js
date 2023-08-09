const host = require("./src/libraries/node/host");
const log = require("./src/libraries/node/log");
const podman = require("./src/libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking spelling initiated.");

  const imageTag = "localhost/leadof/src";
  const commandArguments = ["pnpm", "local:check:spelling"];

  // BUG: a successful command will use "stderr" (https://github.com/containers/podman/discussions/19454)
  const { stdout, stderr } = await podman.run({
    imageTag,
    isTemporary: true,
    commandArguments,
  });

  log.debug("Container ran successfully", {
    tag: imageTag,
    command: commandArguments.join(" "),
    stdout,
    stderr,
  });

  const commandOutputFilePath = host.getTaskOutputFilePath(
    __filename,
    "spelling.log",
  );

  await host.writeFile(commandOutputFilePath, stderr);

  log.info("Successfully checked spelling.");
};

(async () => {
  await main();
})();
