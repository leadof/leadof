#!/bin/sh
#
# Executes end-to-end tests.

set -e

. ../../containers/libraries/shell/_command.sh
. ../../containers/libraries/shell/_node.sh

#######################################
# Runs end-to-end tests.
# Arguments:
#   None
#######################################
check_e2e() {
  image_tag="leadof-us/e2e:latest"
  target_name="e2e"

  podman build \
    --tag "${image_tag}" \
    --file ./check-e2e.containerfile \
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
  check_e2e
}

# env vars must be global to the script
dotenv

main
