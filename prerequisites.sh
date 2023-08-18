#!/bin/sh
#
# Initializes the project for use.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

# import command functions
. ./src/containers/libraries/src/shell/_command.sh

# import node functions
. ./src/containers/libraries/src/shell/_node.sh

#######################################
# Initializes for development.
# Globals:
#   CI
# Arguments:
#   None
#######################################
dev_prerequisites() {
  set +u
  is_ci="${CI}"
  set -u

  if [ x"$is_ci" = "x" ]; then
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

    set +u
    container_registry_username="${CONTAINER_REGISTRY_USERNAME}"
    container_registry_password="${CONTAINER_REGISTRY_PASSWORD}"
    container_registry_password_file_path="${CONTAINER_REGISTRY_PASSWORD_FILE_PATH}"
    set -u

    if [ x"${container_registry_password_file_path}" != "x" ]; then
      cat ${container_registry_password_file_path} |
        podman login "ghcr.io" \
          --username "${container_registry_username}" \
          --password-stdin
    elif [ x"${container_registry_password}" != "x" ]; then
      echo ${container_registry_password} |
        podman login "ghcr.io" \
          --username "${container_registry_username}" \
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

  outputDirectoryPath="./.task-output/prerequisites.sh/"
  outputFilePath="${outputDirectoryPath}prerequisites.txt"

  if [ ! -d $outputDirectoryPath ]; then
    mkdir --parents $outputDirectoryPath
  fi

  if [ -f $outputFilePath ]; then
    rm --force $outputFilePath
  fi

  echo "Prerequisites installed" >$outputFilePath
}

dotenv

main
