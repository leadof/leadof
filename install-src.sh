#!/bin/sh
#
# Builds a "src" container image.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Builds a "src" container image.
# Arguments:
#   None
#######################################
build_image() {
  image_tag="leadof/src:latest"
  image_name="leadof-src"

  echo ''
  echo 'Building container image...'
  echo '  Loading context may take several seconds ...'
  podman build \
    --tag $image_tag \
    --network host \
    --file ./install-src.containerfile \
    --ignorefile ./.containerignore \
    .
  echo 'Successfully built container image.'

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm --recursive --force ./dist/
  fi
  mkdir --parents ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/src-container_digest.txt
  echo "Successfully generated distribution files."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  build_image
}

main
