#!/bin/sh
#
# Executes unit tests.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/src/shell/_command.sh
. ../../containers/libraries/src/shell/_podman.sh

#######################################
# Builds a test image.
# Arguments:
#   None
#######################################
build_image() {
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

  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

#######################################
# Checks tests.
# Arguments:
#   None
#######################################
check_tests() {
  echo ''
  echo 'Running tests...'

  mkdir --parents ./test-results/unit_test/

  set +e
  cmd_output=$(pnpm local:test 2>&1)
  cmd_exit_code=$?
  set -e

  # always log output
  echo $cmd_output | tee ./test-results/unit_test/unit_test-results.txt

  if [ $cmd_exit_code != 0 ]; then
    printf $cmd_output 1>&2
    exit 1
  fi

  echo 'Successfully ran tests.'
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  set +u
  is_in_container="${IN_CONTAINER}"
  set -u

  if [ x"$is_in_container" = "x" ]; then
    build_image
  else
    check_tests
  fi
}

dotenv

main
