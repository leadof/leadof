const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Start server initiated.");

  const imageTag = "localhost/leadof/leadof-us/web";
  const containerName = "web-leadof-us";

  // make certain any previously running container is removed
  await podman.deleteContainer(containerName);

  const { error, stdout, stderr, exitCode } = await podman.run({
    imageTag,
    containerName,
    isDetached: true,
    publishPorts: [
      {
        container: 4000,
        host: 4000,
      },
    ],
  });

  if (error) throw error;

  if (stderr) throw new Error(`Error starting server: ${stderr}`);

  if (exitCode !== 0)
    throw new Error(
      `Non-zero exit code while starting server without additional detail: ${stdout}`,
    );

  const commandOutputFilePath = host.getTaskOutputFilePath(
    __filename,
    "start.log",
  );

  await host.writeFile(commandOutputFilePath, stdout);

  log.info("Successfully started server.");
};

(async () => {
  await main();
})();
