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
  podman build \
    --tag leadof/us:latest \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --build-context libraries=container-image://localhost/leadof/libraries:latest \
    --target production \
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
