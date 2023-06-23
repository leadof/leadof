#!/bin/sh
#
# Starts the web application.

set -e

#######################################
# Starts the application.
# Arguments:
#   None
#######################################
start() {
  podman run \
    --name "leadof-us-dev" \
    --detach \
    --publish 4000:4000 \
    leadof/us:latest
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  start
}

main
