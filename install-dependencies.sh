#!/bin/sh
#
# Builds a dependencies container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/src/shell/_podman.sh

#######################################
# Builds a dependencies container image.
# Arguments:
#   None
#######################################
build_image() {
  image_name="dependencies"
  image_tag="leadof/${image_name}:latest"

  load_cached_image $image_name

  echo ''
  echo 'Building container image...'
  echo '  Loading context may take several seconds ...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-${image_name}.containerfile \
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
