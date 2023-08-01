#!/bin/sh
#
# Installs the application's dependencies.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/src/shell/_command.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof-us/dependencies:latest"
  target_name="all_dependencies"

  podman build \
    --tag "${image_tag}" \
    --file ./dependencies.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-arg PUBLISHED_SOURCE_URL="${PUBLISHED_SOURCE_URL}" \
    --build-arg PUBLISHED_DOCUMENTATION_URL="${PUBLISHED_DOCUMENTATION_URL}" \
    --target ${target_name} \
    .

  echo 'Generating distribution files...'
  if [ -d "./dist/" ]; then
    rm --recursive --force ./dist/
  fi
  mkdir --parents ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/dependencies-container_digest.txt
  echo 'Successfully generated distribution files.'
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
