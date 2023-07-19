#!/bin/sh
#
# Builds a "lint" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/shell/_command.sh
. ./src/containers/libraries/shell/_podman.sh

#######################################
# Builds a "lint" container image.
# Arguments:
#   None
#######################################
build_image() {
  target_name="lint"
  image_tag="leadof/${target_name}:latest"
  image_name="${target_name}_results"

  podman build \
    --tag "${image_tag}" \
    --file ./check-lint.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  copy_files_to_host \
    $image_tag \
    $image_name \
    "/usr/src/lint/" \
    "./test-results/"

  echo $(get_image_digest $image_tag) >./test-results/${target_name}/container-digest.txt
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  build_image
}

# env vars must be global to the script
dotenv

main
