#!/bin/sh
#
# Makes repository scripts executable.

set -e

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  echo 'Granting execute permissions to all scripts in the repository...'

  find . -type f -path '*.sh' -not -path './node_modules/*' -exec chmod +x {} \;
  find . -type f -path '*.sh' -not -path './node_modules/*' -exec echo "Granted execute to:" {} \;

  echo 'Successfully granted execute permissions to all scripts in the repository.'
}

main
