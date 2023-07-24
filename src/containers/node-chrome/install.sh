#!/bin/sh
#
# Installs the container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../libraries/shell/_command.sh
. ../libraries/shell/_podman.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  target_name="node_chrome"
  image_tag="leadof/node-chrome:latest"
  dist_tag="ghcr.io/leadof/${image_tag}"

  set +u
  is_ci="${CI}"
  set -u

  if [ x"$is_ci" = "x" ]; then
    podman build \
      --tag "${image_tag}" \
      --file ./containerfile \
      --ignorefile ./.containerignore \
      --network host \
      --target ${target_name} \
      .

    podman tag "${image_tag}" "${dist_tag}"
  else
    echo ''
    echo "CI detected. Skipping image build and pulling \"${dist_tag}\"..."
    podman pull $dist_tag
    podman tag "${dist_tag}" "localhost/${image_tag}"
    echo "Successfully pulled \"${dist_tag}\"."
  fi

  echo "Generating distribution files..."
  if [ ! -d "./dist/" ]; then
    mkdir ./dist/
  fi
  echo $(get_image_digest $image_tag) >./dist/container_digest.txt
  echo "Successfully generated distribution files."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install
}

# env vars must be global to the script
dotenv

main
