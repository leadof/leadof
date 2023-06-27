#!/bin/sh
#
# Deploys the container.

set -e

. ../../containers/libraries/shell/_command.sh

#######################################
# Deploys the container.
# Arguments:
#   None
#######################################
deploy() {
  image_tag="leadof/us-dependencies:latest"
  dist_tag="ghcr.io/leadof/${image_tag}"

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