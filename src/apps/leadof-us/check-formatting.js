const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking formatting initiated.");

  const imageTag = "localhost/leadof/src:latest";
  const commandArguments = ["pnpm", "local:check:formatting"];

  const { stdout, stderr } = await podman.run({
    imageTag,
    isTemporary: true,
    workingDirectoryPath: "/usr/src/leadof/src/apps/leadof-us/",
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
    "formatting.log",
  );

  host.writeFile(commandOutputFilePath, stdout);

  log.info("Successfully checked formatting.");
};

(async () => {
  await main();
})();
