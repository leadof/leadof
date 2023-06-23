#!/bin/sh
#
# Executes linting checks.

set -e

. ../../libraries/shell/_command.sh
. ../../libraries/shell/_node.sh

#######################################
# Lints the application.
# Arguments:
#   None
#######################################
lint() {
  image_tag="leadof-us/lint:latest"
  target_name="lint"

  podman build \
    --tag "${image_tag}" \
    --file ./containerfile \
    --ignorefile ./.containerignore \
    --network host \
    --build-context dependencies=container-image://localhost/leadof-us/dependencies:latest \
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
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  lint
}

# env vars must be global to the script
dotenv

main
