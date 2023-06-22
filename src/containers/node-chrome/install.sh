#!/bin/sh
#
# Initializes the project for development.

set -e

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof/node-chrome:latest"
  target_name="node_chrome"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
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

main
