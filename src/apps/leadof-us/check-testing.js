const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  const outputDirectoryPath = host.getTaskOutputDirectoryPath(__filename);

  log.registerLoggerSingleton(__filename);

  log.info("Checking testing initiated.");

  const imageTag = "localhost/leadof/chrome-src:latest";
  const commandArguments = ["pnpm", "local:check:testing"];

  const containerName = "tmp-testing-leadof-us";

  let testingStdOut;

  try {
    // make certain any previously running container is removed
    await podman.deleteContainer(containerName);

    const { stdout, stderr, error, exitCode } = await podman.run({
      imageTag,
      containerName: containerName,
      isTemporary: false,
      workingDirectoryPath: "/usr/src/leadof/src/apps/leadof-us/",
      commandArguments,
    });

    testingStdOut = stdout;

    if (error) throw error;

    const commandOutputFilePath = host.getTaskOutputFilePath(
      __filename,
      stderr ? "testing.error.log" : "testing.log",
    );

    await host.writeFile(commandOutputFilePath, stderr ? stderr : stdout);

    if (stderr || exitCode !== 0) {
      log.error("Container failed", {
        tag: imageTag,
        containerName: containerName,
        command: commandArguments.join(" "),
        stderr,
        exitCode,
      });

      throw new Error(
        `Container "${containerName}" failed with errors (exit code: ${exitCode}).\n\n${stderr}`,
      );
    }

    log.debug("Container is running", {
      tag: imageTag,
      containerName: containerName,
      command: commandArguments.join(" "),
      stdout,
    });

    const containerPath =
      "/usr/src/leadof/src/apps/leadof-us/.task-output/coverage/";

    await podman.copyFiles(containerName, containerPath, outputDirectoryPath);
    log.info("Successfully copied test output files", {
      containerName,
      containerPath,
      outputDirectoryPath,
    });
  } finally {
    await podman.deleteContainer(containerName);
  }

  log.info("Successfully checked testing.");
};

(async () => {
  await main();
})();
