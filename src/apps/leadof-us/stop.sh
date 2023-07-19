#!/bin/sh
#
# Stops the web application.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Stops the application container.
# Arguments:
#   None
#######################################
stop_container() {
  container_name="leadof-us-dev"

  podman rm --force ${container_name}

  rm -f ./dist/${container_name}-container_digest.txt
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
