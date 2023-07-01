#!/bin/sh

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

#####################################################
# Uploads a named script to the Nexus server.
# Arguments:
#   None
#####################################################
upload_script() {
  nexus_url=$1
  nexus_username=$2
  nexus_password=$3
  script_name=$4
  script_file_name=$5

  echo "Uploading \"${script_file_name}\" as script \"${script_name}\"..."
  groovy \
    -Dgroovy.grape.report.downloads=true \
    ./addUpdateScript.groovy \
    --username "$nexus_username" \
    --password "$nexus_password" \
    --name "$script_name" \
    --file "$script_file_name" \
    --host "$nexus_url"
  echo "Successfully uploaded \"${script_file_name}\" as script \"${script_name}\"."
}

#####################################################
# Deletes a named, remote script from the Nexus server.
# Arguments:
#   None
#####################################################
delete_script() {
  nexus_url=$1
  nexus_username=$2
  nexus_password=$3
  script_name=$4

  echo "Deleting remote script \"${script_name}\"..."
  curl \
    --verbose \
    --request DELETE \
    --user $nexus_username:$nexus_password \
    "$nexus_url/service/rest/v1/script/${script_name}"
  echo "Successfully deleted remote script \"${script_name}\"."
}

#####################################################
# Executes a named, remote script on the Nexus server.
# Arguments:
#   None
#####################################################
execute_script() {
  nexus_url=$1
  nexus_username=$2
  nexus_password=$3
  script_name=$4
  script_data=$5

  echo "Executing remote script \"${script_name}\"..."
  curl \
    --verbose \
    --user $nexus_username:$nexus_password \
    --header "Content-Type: text/plain" \
    --data $script_data \
    "$nexus_url/service/rest/v1/script/${script_name}/run"
  echo "Successfully executed remote script \"${script_name}\"."
}

upload_and_execute_script_once() {
  nexus_url=$1
  nexus_username=$2
  nexus_password=$3
  script_name=$4
  script_file_name=$5
  script_data=$6

  echo "Run remote script \"${script_name}\"..."

  upload_script \
    ${nexus_url} \
    ${nexus_username} \
    ${nexus_password} \
    ${script_name} \
    ${script_file_name}

  execute_script \
    ${nexus_url} \
    ${nexus_username} \
    ${nexus_password} \
    ${script_name} \
    ${script_data}

  delete_script \
    ${nexus_url} \
    ${nexus_username} \
    ${nexus_password} \
    ${script_name}

  echo ''
  echo "Successfully ran remote script \"${script_name}\"."
}

main() {
  nexus_url="$1"

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

  security_config_json="{\"admin\":{\"password\":\"${NEXUS_ADMIN_PASSWORD}\"},\"dev\":{\"username\":\"${NEXUS_DEV_USERNAME}\",\"password\":\"${NEXUS_DEV_PASSWORD}\"}}"

  upload_and_execute_script_once \
    ${nexus_url} \
    ${NEXUS_ADMIN_USERNAME} \
    ${NEXUS_ADMIN_DEFAULT_PASSWORD} \
    "security" \
    "security.groovy" \
    ${security_config_json}

  npm_config_json="{\"npm\":{\"registry\":\"https://registry.npmjs.org\"}}"

  upload_and_execute_script_once \
    ${nexus_url} \
    ${NEXUS_ADMIN_USERNAME} \
    ${NEXUS_ADMIN_PASSWORD} \
    "npm" \
    "npm.groovy" \
    ${npm_config_json}
}

main "$@"
