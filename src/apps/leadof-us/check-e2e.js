const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking end-to-end testing initiated.");

  const imageTag = "localhost/leadof/playwright-src:latest";
  const commandArguments = ["pnpm", "local:check:e2e"];

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
    "e2e.log",
  );

  await host.writeFile(commandOutputFilePath, stdout);

  log.info("Successfully checked end-to-end testing.");
};

(async () => {
  await main();
})();
