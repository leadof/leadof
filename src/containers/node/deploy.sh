#!/bin/sh
#
# Deploys the container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../libraries/shell/_command.sh

#######################################
# Deploys the container.
# Arguments:
#   None
#######################################
deploy() {
  image_tag="leadof/node:latest"
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
