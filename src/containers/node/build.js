const path = require("path");

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
    {
      key: "NPM_REGISTRY_URL",
      isRequired: false,
    },
    {
      key: "NPM_REGISTRY_OLD_URL_CONFIG",
      isRequired: false,
    },
    {
      key: "NPM_REGISTRY_URL_CONFIG",
      isRequired: false,
    },
    {
      key: "NPM_REGISTRY_AUTH",
      isRequired: false,
    },
    {
      key: "NPM_REGISTRY_AUTH_TOKEN",
      isRequired: false,
    },
  ];

  const buildArguments = container.environmentVariablesToBuildArguments(
    environmentVariableOptions,
  );

  const nvmrcFilePath = path.join(__dirname, "../../../.nvmrc");

  if (await host.pathExists(nvmrcFilePath)) {
    const nvmrcVersion = (await host.readFile(nvmrcFilePath)).trim();
    const nodeVersion = nvmrcVersion.startsWith("v")
      ? nvmrcVersion.substring(1)
      : nvmrcVersion;

    buildArguments["NODE_VERSION"] = nodeVersion;
  }

  const npmVersionFilePath = path.join(__dirname, "../../../.npm-version");

  if (await host.pathExists(npmVersionFilePath)) {
    const npmVersion = (await host.readFile(npmVersionFilePath)).trim();

    buildArguments["NPM_VERSION"] = npmVersion;
  }

  const pnpmVersionFilePath = path.join(__dirname, "../../../.pnpm-version");

  if (await host.pathExists(pnpmVersionFilePath)) {
    const pnpmVersion = (await host.readFile(pnpmVersionFilePath)).trim();

    buildArguments["PNPM_VERSION"] = pnpmVersion;
  }

  const imageName = "node";
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
