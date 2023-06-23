#!/bin/sh
#
# Installs the container.

set -e

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof/node-chrome:latest"
  target_name="node_chrome"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --target ${target_name} \
    .

  dist_tag="ghcr.io/leadof/${image_tag}"

  podman tag "${image_tag}" "${dist_tag}"

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman inspect "${image_tag}" --format "{{.Digest}}" >./dist/container-digest.txt
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

main
