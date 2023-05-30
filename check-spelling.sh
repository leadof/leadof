#!/bin/sh
#
# Checks the project for spelling errors.

set -e

#######################################
# Checks spelling.
# Arguments:
#   None
#######################################
checkSpelling() {
    echo ''
    echo 'Checking spelling...'

    set +e
    check_spelling_output=$(pnpm spellcheck 2>&1)
    check_spelling_exit_code=$?
    set -e

    if [ "$check_spelling_exit_code" = "0" ]; then
      echo 'Successfully checked spelling. All good!'
    else
      echo "$check_spelling_output" 1>&2
      echo '' 1>&2
      echo 'Checking spelling failed.' 1>&2
      exit 1
    fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  checkSpelling
}

main
