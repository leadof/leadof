const util = require("node:util");
const execFile = util.promisify(require("node:child_process").execFile);

const cmd = require("./cmd");
const log = require("./log");

const COMMAND_NAME = "podman";

const runCommand = async (argv) => {
  return await cmd.run(COMMAND_NAME, argv);
};

const getVersion = async () => {
  const commandArguments = ["--version"];

  const { stdout, stderr } = await runCommand(commandArguments);

  if (stderr) {
    log.error("Error getting version", { stderr });
    throw new Error(stderr);
  }

  return stdout.trim();
};

const getImageDigest = async (imageTag) => {
  const commandArguments = [
    "image",
    "inspect",
    imageTag,
    "--format",
    "{{.Digest}}",
  ];

  const { stdout, stderr } = await runCommand(commandArguments);

  if (stderr) {
    log.error("Error getting image digest", { imageTag, stderr });
    throw new Error(stderr);
  }

  return stdout;
};

const tag = async (imageTag, newTag) => {
  const commandArguments = ["tag", imageTag, newTag];

  return await runCommand(commandArguments);
};

const pull = async (imageTag) => {
  const commandArguments = ["pull", imageTag];

  return await runCommand(commandArguments);
};

const push = async (imageTag) => {
  const commandArguments = ["push", imageTag];

  return await runCommand(commandArguments);
};

const getImages = async (showAll) => {
  const commandArguments = showAll
    ? ["images", "--all", "--format", "json"]
    : ["images", "--format", "json"];

  const { stdout, stderr } = await runCommand(commandArguments);

  if (stderr) {
    log.error("Error retrieving container image list", { stderr });
    process.exit(1);
  }

  try {
    return JSON.parse(stdout.trim());
  } catch (e) {
    log.error("Unexpected error parsing container image list command output", {
      stdout,
    });

    process.exit(1);
  }
};

const getContainers = async (showAll) => {
  const commandArguments = showAll
    ? ["ps", "--all", "--format", "json"]
    : ["ps", "--format", "json"];

  const { stdout, stderr } = await runCommand(commandArguments);

  if (stderr) {
    log.error("Error retrieving container image list", { stderr });
    process.exit(1);
  }

  try {
    return JSON.parse(stdout.trim());
  } catch (e) {
    log.error("Unexpected error parsing container image list command output", {
      stdout,
    });

    process.exit(1);
  }
};

const build = async (options) => {
  if (!options.imageTag) {
    throw new Error('Missing required argument "options.imageTag".');
  }

  let buildArguments = [];

  if (options.buildArguments) {
    const buildArgumentNames = Object.keys(options.buildArguments);

    buildArguments = buildArgumentNames
      .map((buildArgumentName) => {
        const buildArgumentValue = options.buildArguments[buildArgumentName];
        return ["--build-arg", `${buildArgumentName}=${buildArgumentValue}`];
      })
      .flat(1);
  }

  const fileArguments = options.filePath ? ["--file", options.filePath] : [];

  const ignoreArguments = options.ignoreFilePath
    ? ["--ignorefile", options.ignoreFilePath]
    : [];

  const networkArguments = options.network
    ? ["--network", options.network]
    : [];

  const contextPath = options.context ? options.context : ".";

  const additionalArguments = options.commandArguments
    ? options.commandArguments
    : [];

  const commandArguments = [
    "build",
    "--tag",
    options.imageTag,
    ...fileArguments,
    ...ignoreArguments,
    ...networkArguments,
    ...buildArguments,
    ...additionalArguments,
    contextPath,
  ];

  return await runCommand(commandArguments);
};

module.exports = {
  build,
  default: runCommand,
  getContainers,
  getImages,
  getImageDigest,
  getVersion,
  pull,
  push,
  run: runCommand,
  tag,
};
