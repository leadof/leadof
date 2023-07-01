#!/bin/sh
#
# Starts the web application.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#######################################
# Starts the application.
# Arguments:
#   None
#######################################
start() {
  container_name="leadof-us-dev"

  podman run \
    --name "${container_name}" \
    --detach \
    --publish 4000:4000 \
    leadof-us/web:latest

  podman container inspect "${container_name}" --format "{{.Id}}::{{.ImageDigest}}" >./dist/${container_name}_container-digest.txt

  echo ''
  echo 'Successfully started.'
  echo 'http://localhost:4000/'
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  start
}

main
