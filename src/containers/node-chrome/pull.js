const env = require("../../libraries/node/env");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  host.loadDotenv();

  const containerDeployName = env.get("CONTAINER_DEPLOY_NAME");
  const imageName = "node-chrome";

  const isSkipBuildAndPullEnabled =
    containerDeployName && containerDeployName !== imageName;

  const tag = `ghcr.io/leadof/leadof/${imageName}`;

  if (isSkipBuildAndPullEnabled) {
    log.info("Initiated image pull.", { tag });

    await podman.pull(tag);

    log.info("Successfully pull.", { tag });
  } else {
    log.info("Skipped pull.", { tag });
  }
};

(async () => {
  await main();
})();
