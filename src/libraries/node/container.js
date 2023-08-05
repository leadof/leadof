const fs = require("fs");
const path = require("path");

const env = require("../../libraries/node/env");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const buildImage = async (options) => {
  const { stdout, stderr } = await podman.build({
    imageTag: options.imageTag,
    context: options.context ? options.context : "./src",
    filePath: options.filePath ? options.filePath : "./src/containerfile",
    ignoreFilePath: options.ignoreFilePath
      ? options.ignoreFilePath
      : "./src/.containerignore",
    network: "host",
    buildArguments: options.buildArguments,
  });

  if (stderr) {
    log.error("Error building image", { imageTag, stderr });
    process.exit(1);
  }

  log.debug(stdout);
};

const tagImage = async (imageTag, deployTag) => {
  const { stdout, stderr } = await podman.tag(imageTag, deployTag);

  if (stderr) {
    log.error("Error tagging image", { imageTag, stderr });
    process.exit(1);
  }

  log.debug(stdout);
};

const createImageDistributionFile = async (scriptFilePath, imageTag) => {
  const imageDigest = await podman.getImageDigest(imageTag);
  const scriptName = path.basename(scriptFilePath);
  const scriptDirectoryPath = path.dirname(scriptFilePath);

  const outputDirectoryPath = host.getRelativePath(
    scriptDirectoryPath,
    `./.task-output/${scriptName}/`,
  );

  await host.mkdir(outputDirectoryPath, true);

  const distributionImageDigestFilePath = host.getRelativePath(
    scriptDirectoryPath,
    `./.task-output/${scriptName}/container_digest.txt`,
  );

  if (await host.pathExists(distributionImageDigestFilePath)) {
    await host.deletePath(distributionImageDigestFilePath);
  }

  await host.writeFile(distributionImageDigestFilePath, imageDigest);

  log.info("Successfully created image digest distribution file", {
    tag: imageTag,
    digest: imageDigest,
    filePath: distributionImageDigestFilePath,
  });
};

const build = async (options) => {
  const scriptFilePath = options.scriptFilePath;
  const imageName = options.imageName;
  const buildArguments = options.buildArguments;
  const skipBuildAndPull = options.skipBuildAndPull;

  log.debug("");
  log.debug("Building...");

  const imageTag = `leadof/${imageName}:latest`;
  const deployTag = `ghcr.io/leadof/${imageTag}`;

  if (skipBuildAndPull) {
    log.debug(
      "Context of running in Continuous Integration mode was detected.",
    );

    await podman.pull(deployTag);
    log.info("Successfully pulled", deployTag);

    const localTag = `localhost/${imageTag}`;
    // tag the deployed image as a localhost image
    // this ensures that local image build references work
    await podman.tag(deployTag, localTag);
    log.info("Successfully tagged remote image with local tag", localTag);
  } else {
    const isCacheContainersEnabled = env.getAsBoolean("CI");
    const cacheImageFilePath = `./.containers/${imageName}-image.tar`;
    const cacheImageDirectoryPath = path.dirname(cacheImageFilePath);

    if (isCacheContainersEnabled) {
      if (await host.pathExists(cacheImageFilePath)) {
        await podman.load(cacheImageFilePath);
        log.info("Loaded previously cached image from file", {
          path: cacheImageFilePath,
        });
      }
    }

    const buildOptions = {
      imageTag,
      buildArguments,
    };

    if (options.context) {
      buildOptions.context = options.context;
    }

    if (options.filePath) {
      buildOptions.filePath = options.filePath;
    }

    if (options.ignoreFilePath) {
      buildOptions.ignoreFilePath = options.ignoreFilePath;
    }

    await buildImage(buildOptions);
    log.info("Successfully built image", { imageTag });

    await tagImage(imageTag, deployTag);
    log.info("Successfully tagged image for deployment", { deployTag });

    if (isCacheContainersEnabled) {
      if (await host.pathExists(cacheImageFilePath)) {
        await host.deletePath(cacheImageFilePath);
        log.info("Deleted previously cached image file", {
          path: cacheImageFilePath,
        });
      }

      if (!(await host.pathExists(cacheImageDirectoryPath))) {
        await fs.promises.mkdir(cacheImageDirectoryPath, { recursive: true });
      }

      await podman.save(imageTag, cacheImageFilePath);
      log.info("Saved cached image file", { path: cacheImageFilePath });
    }
  }

  await createImageDistributionFile(scriptFilePath, imageTag);
};

const environmentVariablesToBuildArguments = (options) => {
  const buildArguments = {};

  options.forEach((option) => {
    if (option.isRequired) {
      buildArguments[option.key] = env.getRequired(option.key);
      return;
    }

    if (env.hasKey(option.key)) {
      buildArguments[option.key] = env.get(option.key);
      return;
    }

    log.debug("Skipping build argument for missing environment variable", {
      env: option.key,
    });
  });

  return buildArguments;
};

const deploy = async (scriptFilePath, imageName) => {
  log.debug("");
  log.debug("Deploying...");

  if (env.isContinuousIntegrationMode()) {
    log.debug(
      "Context of running in Continuous Integration mode was detected.",
    );
  }

  const deployTag = `ghcr.io/leadof/leadof/${imageName}:latest`;

  try {
    const { stderr } = await podman.push(deployTag);

    log.info("Pushed image", { tag: deployTag });

    // if (stderr) {
    //   log.error("Unexpected error during push", { tag: deployTag, stderr });
    //   process.exit(1);
    // }

    // BUG: a successful command will use "stderr" (https://github.com/containers/podman/discussions/19454)
    log.debug(stderr);
  } catch (error) {
    log.error("Unexpected error during push", { tag: deployTag, error });
    process.exit(1);
  }

  log.info("Successfully deployed image.");
};

module.exports = {
  build,
  environmentVariablesToBuildArguments,
  deploy,
};
