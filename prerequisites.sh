#!/bin/sh
#
# Initializes the project for use.

set -e

# import command functions
. ./src/libraries/shell/_command.sh

# import node functions
. ./src/libraries/shell/_node.sh

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
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  . ./src/libraries/shell/executable

  dev_prerequisites

  pnpm_install
}

main
