#!/bin/sh

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

. ../libraries/shell/_command.sh

#######################################
# Setup a new Nexus server.
# Arguments:
#   None
#######################################
setup_nexus() {
  nexus_url="$1"

  echo ''
  echo 'Pulling Java Groovy container image...'
  podman pull docker.io/library/groovy:4.0.12-jdk17-jammy
  echo 'Successfully pulled Java Groovy container image.'

  echo ''
  echo "Running Nexus initialization scripts..."
  podman run \
    --name init-nexus-groovy \
    --rm \
    --interactive \
    --tty \
    --network host \
    --volume $(pwd):/usr/src/nexus \
    --workdir /usr/src/nexus/ \
    --env NEXUS_ADMIN_USERNAME=${NEXUS_ADMIN_USERNAME} \
    --env NEXUS_ADMIN_DEFAULT_PASSWORD=${NEXUS_ADMIN_DEFAULT_PASSWORD} \
    --env NEXUS_ADMIN_PASSWORD=${NEXUS_ADMIN_PASSWORD} \
    --env NEXUS_DEV_USERNAME=${NEXUS_DEV_USERNAME} \
    --env NEXUS_DEV_PASSWORD=${NEXUS_DEV_PASSWORD} \
    docker.io/library/groovy:4.0.12-jdk17-jammy \
    /usr/src/nexus/initialize.sh "${nexus_url}"

  echo ''
  echo "Successfully ran Nexus initialization scripts."
}

#######################################
# Installs a Nexus server.
# Arguments:
#   None
#######################################
install_nexus() {

  if [ x"${NEXUS_ADMIN_USERNAME}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_ADMIN_USERNAME".' 1>&2
    exit 1
  fi

  if [ x"${NEXUS_ADMIN_DEFAULT_PASSWORD}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_ADMIN_DEFAULT_PASSWORD".' 1>&2
    exit 1
  fi

  if [ x"${NEXUS_ADMIN_PASSWORD}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_ADMIN_PASSWORD".' 1>&2
    exit 1
  fi

  if [ x"${NEXUS_DEV_USERNAME}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_DEV_USERNAME".' 1>&2
    exit 1
  fi

  if [ x"${NEXUS_DEV_PASSWORD}" = "x" ]; then
    echo ''
    echo 'Missing required environment variable named "NEXUS_DEV_PASSWORD".' 1>&2
    exit 1
  fi

  nexus_data_name="nexus-data"
  nexus_image_tag="leadof/nexus:latest"
  nexus_container_name="nexus"
  nexus_port=8081
  nexus_url="http://localhost:${nexus_port}"

  set +e
  nexus_data_exists_output=$(podman volume exists ${nexus_data_name} 2>&1)
  nexus_data_exists_exit_code=$?
  set -e

  echo ''
  if [ $nexus_data_exists_exit_code = 0 ]; then
    echo "The Nexus data volume already exists and is named \"${nexus_data_name}\"."
  else
    echo "Creating a Nexus data volume named \"${nexus_data_name}\"..."
    podman volume create "${nexus_data_name}"
    # wait a few seconds for volume readiness
    printf '...'
    sleep 5
    echo "Successfully created a Nexus data volume named \"${nexus_data_name}\"."
  fi

  is_nexus_new_install=0
  is_nexus_first_start=0

  if [ ! "$(podman ps --all --quiet --filter name=${nexus_container_name})" ]; then
    is_nexus_new_install=1
    is_nexus_first_start=1
    echo ''
    echo 'Creating a new instance of Nexus server...'
    podman run \
      --name ${nexus_container_name} \
      --detach \
      --publish ${nexus_port}:${nexus_port} \
      --volume ${nexus_data_name}:/nexus-data:U \
      localhost/${nexus_image_tag}
    echo 'Successfully created a new instance of Nexus server.'
  else
    nexus_requires_start=0

    if [ "$(podman ps --all --quiet --filter status=exited --filter name=${nexus_container_name})" ]; then
      nexus_requires_start=1
    fi

    if [ "$(podman ps --all --quiet --filter status=created --filter name=${nexus_container_name})" ]; then
      nexus_requires_start=1
    fi

    if [ $nexus_requires_start = 1 ]; then
      is_nexus_first_start=1
      echo ''
      echo 'Starting existing Nexus server...'
      podman start ${nexus_container_name}
      echo 'Successfully started Nexus server.'
    else
      echo ''
      echo "Nexus server is already running with the name \"${nexus_container_name}\"."
    fi
  fi

  wait_for_nexus_attempt_counter=0
  wait_for_nexus_max_attempts=24 # 120 seconds (2 minutes) / 5 seconds = 24
  wait_for_nexus_seconds=5

  echo ''
  echo "Checking for a response at the URL \"${nexus_url}\"..."
  printf '...'

  until $(curl --silent --head --fail ${nexus_url} >/dev/null); do
    if [ ${wait_for_nexus_attempt_counter} -eq ${wait_for_nexus_max_attempts} ]; then
      echo 'Max attempts reached while waiting for Nexus to start!' 1>&2
      exit 1
    fi

    printf '.'
    wait_for_nexus_attempt_counter=$(($wait_for_nexus_attempt_counter + 1))
    sleep ${wait_for_nexus_seconds}
  done

  if [ $is_nexus_first_start = 1 ]; then
    # give Nexus a brief moment to setup
    printf '.'
    sleep 5
    printf '.'
    sleep 5
    printf '.'
    sleep 5
    printf '.'
    sleep 5
    printf '.'
    sleep 5
    printf '.'
    sleep 5
  fi

  echo ''
  echo "Successfully got a response at the URL \"${nexus_url}\"."

  if [ $is_nexus_new_install = 1 ]; then
    echo ''
    echo 'New installation of Nexus server requires additional configuration.'

    setup_nexus $nexus_url
  fi
}

#######################################
# Script entry point.
# Arguments:
#   None
#######################################
main() {
  install_nexus
}

# env vars must be global to the script
dotenv

main
