#!/bin/sh
#
# Builds a "lint" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/src/shell/_command.sh
. ./src/containers/libraries/src/shell/_podman.sh

#######################################
# Builds a "lint" container image.
# Arguments:
#   None
#######################################
build_image() {
  target_name="lint"
  image_tag="leadof/${target_name}:latest"

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

  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

#######################################
# Checks formatting.
# Arguments:
#   None
#######################################
check_formatting() {
  echo ''
  echo 'Running formatting checks...'

  mkdir --parents ./test-results/lint/

  set +e
  cmd_output=$(pnpm local:lint 2>&1)
  cmd_exit_code=$?
  set -e

  # always log output
  echo $cmd_output | tee ./test-results/lint/lint-results.txt

  if [ $cmd_exit_code != 0 ]; then
    printf $cmd_output 1>&2
    exit 1
  fi

  echo 'Successfully ran formatting checks.'
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
    check_formatting
  fi
}

dotenv

main
