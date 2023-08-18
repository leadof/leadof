#!/bin/sh
#
# Cleans the Nexus server container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Cleans the Nexus server container.
# Arguments:
#   None
#######################################
clean_nexus() {
  nexus_container_name="nexus"

  # init container should always be cleaned up, but make sure it is
  podman rm --force init-nexus-groovy || true

  set +u
  is_reset="${RESET_NEXUS}"
  set -u

  if [ x"$is_reset" = "x" ]; then
    echo ''
    echo 'Skipping Nexus clean. To clean Nexus, include the environment variable \"RESET_NEXUS\".'
  else
    echo ''
    echo 'Removing Nexus server...'
    podman rm --force ${nexus_container_name} || true
    echo 'Successfully removed Nexus server.'
  fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  clean_nexus
}

main
