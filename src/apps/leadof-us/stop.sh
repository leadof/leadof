#!/bin/sh
#
# Initializes the project for development.

set -e

#######################################
# Stops the application container.
# Arguments:
#   None
#######################################
stop_container() {
  podman rm --force leadof-us-dev
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  stop_container
}

main
