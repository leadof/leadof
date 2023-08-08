const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking testing initiated.");

  const imageTag = "localhost/leadof/chrome-src:latest";
  const commandArguments = ["pnpm", "local:check:testing"];

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
    "testing.log",
  );

  host.writeFile(commandOutputFilePath, stdout);

  log.info("Successfully checked testing.");
};

(async () => {
  await main();
})();
