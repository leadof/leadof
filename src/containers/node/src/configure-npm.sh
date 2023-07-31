#!/bin/sh

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

set_npm_registry() {
  url="$1"
  old_url_prefix="${2:-}"
  url_prefix="${3:-}"
  auth="${4:-}"
  auth_token="${5:-}"

  echo ''
  echo "Configuring npm registry to \"${url}\"..."
  npm config --global set registry "${url}"

  if [ x"${old_url_prefix}" != "x" ]; then
    npm config delete "${old_url_prefix}:_auth"
    npm config delete "${old_url_prefix}:_authToken"
  fi

  if [ x"${auth}" != "x" ]; then
    npm config --global set "${url_prefix}:_auth" "${auth}"
  fi

  if [ x"${auth_token}" != "x" ]; then
    npm config --global set "${url_prefix}:_authToken" "${auth_token}"
  fi

  echo "Successfully configured npm registry to \"${url}\"."
}

main() {
  npm_version="$1"
  pnpm_version="$2"
  registry_url="${3:-}"
  registry_old_url_prefix="${4:-}"
  registry_url_prefix="${5:-}"
  registry_auth="${6:-}"
  registry_auth_token="${7:-}"

  npm config --global set fund false --global
  echo 'Disabled npm fund messages.'

  if [ x"${registry_url}" != "x" ]; then
    set_npm_registry \
      "${registry_url}" \
      "${registry_old_url_prefix}" \
      "${registry_url_prefix}" \
      "${registry_auth}" \
      "${registry_auth_token}"
  fi

  echo ''
  echo "Installing npm version \"${npm_version}\"..."
  npm install --location=global npm@${npm_version}
  echo "Successfully installed npm version \"${npm_version}\"."

  echo ''
  echo "Installing pnpm version \"${pnpm_version}\"..."
  npm install --location=global pnpm@${pnpm_version}
  echo "Successfully installed pnpm version \"${pnpm_version}\"."

  echo ''
  echo 'Node version:'
  node --version
  echo 'npm version:'
  npm --version
  echo 'pnpm version:'
  pnpm --version
}

main "$@"
