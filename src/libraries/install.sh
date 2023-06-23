#!/bin/sh
#
# Installs libraries.

set -e

#######################################
# Installs libraries.
# Arguments:
#   None
#######################################
install() {
  echo ''
  echo 'Installing libraries...'

  image_tag="leadof/libraries:latest"

  podman build \
    --tag ${image_tag} \
    --file ./containerfile \
    .

  image_name="libraries_install"

  echo "Copying output files from container \"${image_name}\"..."
  # copy output files from container
  podman run --name ${image_name} --detach ${image_tag} sleep 1000
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman cp ${image_name}:/usr/src/dist/ ./
  podman rm --force ${image_name}
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install
}

main
