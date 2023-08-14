const container = require("../../libraries/node/container");
const env = require("../../libraries/node/env");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  host.loadDotenv();

  log.info("Initiated build.");

  const environmentVariableOptions = [
    {
      key: "PUBLISHED_SOURCE_URL",
      isRequired: true,
    },
    {
      key: "PUBLISHED_DOCUMENTATION_URL",
      isRequired: true,
    },
  ];

  const buildArguments = container.environmentVariablesToBuildArguments(
    environmentVariableOptions,
  );

  const imageName = "node-chrome";
  const containerDeployName = env.get("CONTAINER_DEPLOY_NAME");

  const isPrepareForDeployEnabled =
    containerDeployName && containerDeployName === imageName;

  await container.build({
    scriptFilePath: __filename,
    imageName,
    buildArguments,
    isPullEnabled: true,
    isPrepareForDeployEnabled,
  });
};

(async () => {
  await main();
})();
