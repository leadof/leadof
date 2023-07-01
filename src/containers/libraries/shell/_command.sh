#!/bin/sh
#
# Function library for commands.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Loads environment variables from a .env file.
# Arguments:
#   None
#######################################
dotenv() {
  if [ -f './.env' ]; then
    unamestr=$(uname)
    echo "Loading .env environment variables for the system \"${unamestr}\"..."

    if [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then
      export $(grep -v '^#' ./.env | xargs -0)
    else # Linux
      export $(grep -v '^#' ./.env | xargs -d '\n')
    fi

    echo "Successfully loaded .env environment variables for the system \"${unamestr}\"..."
  fi
}

#######################################
# Marks all scripts as executable.
# Arguments:
#   None
#######################################
mark_scripts_executable() {
  echo 'Granting execute permissions to all scripts in the repository...'

  find . -type f -path '*.sh' -not -path './node_modules/*' -exec chmod +x {} \;
  find . -type f -path '*.sh' -not -path './node_modules/*' -exec echo "Granted execute to:" {} \;

  echo 'Successfully granted execute permissions to all scripts in the repository.'
}

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
