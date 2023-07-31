#!/bin/sh
#
# Builds a "src" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/src/shell/_podman.sh

#######################################
# Builds a "src" container image.
# Arguments:
#   None
#######################################
build_image() {
  image_name="src"
  image_tag="leadof/${image_name}:latest"

  load_cached_image $image_name

  echo ''
  echo 'Building container image...'
  echo '  Loading context may take several seconds ...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-src.containerfile \
    --ignorefile ./.containerignore \
    .
  echo 'Successfully built container image.'

  cache_image $image_name $image_tag
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  build_image
}

main
