#!/bin/sh
#
# Function library for node, npm, pnpm, yarn, etc.
# Dependencies:
#   _command.sh

set -e

#######################################
# Gets the current node version.
# Returns:
#   The version of node.
#######################################
get_node_version() {
  local version=$(node --version 2>&1 || true)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

#######################################
# Gets the target node version.
# Returns:
#   The target version of node.
#######################################
get_target_node_version() {
  local version=$(cat ./.nvmrc)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

#######################################
# Gets the current npm version.
# Returns:
#   The version of npm.
#######################################
get_npm_version() {
  local version=$(npm --version 2>&1 || true)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

#######################################
# Gets the target npm version.
# Returns:
#   The target version of npm.
#######################################
get_target_npm_version() {
  local version=$(cat ./.npm-version)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

################################################################################
# pnpm
################################################################################

#######################################
# Gets the current pnpm version.
# Returns:
#   The version of pnpm.
#######################################
get_pnpm_version() {
  local version=$(pnpm --version 2>&1 || true)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

#######################################
# Gets the target pnpm version.
# Returns:
#   The target version of pnpm.
#######################################
get_target_pnpm_version() {
  local version=$(cat ./.pnpm-version)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}

#######################################
# Initializes dependencies.
# Arguments:
#   None
#######################################
pnpm_install() {

  if ! require pnpm; then
    echo 'The CLI for pnpm commands could not be found and must be installed.' 1>&2
    exit 1
  fi

  echo ''
  echo 'Installing NodeJS dependencies...'
  pnpm --recursive install --frozen-lockfile
  echo 'Successfully installed NodeJS dependencies.'
}
