#!/bin/sh
#
# Installs the container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Installs the image.
# Arguments:
#   None
#######################################
install() {
  target_name="smol"
  image_tag="leadof/smol:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --target ${target_name} \
    .

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm --recursive --force ./dist/
  fi
  mkdir --parents ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/container-digest.txt
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
