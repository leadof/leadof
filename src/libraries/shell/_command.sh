#!/bin/sh
#
# Function library for commands.

set -e

#######################################
# Checks if a command is available.
# Arguments:
#   cmd
# Returns:
#   0 if the specified command is available;
#   otherwise, returns 1.
#######################################
require() {
  cmd="$1"

  if command -v $cmd >/dev/null 2>&1; then
    return 0 # $substring is in $string
  else
    return 1 # $substring is not in $string
  fi
}

#######################################
# Checks if a string contains a substring.
# Arguments:
#   string
#   substring
# Returns:
#   0 if the specified string contains the specified substring;
#   otherwise, returns 1.
#######################################
contains() {
  string="$1"
  substring="$2"

  if [ "${string#*"$substring"}" != "$string" ]; then
    return 0 # $substring is in $string
  else
    return 1 # $substring is not in $string
  fi
}

#######################################
# Checks if the exit code was "clean" (0).
# Arguments:
#   last_exit_code
# Returns:
#   0 if the last_exit_code was 0
#   otherwise, returns 1.
#######################################
clean_exit() {
  last_exit_code="$1"

  if [ "${last_exit_code}" = "0" ]; then
    return 0 # clean exit
  else
    return 1 # bad exit
  fi
}

#######################################
# Checks if the exit code was "bad" (not 0).
# Arguments:
#   last_exit_code
# Returns:
#   0 if the last_exit_code was not 0
#   otherwise, returns 1.
#######################################
bad_exit() {
  last_exit_code="$1"

  if [ "${last_exit_code}" = "0" ]; then
    return 1 # clean exit
  else
    return 0 # bad exit
  fi
}