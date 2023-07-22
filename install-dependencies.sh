#!/bin/sh
#
# Builds a dependencies container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/shell/_podman.sh

#######################################
# Builds a dependencies container image.
# Arguments:
#   None
#######################################
build_image() {
  image_tag="leadof/dependencies:latest"

  if [ -f "./.containers/dependencies-image.tar" ]; then
    echo ''
    echo 'Loading cached container image...'
    podman load --input ./.containers/dependencies-image.tar
    echo 'Successfully loaded cached container image.'
  fi

  echo ''
  echo 'Building container image...'
  echo '  Loading context may take several seconds ...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-dependencies.containerfile \
    --ignorefile ./.containerignore \
    .
  echo 'Successfully built container image.'

  echo "Generating distribution files..."
  if [ ! -d "./dist/" ]; then
    mkdir "./dist/"
  fi
  echo $(get_image_digest $image_tag) >./dist/dependencies-container_digest.txt
  echo "Successfully generated distribution files."

  # remember image
  echo ''
  echo 'Saving cached image...'
  if [ -f "./.containers/dependencies-image.tar" ]; then
    rm --force "./.containers/dependencies-image.tar"
    echo 'Removed previously cached image.'
  fi
  if [ ! -d "./.containers/" ]; then
    mkdir "./.containers/"
  fi
  podman save --output ./.containers/dependencies-image.tar $image_tag
  echo 'Successfully saved cached image.'

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
