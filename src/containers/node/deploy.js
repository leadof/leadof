const container = require("../../libraries/node/container");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  host.loadDotenv();

  log.info("Initiated deploy.");

  await container.deploy(__filename, "node");
};

(async () => {
  await main();
})();
