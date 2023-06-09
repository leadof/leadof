#!/bin/sh
#
# Initializes the project for development.

set -e

#######################################
# Lints the application.
# Arguments:
#   None
#######################################
lint() {
  podman build \
    --tag leadof/us:latest \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --build-context libraries=container-image://localhost/leadof/libraries:latest \
    --target lint \
    .
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  lint
}

main
