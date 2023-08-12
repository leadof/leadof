const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Stop server initiated.");

  const containerName = "web-leadof-us";

  // make certain any previously running container is removed
  await podman.deleteContainer(containerName);

  log.info("Successfully stopped server.");
};

(async () => {
  await main();
})();
