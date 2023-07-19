#!/bin/sh
#
# Executes linting checks.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../../containers/libraries/shell/_command.sh
. ../../containers/libraries/shell/_node.sh

#######################################
# Lints the application.
# Arguments:
#   None
#######################################
lint() {
  target_name="lint"
  image_tag="leadof-us/lint:latest"

  podman build \
    --tag "${image_tag}" \
    --file ./check-lint.containerfile \
    --ignorefile ./.containerignore \
    --network host \
    .

  image_name="${target_name}_results"

  echo "Copying output files from container \"${image_name}\"..."
  # copy output files from container
  podman run --name ${image_name} --detach ${image_tag} sleep 1000
  if [ -d "./test-results/${target_name}/" ]; then
    rm -rf ./test-results/${target_name}/
  fi
  mkdir --parents ./test-results/${target_name}/
  podman cp ${image_name}:. ./test-results/
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
  lint
}

# env vars must be global to the script
dotenv

main
