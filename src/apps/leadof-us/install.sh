#!/bin/sh
#
# Installs the application.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/shell/_command.sh
. ../../containers/libraries/shell/_node.sh
. ../../containers/libraries/shell/_podman.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
build_image() {
  target_name="web"
  image_tag="leadof-us/web:latest"
  dist_tag="ghcr.io/leadof/${image_tag}"

  if [ -f "./.containers/${target_name}-image.tar" ]; then
    echo ''
    echo 'Loading cached container image...'
    podman load --input "./.containers/${target_name}-image.tar"
    echo 'Successfully loaded cached container image.'
  fi

  podman build \
    --tag "${image_tag}" \
    --file ./install.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-arg PUBLISHED_SOURCE_URL="${PUBLISHED_SOURCE_URL}" \
    --build-arg PUBLISHED_DOCUMENTATION_URL="${PUBLISHED_DOCUMENTATION_URL}" \
    --target ${target_name} \
    .

  podman tag "${image_tag}" "${dist_tag}"

  # remember image
  echo ''
  echo 'Saving cached image...'
  if [ -f "./.containers/${target_name}-image.tar" ]; then
    rm --force "./.containers/${target_name}-image.tar"
    echo 'Removed previously cached image.'
  fi
  if [ ! -d "./.containers/" ]; then
    mkdir "./.containers/"
  fi
  podman save --output ./.containers/${target_name}-image.tar $image_tag
  echo 'Successfully saved cached image.'

  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/${target_name}-container_digest.txt
}

build_app() {
  echo ''
  echo 'Building application...'

  mkdir --parents ./task-results/install/

  set +e
  cmd_output=$(pnpm local:build 2>&1)
  cmd_exit_code=$?
  set -e

  # always log output
  echo $cmd_output | tee ./task-results/install/install-results.txt

  if [ $cmd_exit_code = 0 ]; then
    # move build output to task results
    echo ''
    echo 'Moving build distribution files to task results...'
    mv ./dist/ ./task-results/install/
    echo 'Successfully moved build distribution files to task results.'
  else
    printf $cmd_output 1>&2
    exit 1
  fi

  echo 'Successfully built application.'
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
    build_app
  fi
}

# env vars must be global to the script
dotenv

main
