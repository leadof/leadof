#!/bin/sh
#
# Checks spelling for the application.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ./src/containers/libraries/shell/_command.sh
. ./src/containers/libraries/shell/_node.sh

#######################################
# Checks spelling for the application.
# Arguments:
#   None
#######################################
check_spelling() {
  image_tag="leadof/spelling:latest"
  target_name="spelling"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --target "${target_name}" \
    .

  image_name="${target_name}_results"

  echo "Copying output files from container \"${image_name}\"..."
  # copy output files from container
  podman run --name ${image_name} --detach ${image_tag} sleep 1000
  if [ -d "./test-results/${target_name}/" ]; then
    rm -rf ./test-results/${target_name}/
  fi
  mkdir -p ./test-results/${target_name}/
  podman cp ${image_name}:/usr/src/test-results/ ./test-results/${target_name}/
  mv ./test-results/${target_name}/test-results/* ./test-results/${target_name}/
  rm -rf ./test-results/${target_name}/test-results/
  podman rm --force ${image_name}
  podman image inspect "${image_tag}" --format "{{.Digest}}" >./test-results/${target_name}/container-digest.txt
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  check_spelling
}

# env vars must be global to the script
dotenv

main
