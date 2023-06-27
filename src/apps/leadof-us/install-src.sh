#!/bin/sh
#
# Containerizes the source code.

set -e

. ../../containers/libraries/shell/_command.sh
. ../../containers/libraries/shell/_node.sh

#######################################
# Containerizes the source code.
# Arguments:
#   None
#######################################
containerize_source() {
  image_tag="leadof-us/src:latest"
  target_name="src"

  cat ${CONTAINER_REGISTRY_PASSWORD_FILE_PATH} |
    podman login "ghcr.io" \
      --username "${CONTAINER_REGISTRY_USERNAME}" \
      --password-stdin

  podman build \
    --tag "${image_tag}" \
    --file ./src.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --target "${target_name}" \
    .

  image_name="${target_name}_results"

  echo "Copying output files from container \"${image_name}\"..."
  if [ -d "./dist/${target_name}/" ]; then
    rm -rf ./dist/${target_name}/
  fi
  mkdir -p ./dist/${target_name}/
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./dist/${target_name}/container-digest.txt
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  containerize_source
}

# env vars must be global to the script
dotenv

main
