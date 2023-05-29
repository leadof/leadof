#!/bin/sh
#
# Initializes the project for development.

set -e

#######################################
# Initializes node version manager (nvm).
# Arguments:
#   None
#######################################
initNvm() {
    set +e
    . "$HOME/.nvm/nvm.sh" # Load nvm
    set -e

    nvm_version=$(nvm --version)

    echo "Detected nvm version: $nvm_version"
}

#######################################
# Initializes node.
# Arguments:
#   None
#######################################
initNode() {
    node_version=$(cat ./.nvmrc)
    node_version="${node_version%%*( )}"

    echo ''
    echo "Installing NodeJS $node_version..."
    nvm install $node_version
    nvm use $node_version
    echo "Successfully installed NodeJS $node_version."
}

#######################################
# Initializes npm.
# Arguments:
#   None
#######################################
initNpm() {
    echo ''
    echo "Installing latest npm..."
    npm install --location=global --no-fund npm@latest
    echo "Successfully installed latest npm."

    npm config set fund false --global
    echo 'Disabled npm funding messages.'
}

#######################################
# Initializes pnpm.
# Arguments:
#   None
#######################################
initPnpm() {
    pnpm_version=$(cat ./.pnpmrc)
    pnpm_version="${pnpm_version%%*( )}"

    echo ''
    echo "Removing any previous version of pnpm..."
    npm uninstall --location=global pnpm || true
    echo "Successfully removed any previous version of pnpm."

    echo ''
    echo "Installing pnpm $pnpm_version..."
    npm install --location=global pnpm@$pnpm_version
    echo "Successfully installed pnpm $pnpm_version."
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
    initNvm
    initNode
    initNpm
    initPnpm
}

main
