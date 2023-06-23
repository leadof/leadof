#!/bin/sh
#
# Initializes the project for development.

set -e

. ../../libraries/shell/_command.sh
. ../../libraries/shell/_node.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof/node:latest"
  target_name="node"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-arg NODE_VERSION=$(get_target_node_version) \
    --build-arg NPM_VERSION=$(get_target_npm_version) \
    --build-arg PNPM_VERSION=$(get_target_pnpm_version) \
    --build-arg NPM_REGISTRY_URL="${NPM_REGISTRY_URL}" \
    --build-arg NPM_REGISTRY_OLD_URL_CONFIG="${NPM_REGISTRY_OLD_URL_CONFIG}" \
    --build-arg NPM_REGISTRY_URL_CONFIG="${NPM_REGISTRY_URL_CONFIG}" \
    --build-arg NPM_REGISTRY_AUTH="${NPM_REGISTRY_AUTH}" \
    --build-arg NPM_REGISTRY_AUTH_TOKEN="${NPM_REGISTRY_AUTH_TOKEN}" \
    --target ${target_name} \
    .

  archive_file_path="./dist/leadof-node.tar"
  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman save --format oci-archive --output ${archive_file_path} "${image_tag}"
  gzip ${archive_file_path}
  echo "Successfully generated distribution files."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install
}

# env vars must be global to the script
dotenv

main
