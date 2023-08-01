#!/bin/sh
#
# Executes end-to-end tests.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/src/shell/_command.sh
. ../../containers/libraries/src/shell/_podman.sh

#######################################
# Runs end-to-end tests.
# Arguments:
#   None
#######################################
build_image() {
  target_name="e2e"
  image_tag="leadof-us/e2e:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./check-e2e.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  copy_files_to_host \
    $image_tag \
    $target_name \
    "/usr/src/e2e/" \
    "./test-results/"

  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

#######################################
# Checks end-to-end tests.
# Arguments:
#   None
#######################################
check_e2e() {
  echo ''
  echo 'Running end-to-end tests...'

  mkdir --parents ./test-results/e2e/

  set +e
  cmd_output=$(pnpm local:e2e 2>&1)
  cmd_exit_code=$?
  set -e

  # always log output
  echo $cmd_output | tee ./test-results/e2e/e2e-results.txt

  if [ $cmd_exit_code != 0 ]; then
    printf $cmd_output 1>&2
    exit 1
  fi

  echo 'Successfully ran end-to-end tests.'
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
    check_e2e
  fi
}

dotenv

main
