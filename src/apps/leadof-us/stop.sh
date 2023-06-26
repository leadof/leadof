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
  container_name="leadof-us-dev"

  podman rm --force ${container_name}

  rm -f ./dist/${container_name}_container-digest.txt
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
