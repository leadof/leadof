#!/bin/sh
#
# Installs libraries.

set -e

#######################################
# Installs libraries.
# Arguments:
#   None
#######################################
install() {
  echo ''
  echo 'Installing libraries...'

  cd ./src/libraries/
  make
  cd -

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
  install
}

main
