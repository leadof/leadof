#!/bin/sh
#
# Builds a "spelling" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/src/shell/_command.sh
. ./src/containers/libraries/src/shell/_podman.sh

#######################################
# Builds a "spelling" container image.
# Arguments:
#   None
#######################################
build_image() {
  target_name="spelling"
  image_tag="leadof/${target_name}:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./check-spelling.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  copy_files_to_host \
    $image_tag \
    $target_name \
    "/usr/src/spelling/" \
    "./test-results/"

  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

#######################################
# Checks spelling.
# Arguments:
#   None
#######################################
check_spelling() {
  echo ''
  echo 'Running spelling checks...'

  mkdir --parents ./test-results/spelling/

  set +e
  cmd_output=$(pnpm local:spelling 2>&1)
  cmd_exit_code=$?
  set -e

  # always log output
  echo $cmd_output | tee ./test-results/spelling/spelling-results.txt

  if [ $cmd_exit_code != 0 ]; then
    printf $cmd_output 1>&2
    exit 1
  fi

  echo 'Successfully ran spelling checks.'
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
    check_spelling
  fi
}

dotenv

main
