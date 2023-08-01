const log = require("./src/libraries/node/log");
const container = require("./src/libraries/node/container");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Installing dependencies initiated. This may take several minutes.");

  await container.build({
    scriptFilePath: __filename,
    imageName: "dependencies",
    buildArguments: [],
    skipBuildAndPull: false,
    filePath: "./install-dependencies.containerfile",
    ignoreFilePath: "./.containerignore",
    context: "./",
  });

  log.info("Successfully installed dependencies.");
};

(async () => {
  await main();
})();
