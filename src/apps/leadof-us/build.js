const log = require("../../libraries/node/log");
const container = require("../../libraries/node/container");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Build initiated. This may take several minutes.");

  await container.build({
    scriptFilePath: __filename,
    imageName: "leadof-us/web",
    buildArguments: [],
    skipBuildAndPull: false,
    filePath: "./build.containerfile",
    ignoreFilePath: "./.containerignore",
    context: "./",
  });

  log.info("Successfully built.");
};

(async () => {
  await main();
})();
