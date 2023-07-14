#!/bin/sh
#
# Executes linting checks.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Installs dependencies.
# Arguments:
#   None
#######################################
install_dependencies() {
  image_tag="tmp-pnpm"
  image_name="tmp-pnpm"

  # create if not exists
  if [ ! -d "./.containers/pnpm-store/" ]; then
    mkdir --parents ./.containers/pnpm-store/
  fi

  echo ''
  echo 'Building container image...'
  time podman build \
    --tag $image_name \
    --network host \
    --file ./dependencies.containerfile \
    .
  echo 'Successfully built container image.'

  echo ''
  echo "Copying output files from container \"${image_name}\"..."
  # copy output files from container
  time podman run --name ${image_name} --detach ${image_tag} sleep 1000
  if [ -d "./.containers/tmp/pnpm-store/" ]; then
    rm -rf ./.containers/tmp/pnpm-store/
  fi
  mkdir --parents ./.containers/tmp/pnpm-store/
  mkdir --parents ./.containers/pnpm-store/

  echo ''
  echo 'Copying container files to local host...'
  # podman cp ${image_name}:/usr/src/pnpm-lock.yaml ./
  time podman cp ${image_name}:/usr/src/.containers/pnpm-store/ ./.containers/tmp/

  echo ''
  echo 'Syncronizing container files with local host cache...'
  time rsync -a --delete ./.containers/tmp/pnpm-store/ ./.containers/pnpm-store/

  echo ''
  echo 'Cleaning up tmp directory...'
  rm -rf ./.containers/tmp/pnpm-store/ >/dev/null &
  echo 'Cleaning up podman container...'
  podman rm --force ${image_name} >/dev/null &
  echo "Successfully copied output files from container \"${image_name}\"."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install_dependencies
}

main
