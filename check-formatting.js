const host = require("./src/libraries/node/host");
const log = require("./src/libraries/node/log");
const podman = require("./src/libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking formatting initiated.");

  const imageTag = "localhost/leadof/src";
  const commandArguments = ["pnpm", "local:check:formatting"];

  const { stdout, stderr, exitCode, error } = await podman.run({
    imageTag,
    isTemporary: true,
    commandArguments,
  });

  const commandOutputFilePath = host.getTaskOutputFilePath(
    __filename,
    exitCode !== 0 || error ? "formatting.error.log" : "formatting.log",
  );

  await host.writeFile(commandOutputFilePath, exitCode === 0 ? stdout : stderr);

  if (error) {
    throw error;
  }

  if (exitCode !== 0) {
    throw new Error("Container returned a non-zero exit code.\n\n${stderr}");
  }

  log.info("Successfully checked formatting.");
};

(async () => {
  await main();
})();
