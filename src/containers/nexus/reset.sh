#!/bin/sh
#
# Completely resets the project.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Completely resets the project.
# Arguments:
#   None
#######################################
reset() {
  set +u
  is_reset="${RESET_NEXUS}"
  set -u

  if [ x"$is_reset" = "x" ]; then
    echo ''
    echo 'Skipping Nexus reset. To reset Nexus, include the environment variable \"RESET_NEXUS\".'
  else
    echo ''
    echo 'Resetting Nexus project and removing Nexus containers and images...'
    podman rmi --force localhost/leadof/nexus:latest || true
    podman volume rm --force nexus-data || true
    echo 'Successfully reset Nexus project.'
  fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  reset
}

main
