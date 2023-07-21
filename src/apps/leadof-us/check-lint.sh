#!/bin/sh
#
# Executes linting checks.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/shell/_podman.sh

#######################################
# Lints the application.
# Arguments:
#   None
#######################################
build_image() {
  target_name="lint"
  image_tag="leadof-us/${target_name}:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./check-lint.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  copy_files_to_host \
    $image_tag \
    $target_name \
    "/usr/src/lint/" \
    "./test-results/"

  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
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
