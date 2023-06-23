#!/bin/sh
#
# Stops the web application.

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
