#!/bin/sh
#
# Initializes the project for development.

set -e

. ../../libraries/shell/_command.sh
. ../../libraries/shell/_node.sh

#######################################
# Tests the application.
# Arguments:
#   None
#######################################
test() {
  image_tag="leadof-us/test:latest"
  target_name="unit_test"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-context libraries=container-image://localhost/leadof/libraries:latest \
    --build-arg NODE_VERSION=$(get_node_version) \
    --build-arg NPM_VERSION=$(get_npm_version) \
    --build-arg PNPM_VERSION=$(get_pnpm_version) \
    --build-arg NPM_REGISTRY_URL="${NPM_REGISTRY_URL}" \
    --build-arg NPM_REGISTRY_OLD_URL_CONFIG="${NPM_REGISTRY_OLD_URL_CONFIG}" \
    --build-arg NPM_REGISTRY_URL_CONFIG="${NPM_REGISTRY_URL_CONFIG}" \
    --build-arg NPM_REGISTRY_AUTH="${NPM_REGISTRY_AUTH}" \
    --build-arg NPM_REGISTRY_AUTH_TOKEN="${NPM_REGISTRY_AUTH_TOKEN}" \
    --target "${target_name}" \
    .

  image_name="${target_name}_results"

  echo "Copying output files from container \"${image_name}\"..."
  # copy output files from container
  podman run --name ${image_name} --detach ${image_tag} sleep 1000
  mkdir -p ./test-results/${target_name}/
  podman cp ${image_name}:/usr/src/test-results/ ./test-results/${target_name}/
  mv ./test-results/${target_name}/test-results/* ./test-results/${target_name}/
  rm -rf ./test-results/${target_name}/test-results/
  podman rm --force ${image_name}
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  test
}

# env vars must be global to the script
dotenv

main
