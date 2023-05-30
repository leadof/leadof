#!/bin/sh
#
# Function library for node, npm, pnpm, yarn, etc.

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
  local version=$(cat ./.pnpmrc)
  # remove any trailing whitespace
  version="${version%%*( )}"

  echo $version
}
