#!/bin/sh

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../libraries/src/shell/_command.sh

#######################################
# Installs a Nexus server.
# Arguments:
#   None
#######################################
install_nexus() {

  if [ x"${NEXUS_ADMIN_DEFAULT_PASSWORD}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_ADMIN_DEFAULT_PASSWORD".' 1>&2
    exit 1
  fi

  nexus_image_tag="leadof/nexus"

  echo ''
  echo 'Building the Nexus server image...'
  podman build \
    --tag ${nexus_image_tag} \
    --file ./.containerignore \
    --file ./containerfile \
    --build-arg NEXUS_ADMIN_DEFAULT_PASSWORD="${NEXUS_ADMIN_DEFAULT_PASSWORD}" \
    .
  echo 'Successfully built the Nexus server image.'
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install_nexus
}

# env vars must be global to the script
dotenv

main
