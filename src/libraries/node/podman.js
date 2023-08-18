const { v4: uuidv4 } = require("uuid");

const cmd = require("./cmd");
const log = require("./log");

const COMMAND_NAME = "podman";

const getVersion = async () => {
  const commandArguments = ["--version"];

  const stdout = await cmd.runAndExpectStdOutCommand(
    COMMAND_NAME,
    commandArguments,
  );

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

  const stdout = await cmd.runAndExpectStdOutCommand(
    COMMAND_NAME,
    commandArguments,
  );

  return stdout.trim();
};

const tag = async (imageTag, newTag) => {
  const commandArguments = ["tag", imageTag, newTag];

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const pull = async (imageTag) => {
  const commandArguments = ["pull", imageTag];

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const push = async (imageTag) => {
  const commandArguments = ["push", imageTag];

  return await cmd.runAndExpectStdErrCommand(COMMAND_NAME, commandArguments);
};

const getImages = async (showAll) => {
  const commandArguments = showAll
    ? ["images", "--all", "--format", "json"]
    : ["images", "--format", "json"];

  const stdout = await cmd.runAndExpectStdOutCommand(
    COMMAND_NAME,
    commandArguments,
  );

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

  const stdout = await cmd.runAndExpectStdOutCommand(
    COMMAND_NAME,
    commandArguments,
  );

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

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const save = async (imageTag, archiveFilePath) => {
  const commandArguments = ["save", "--output", archiveFilePath, imageTag];

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const load = async (archiveFilePath) => {
  const commandArguments = ["load", "--input", archiveFilePath];

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const deleteContainer = async (nameOrId) => {
  const commandArguments = ["rm", "--force", nameOrId];

  try {
    await cmd.run(COMMAND_NAME, commandArguments);
  } catch (e) {
    // ignore errors
  }
};

const copyFiles = async (containerName, containerPath, hostPath) => {
  // BUG: GitHub Actions Ubuntu server podman version does not support `--overwrite`
  // fn(... hostPath, { isOverwriteEnabled = false } = {},) {
  // commandArguments = [..., ...(isOverwriteEnabled ? ["--overwrite"] : []), ]
  const commandArguments = [
    "cp",
    `${containerName}:${containerPath}`,
    hostPath,
  ];

  return await cmd.runAndExpectStdOutCommand(COMMAND_NAME, commandArguments);
};

const run = async (options) => {
  const imageTag = options.imageTag;
  const argv = options.commandArguments ? options.commandArguments : [];
  const isTemporary = options.isTemporary ? options.isTemporary : false;
  const isDetached = options.isDetached ? options.isDetached : false;
  const network = options.network ? options.network : null;
  // create a unique identifier of 6 characters
  const uniqueId = uuidv4().replace("-", "").substring(0, 6);
  const name = options.containerName
    ? options.containerName
    : `tmp-` + imageTag.replace(/[\/:]/gi, "-") + `-${uniqueId}`;
  const workingDirectoryPath = options.workingDirectoryPath
    ? options.workingDirectoryPath
    : null;

  const publishPorts = options.publishPorts
    ? options.publishPorts
        .map((publishPort) => [
          "--publish",
          `${publishPort.host}:${publishPort.container}`,
        ])
        .flat(1)
    : [];

  // make sure it doesn't already exist (from any previous run)
  if (isTemporary) {
    await deleteContainer(name);
  }

  const commandArguments = [
    "run",
    "--name",
    name,
    ...(isTemporary ? ["--rm"] : []),
    ...(isDetached ? ["--detach"] : []),
    ...(network ? ["--network", network] : []),
    ...publishPorts,
    ...(workingDirectoryPath ? ["--workdir", workingDirectoryPath] : []),
    imageTag,
    ...argv,
  ];

  let commandExitCode;
  let commandStdOut;
  let commandStdErr;
  let commandError;

  try {
    const { stdout, stderr, error, exitCode } = await cmd.run(
      COMMAND_NAME,
      commandArguments,
    );
    commandStdOut = stdout;
    commandStdErr = stderr;
    commandError = error;
    commandExitCode = exitCode;
  } finally {
    // always clean up
    if (isTemporary) {
      await deleteContainer(name);
    }
  }

  return {
    command:
      COMMAND_NAME +
      (commandArguments && commandArguments.length > 0
        ? " " + commandArguments.join(" ")
        : ""),
    stdout: commandStdOut,
    stderr: commandStdErr,
    error: commandError,
    exitCode: commandExitCode,
  };
};

module.exports = {
  build,
  copyFiles,
  default: run,
  deleteContainer,
  getContainers,
  getImages,
  getImageDigest,
  getVersion,
  load,
  pull,
  push,
  run,
  save,
  tag,
};
