const log = require("./src/libraries/node/log");
const container = require("./src/libraries/node/container");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info(
    "Installing Chrome with source code initiated. This may take several minutes.",
  );

  await container.build({
    scriptFilePath: __filename,
    imageName: "chrome-src",
    buildArguments: [],
    filePath: "./install-chrome-src.containerfile",
    ignoreFilePath: "./.containerignore",
    context: "./",
  });

  log.info("Successfully installed Chrome with source code.");
};

(async () => {
  await main();
})();
