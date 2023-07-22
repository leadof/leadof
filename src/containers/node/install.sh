#!/bin/sh
#
# Installs the container.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../libraries/shell/_command.sh
. ../libraries/shell/_node.sh

#######################################
# Installs the application.
# Arguments:
#   None
#######################################
install() {
  target_name="node"
  image_tag="leadof/node:latest"
  dist_tag="ghcr.io/leadof/${image_tag}"

  set +u
  is_ci="${CI}"
  set -u

  if [ x"$is_ci" = "x" ]; then
    if [ -f "./.containers/node-image.tar" ]; then
      echo ''
      echo 'Loading cached container image...'
      podman load --input "./.containers/node-image.tar"
      echo 'Successfully loaded cached container image.'
    fi

    podman build \
      --tag "${image_tag}" \
      --file ./containerfile \
      --ignorefile ./.containerignore \
      --network host \
      --build-arg NODE_VERSION=$(get_target_node_version) \
      --build-arg NPM_VERSION=$(get_target_npm_version) \
      --build-arg PNPM_VERSION=$(get_target_pnpm_version) \
      --build-arg NPM_REGISTRY_URL="${NPM_REGISTRY_URL}" \
      --build-arg NPM_REGISTRY_OLD_URL_CONFIG="${NPM_REGISTRY_OLD_URL_CONFIG}" \
      --build-arg NPM_REGISTRY_URL_CONFIG="${NPM_REGISTRY_URL_CONFIG}" \
      --build-arg NPM_REGISTRY_AUTH="${NPM_REGISTRY_AUTH}" \
      --build-arg PUBLISHED_SOURCE_URL="${PUBLISHED_SOURCE_URL}" \
      --build-arg PUBLISHED_DOCUMENTATION_URL="${PUBLISHED_DOCUMENTATION_URL}" \
      --target ${target_name} \
      .

    podman tag "${image_tag}" "${dist_tag}"

    # remember image
    echo ''
    echo 'Saving cached image...'
    if [ -f "./.containers/node-image.tar" ]; then
      rm --force "./.containers/node-image.tar"
      echo 'Removed previously cached image.'
    fi
    if [ ! -d "./.containers/" ]; then
      mkdir "./.containers/"
    fi
    podman save --output ./.containers/node-image.tar $image_tag
    echo 'Successfully saved cached image.'
  else
    echo ''
    echo "CI detected. Skipping image build and pulling \"${dist_tag}\"..."
    podman pull $dist_tag
    podman tag "${dist_tag}" "localhost/${image_tag}"
    echo "Successfully pulled \"${dist_tag}\"."
  fi

  echo "Generating distribution files..."
  if [ ! -d "./dist/" ]; then
    mkdir "./dist/"
  fi
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

# env vars must be global to the script
dotenv

main
