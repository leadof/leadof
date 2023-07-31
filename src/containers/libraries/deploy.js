const env = require("../../libraries/node/env");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const push = async () => {
  const deployTag = "ghcr.io/leadof/leadof/libraries:latest";

  try {
    const { stderr } = await podman.push(deployTag);

    log.info("Pushed image", { tag: deployTag });

    // if (stderr) {
    //   log.error("Unexpected error during push", { tag: deployTag, stderr });
    //   process.exit(1);
    // }

    // BUG: a successful command will use "stderr" (https://github.com/containers/podman/discussions/19454)
    log.debug(stderr);
  } catch (error) {
    log.error("Unexpected error during push", { tag: deployTag, error });
    process.exit(1);
  }
};

const main = async () => {
  log.registerLoggerSingleton(__filename);

  host.loadDotenv();

  log.debug("");
  log.debug("Deploying...");

  if (env.isContinuousIntegrationMode()) {
    log.debug(
      "Context of running in Continuous Integration mode was detected.",
    );
  }

  await push();
  log.info("Successfully pushed image.");
};

(async () => {
  await main();
})();
