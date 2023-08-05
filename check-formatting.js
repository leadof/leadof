const host = require("./src/libraries/node/host");
const log = require("./src/libraries/node/log");
const podman = require("./src/libraries/node/podman");

const main = async () => {
  log.registerLoggerSingleton(__filename);

  log.info("Checking formatting initiated.");

  const imageTag = "localhost/leadof/src:latest";
  const argv = ["pnpm", "local:check:formatting"];

  // BUG: a successful command will use "stderr" (https://github.com/containers/podman/discussions/19454)
  const { stderr } = await podman.run(imageTag, ...argv);

  log.debug(stderr, { tag: imageTag, command: argv.join(" ") });

  const commandOutputFilePath = host.getTaskOutputFilePath(
    __filename,
    "formatting.log",
  );

  host.writeFile(commandOutputFilePath, stderr);

  log.info("Successfully checked formatting.");
};

(async () => {
  await main();
})();
