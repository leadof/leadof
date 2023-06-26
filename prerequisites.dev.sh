#!/bin/sh
#
# Initializes the project for development.

set -e

# import command functions
. ./src/containers/libraries/shell/_command.sh

# import node functions
. ./src/containers/libraries/shell/_node.sh

#######################################
# Initializes node version manager (nvm).
# Arguments:
#   None
#######################################
init_nvm() {
  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    echo '' 1>&2
    echo 'ERROR: Missing required nvm program.' 1>&2
    exit 1
  fi

  set +e
  . "$HOME/.nvm/nvm.sh" # Load nvm
  set -e

  if ! require nvm; then
    echo 'The CLI for nvm commands could not be found and must be installed.' 1>&2
    exit 1
  fi

  nvm_version=$(nvm --version)

  echo "Detected nvm version: $nvm_version"
}

#######################################
# Initializes node.
# Arguments:
#   None
#######################################
init_node() {

  current_node_version=$(get_node_version)
  target_node_version=$(get_target_node_version)

  if [ "$current_node_version" = "$target_node_version" ]; then
    echo "The \`node --version\` already matches the project version \"$target_node_version\"."
  else
    echo ''
    echo "A different version of NodeJS was detected: $current_node_version."
    echo "Installing NodeJS $target_node_version..."

    set +e
    nvm_install_output=$(nvm install $target_node_version 2>&1)
    nvm_install_exit_code=$?
    set -e

    if bad_exit "$nvm_install_exit_code" || contains "$nvm_install_output" "Failure" || contains "$nvm_install_output" "failed" || contains "$nvm_install_output" "not supported"; then
      echo "$nvm_install_output" 1>&2
      echo '' 1>&2
      echo 'NodeJS installation failed.' 1>&2
      echo 'Subsequent commands may fail.' 1>&2
      echo "Try: \"nvm install $target_node_version\" and then re-run this command." 1>&2
      echo '*Windows: this may require "Run as administrator".' 1>&2
      # IMPORTANT: continue, do not stop
    else
      echo "Successfully installed NodeJS $target_node_version."
    fi

    echo ''
    echo "Switching to NodeJS $target_node_version..."

    set +e
    nvm_use_output=$(nvm use $target_node_version 2>&1)
    nvm_use_exit_code=$?
    set -e

    if bad_exit "$nvm_use_exit_code" || contains "$nvm_use_output" "not installed" || contains "$nvm_use_output" "denied"; then
      echo "$nvm_use_output" 1>&2
      echo '' 1>&2
      echo 'Switching NodeJS version failed.' 1>&2
      echo 'Subsequent commands may fail.' 1>&2
      echo "Try: \"nvm use $target_node_version\" and then re-run this command." 1>&2
      echo '*Windows: this may require "Run as administrator".' 1>&2
      # IMPORTANT: continue, do not stop
    else
      echo "Successfully switched to NodeJS $target_node_version."
    fi
  fi

  if ! command -v node >/dev/null 2>&1; then
    echo 'The CLI for node commands could not be found and must be installed.' 1>&2
    exit 1
  fi
}

#######################################
# Initializes npm.
# Arguments:
#   None
#######################################
init_npm() {

  if ! require npm; then
    echo 'The CLI for npm commands could not be found and must be installed.' 1>&2
    exit 1
  fi

  current_npm_version=$(get_npm_version)
  target_npm_version=$(get_target_npm_version)

  npm_install_required=1

  if [ "$current_npm_version" = "$target_npm_version" ]; then
    echo "The \`npm --version\` already matches the project version \"$target_npm_version\"."
    npm_install_required=0
  else
    echo ''
    echo "Current \`npm --version\` does not match the project version \"$target_npm_version\"."
  fi

  if [ $npm_install_required = 1 ]; then
    echo ''
    echo "Installing npm $target_npm_version..."
    npm install --location=global npm@$target_npm_version
    echo "Successfully installed npm $target_npm_version."
  fi

  npm config set fund false --global
  echo 'Disabled npm funding messages.'
}

#######################################
# Initializes pnpm.
# Arguments:
#   None
#######################################
init_pnpm() {

  # installing pnpm requires npm
  if ! require npm; then
    echo 'The CLI for npm commands could not be found and must be installed.' 1>&2
    exit 1
  fi

  current_pnpm_version=$(get_pnpm_version)
  target_pnpm_version=$(get_target_pnpm_version)

  pnpm_install_required=1

  if require pnpm; then
    if [ "$current_pnpm_version" = "$target_pnpm_version" ]; then
      echo "The \`pnpm --version\` already matches the project version \"$target_pnpm_version\"."
      pnpm_install_required=0
    else
      echo ''
      echo "Current \`pnpm --version\` does not match the project version \"$target_pnpm_version\"."
      echo "Removing the previous version of pnpm..."
      npm uninstall --location=global pnpm || true
      echo "Successfully removed the previous version of pnpm."
    fi
  fi

  if [ $pnpm_install_required = 1 ]; then
    echo ''
    echo "Installing pnpm $target_pnpm_version..."
    npm install --location=global pnpm@$target_pnpm_version
    echo "Successfully installed pnpm $target_pnpm_version."
  fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  init_nvm
  init_node
  init_npm
  init_pnpm
}

main
