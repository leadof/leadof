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
  image_tag="leadof-us/web:latest"
  target_name="web"

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
    --target ${target_name} \
    .
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