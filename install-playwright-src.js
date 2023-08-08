const log = require("./src/libraries/node/log");
const container = require("./src/libraries/node/container");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info(
    "Installing Playwright with source code initiated. This may take several minutes.",
  );

  await container.build({
    scriptFilePath: __filename,
    imageName: "playwright-src",
    buildArguments: [],
    skipBuildAndPull: false,
    filePath: "./install-playwright-src.containerfile",
    ignoreFilePath: "./.containerignore",
    context: "./",
  });

  log.info("Successfully installed Playwright with source code.");
};

(async () => {
  await main();
})();
