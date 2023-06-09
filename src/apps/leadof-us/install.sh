#!/bin/sh
#
# Installs the application.

set -e

. ../../containers/libraries/shell/_command.sh
. ../../containers/libraries/shell/_node.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  image_tag="leadof-us/web:latest"
  target_name="web"

  cat ${CONTAINER_REGISTRY_PASSWORD_FILE_PATH} |
    podman login "ghcr.io" \
      --username "${CONTAINER_REGISTRY_USERNAME}" \
      --password-stdin

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-arg PUBLISHED_SOURCE_URL="${PUBLISHED_SOURCE_URL}" \
    --build-arg PUBLISHED_DOCUMENTATION_URL="${PUBLISHED_DOCUMENTATION_URL}" \
    --target ${target_name} \
    .

  dist_tag="ghcr.io/leadof/${image_tag}"

  podman tag "${image_tag}" "${dist_tag}"

  echo "Generating distribution files..."
  if [ -d "./dist/" ]; then
    rm -rf ./dist/
  fi
  mkdir -p ./dist/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/app_container-digest.txt
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
