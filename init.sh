#!/bin/sh
#
# Initializes the project for use.

set -e

# import command functions
. ./src/shell/_command.sh

# import node functions
. ./src/shell/_node.sh

#######################################
# Initializes for development.
# Globals:
#   CI
# Arguments:
#   None
#######################################
init_dev() {
  if require_env "CI"; then
    echo 'CI detected. Skipping development setup tasks.'
  else
    echo 'Initializing project for development...'
    . ./init-dev.sh
    echo 'Successfully initialized project for development.'
  fi
}

#######################################
# Initializes dependencies.
# Arguments:
#   None
#######################################
init_dependencies() {

  if ! require pnpm; then
    echo 'The CLI for pnpm commands could not be found and must be installed.' 1>&2
    exit 1
  fi

  echo ''
  echo 'Installing NodeJS dependencies...'
  pnpm --recursive install
  echo 'Successfully installed NodeJS dependencies.'
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  . ./executable

  init_dev
  init_dependencies
}

main
