#!/bin/sh
#
# Initializes the project for use.

set -e

#######################################
# Initializes for development.
# Globals:
#   CI
# Arguments:
#   None
#######################################
initDev() {
    if [ x"${CI}" = "x" ]; then
        echo 'Initializing project for development...'
        . ./init-dev.sh
        echo 'Successfully initialized project for development.'
    else
        echo 'CI detected. Skipping development setup tasks.'
    fi
}

#######################################
# Initializes dependencies.
# Arguments:
#   None
#######################################
initDependencies() {
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

    initDev
    initDependencies
}

main
