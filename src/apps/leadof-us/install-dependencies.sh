#!/bin/sh
#
# Installs the application's dependencies.

set -e

. ../../libraries/shell/_command.sh
. ../../libraries/shell/_node.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof-us/dependencies:latest"
  target_name="all_dependencies"

  podman build \
    --tag "${image_tag}" \
    --file ./dependencies.containerfile \
    --ignorefile ./.containerignore \
    --network host \
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
