#!/bin/sh
#
# Installs libraries.

set -e

. ../libraries/shell/_command.sh

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
    --ignorefile ./.containerignore \
    --network host \
    --build-arg PUBLISHED_SOURCE_URL="${PUBLISHED_SOURCE_URL}" \
    --build-arg PUBLISHED_DOCUMENTATION_URL="${PUBLISHED_DOCUMENTATION_URL}" \
    .

  dist_tag="ghcr.io/leadof/${image_tag}"

  podman tag "${image_tag}" "${dist_tag}"

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman inspect "${image_tag}" --format "{{.Digest}}" >./dist/container-digest.txt
  echo "Successfully generated distribution files."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install
}

# env vars must be global to the script
dotenv

main
