#!/bin/sh
#
# Stops the Nexus server container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Stops the Nexus server container.
# Arguments:
#   None
#######################################
stop_nexus() {
  nexus_container_name="nexus"

  echo ''
  echo 'Stopping Nexus server...'
  podman stop --force ${nexus_container_name}
  echo 'Successfully stopped Nexus server.'
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  stop_nexus
}

main
