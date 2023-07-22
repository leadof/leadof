#!/bin/sh
#
# Executes unit tests.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/shell/_podman.sh

#######################################
# Tests the application.
# Arguments:
#   None
#######################################
test() {
  target_name="unit_test"
  image_tag="leadof-us/test:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./check-test.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  copy_files_to_host \
    $image_tag \
    $target_name \
    "/usr/src/unit_test/" \
    "./test-results/"

  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  test
}

main
