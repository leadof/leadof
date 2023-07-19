#!/bin/sh
#
# Builds a "src" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Builds a "src" container image.
# Arguments:
#   None
#######################################
build_image() {
  image_tag="leadof/src:latest"
  image_name="leadof-src"

  # create if not exists
  if [ ! -d "./.containers/pnpm-store/" ]; then
    mkdir --parents ./.containers/pnpm-store/
  fi

  echo ''
  echo 'Building container image...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-src.containerfile \
    --ignorefile ./.containerignore \
    .
  echo 'Successfully built container image.'

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir --parents ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/src_container-digest.txt
  echo "Successfully generated distribution files."
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
