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
