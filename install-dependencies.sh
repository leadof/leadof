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

  # create if not exists
  if [ ! -d "./.containers/pnpm-store/" ]; then
    mkdir --parents ./.containers/pnpm-store/
  fi

  echo ''
  echo 'Building container image...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-dependencies.containerfile \
    --ignorefile ./.containerignore \
    .
  echo 'Successfully built container image.'

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir --parents ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/dependencies-container_digest.txt
  echo "Successfully generated distribution files."

  if [ -d "./.containers/tmp/pnpm-store/" ]; then
    rm -rf ./.containers/tmp/pnpm-store/
  fi

  mkdir --parents ./.containers/tmp/pnpm-store/
  mkdir --parents ./.containers/pnpm-store/

  copy_files_to_host \
    $image_tag \
    "dependencies" \
    "/usr/src/.containers/pnpm-store/" \
    "./.containers/tmp/"

  echo ''
  echo 'Synchronizing container files with local host cache...'
  rsync -a --delete ./.containers/tmp/pnpm-store/ ./.containers/pnpm-store/
  rm -rf ./.containers/tmp/pnpm-store/ >/dev/null &
  echo 'Successfully synchronized container files with local host cache.'

  echo $(get_image_digest $image_tag) >./dist/dependencies-container_digest.txt
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
