const fs = require("fs");
const path = require("path");

const { glob } = require("glob");

const host = require("./src/libraries/node/host");
const log = require("./src/libraries/node/log");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Parsing dependencies initiated.");

  const outputRootDirectoryPath = path.join(
    host.getTaskOutputDirectoryPath(__filename),
    "./packages/",
  );

  const packageFilePaths = await glob("**/package.json", {
    ignore: ["node_modules/**", "task-output/**"],
  });

  for (const packageFilePath of packageFilePaths) {
    const packageInfo = await host.readJson(packageFilePath);

    const newPackageInfo = {
      name: packageInfo.name,
      dependencies: packageInfo.dependencies,
      devDependencies: packageInfo.devDependencies,
    };

    const outputFilePath = path.join(outputRootDirectoryPath, packageFilePath);
    const outputDirectoryPath = path.dirname(outputFilePath);

    if (await host.pathExists(outputFilePath)) {
      host.deletePath(outputFilePath);
    }

    if (!(await host.pathExists(outputDirectoryPath))) {
      await fs.promises.mkdir(outputDirectoryPath, { recursive: true });
    }

    host.writeJson(outputFilePath, newPackageInfo);
    log.info("Successfully wrote package changes", { path: outputFilePath });
  }

  log.info("Successfully parsed dependencies.");
};

(async () => {
  await main();
})();
