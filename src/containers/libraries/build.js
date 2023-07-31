const path = require("path");

const env = require("../../libraries/node/env");
const host = require("../../libraries/node/host");
const log = require("../../libraries/node/log");
const podman = require("../../libraries/node/podman");

const buildImage = async (
  imageTag,
  publishedSourceUrl,
  publishedDocumentationUrl,
) => {
  const { stdout, stderr } = await podman.build({
    imageTag: imageTag,
    context: "./src",
    filePath: "./src/containerfile",
    ignoreFilePath: "./src/.containerignore",
    network: "host",
    buildArguments: {
      PUBLISHED_SOURCE_URL: publishedSourceUrl,
      PUBLISHED_DOCUMENTATION_URL: publishedDocumentationUrl,
    },
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

const createImageDistributionFile = async (imageTag) => {
  const imageDigest = await podman.getImageDigest(imageTag);
  const scriptName = path.basename(__filename);

  const distributionImageDigestFilePath = host.getRelativePath(
    __dirname,
    `./task-output/${scriptName}/container_digest.txt`,
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

const main = async () => {
  log.registerLoggerSingleton(__filename);

  host.loadDotenv();

  log.debug("");
  log.debug("Building...");

  const imageTag = "leadof/libraries:latest";
  const deployTag = `ghcr.io/leadof/${imageTag}`;

  if (env.isContinuousIntegrationMode()) {
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
    const publishedSourceUrl = env.getRequired("PUBLISHED_SOURCE_URL");

    const publishedDocumentationUrl = env.getRequired(
      "PUBLISHED_DOCUMENTATION_URL",
    );

    await buildImage(imageTag, publishedSourceUrl, publishedDocumentationUrl);
    log.info("Successfully built image", { imageTag });

    await tagImage(imageTag, deployTag);
    log.info("Successfully tagged image for deployment", { deployTag });
  }

  await createImageDistributionFile(imageTag);
};

(async () => {
  await main();
})();
