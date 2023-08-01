const log = require("./src/libraries/node/log");
const container = require("./src/libraries/node/container");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Installing source code initiated. This may take several minutes.");

  await container.build({
    scriptFilePath: __filename,
    imageName: "src",
    buildArguments: [],
    skipBuildAndPull: false,
    filePath: "./install-src.containerfile",
    ignoreFilePath: "./.containerignore",
    context: "./",
  });

  log.info("Successfully installed source code.");
};

(async () => {
  await main();
})();
