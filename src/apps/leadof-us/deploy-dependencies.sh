#!/bin/sh
#
# Deploys the container.

set -e

. ../libraries/shell/_command.sh

#######################################
# Deploys the container.
# Arguments:
#   None
#######################################
deploy() {
  image_tag="leadof/us-dependencies:latest"
  dist_tag="ghcr.io/leadof/${image_tag}"

  cat ${CONTAINER_REGISTRY_PASSWORD_FILE_PATH} |
    podman login "ghcr.io" \
      --username "${CONTAINER_REGISTRY_USERNAME}" \
      --password-stdin

  podman push "${dist_tag}"
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  deploy
}

# env vars must be global to the script
dotenv

main
