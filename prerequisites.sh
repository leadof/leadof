#!/bin/sh
#
# Initializes the project for use.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

# import command functions
. ./src/containers/libraries/shell/_command.sh

# import node functions
. ./src/containers/libraries/shell/_node.sh

#######################################
# Initializes for development.
# Globals:
#   CI
# Arguments:
#   None
#######################################
dev_prerequisites() {
  if [ x"$CI" = "x" ]; then
    echo ''
    echo 'Initializing project for development...'
    . ./prerequisites.dev.sh
    echo 'Successfully initialized project for development.'
  else
    echo ''
    echo 'CI detected. Skipping development setup tasks.'
  fi
}

#######################################
# Authenticates to the GitHub container registry.
# Arguments:
#   None
#######################################
auth_gh_container_registry() {
  gh_container_registry="ghcr.io"

  set +e
  podman_gh_username=$(podman login --get-login ${gh_container_registry} 2>&1)
  podman_get_login_exit_code=$?
  set -e

  if [ $podman_get_login_exit_code = 0 ]; then
    echo ''
    echo "Already logged into the GitHub container registry \"${gh_container_registry}\" as \"${podman_gh_username}\"."
  else
    echo ''
    echo "Authenticating to the GitHub container registry \"${gh_container_registry}\"..."

    if [ x"${CONTAINER_REGISTRY_PASSWORD_FILE_PATH}" != "x" ]; then
      cat ${CONTAINER_REGISTRY_PASSWORD_FILE_PATH} |
        podman login "ghcr.io" \
          --username "${CONTAINER_REGISTRY_USERNAME}" \
          --password-stdin
    elif [ x"${CONTAINER_REGISTRY_PASSWORD}" != "x" ]; then
      echo ${CONTAINER_REGISTRY_PASSWORD} |
        podman login "ghcr.io" \
          --username "${CONTAINER_REGISTRY_USERNAME}" \
          --password-stdin
    else
      echo 'FAILED to read the container password from environment variables:' 1>&2
      echo '  - "CONTAINER_REGISTRY_PASSWORD_FILE_PATH"' 1>&2
      echo '  - "CONTAINER_REGISTRY_PASSWORD"' 1>&2
      echo ''
      exit 1
    fi

    echo "Successfully authenticated to the GitHub container registry \"${gh_container_registry}\"."
  fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  mark_scripts_executable

  dev_prerequisites

  pnpm_install

  auth_gh_container_registry

  if [ ! -d "./test-results/" ]; then
    mkdir ./test-results/
  fi

  if [ -f "./test-results/prerequisites.txt" ]; then
    rm -f ./test-results/prerequisites.txt
  fi

  echo "Prerequisites installed" >./test-results/prerequisites.txt
}

dotenv

main
