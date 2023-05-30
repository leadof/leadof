#!/bin/sh
#
# Checks the project's formatting against a set of rules.

set -e

#######################################
# Checks formatting.
# Arguments:
#   None
#######################################
checkFormatting() {
    echo ''
    echo 'Checking formatting...'

    set +e
    check_formatting_output=$(pnpm lint 2>&1)
    check_formatting_exit_code=$?
    set -e

    if [ "$check_formatting_exit_code" = "0" ]; then
      echo 'Successfully checked formatting. All good!'
    else
      echo "$check_formatting_output" 1>&2
      echo '' 1>&2
      echo 'Checking formatting failed.' 1>&2
      exit 1
    fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  checkFormatting
}

main
