#!/bin/sh
#
# Initializes the project for development.

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

  archive_file_path="./dist/leadof-node-chrome.tar"
  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman save --format oci-archive --output ${archive_file_path} "${image_tag}"
  gzip ${archive_file_path}
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
