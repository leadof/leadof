#!/bin/sh
#
# Function library for podman commands.

copy_files_to_host() {
  image_tag="$1"
  image_name="leadof-tmp_copy__$2"
  container_path="$3"
  host_path="$4"
  timeout="${5:-12000}"

  echo ''
  echo "Copying output files from image \"${image_tag}\"..."
  echo "  Temporary container: \"${image_name}\""
  echo "  Container path: \"${container_path}\""
  echo "  Host path: \"${host_path}\""

  if [ "$(podman ps --all --quiet --filter name=${image_name})" ]; then
    echo "ERROR: temporary container \"${image_name}\" was already running." 1>&2
    echo "Failed to copy output files from container \"${image_tag}\"." 1>&2
    exit 1
  fi

  podman run --name $image_name --detach $image_tag sleep $timeout

  # remove any existing directory
  if [ -d $host_path ]; then
    echo 'WARNING: target directory for copying container files already exists.'
    echo "  Removing \"$host_path\"..."
    rm --recursive --force $host_path
    echo "  Successfully removed \"$host_path\"."
  fi

  echo 'Copying container files...'
  mkdir --parents $host_path

  podman cp $image_name:$container_path $host_path

  echo 'Removing temporary container to copy files...'
  podman rm --force $image_name
  echo 'Successfully removed the temporary container to copy files.'

  echo "Successfully copied output files from container \"${image_tag}\"."
}

get_image_digest() {
  image_tag="$1"
  local digest=$(podman image inspect "${image_tag}" --format "{{.Digest}}")
  echo "$digest"
}

cache_image() {
  image_name="$1"
  image_tag="$2"

  echo 'Generating distribution files...'
  if [ ! -d "./dist/" ]; then
    mkdir "./dist/"
  fi
  echo $(get_image_digest $image_tag) >./dist/${image_name}-container_digest.txt
  echo "Successfully generated \"${image_name}\" distribution files."

  echo ''
  echo "Saving cached image \"${image_name}\"..."
  if [ -f "./.containers/${image_name}-image.tar" ]; then
    rm --force "./.containers/${image_name}-image.tar"
    echo "Removed previously cached image \"${image_name}\"."
  fi
  if [ ! -d "./.containers/" ]; then
    mkdir "./.containers/"
  fi
  podman save --output ./.containers/${image_name}-image.tar $image_tag &
  echo "Successfully saved cached image \"${image_name}\"."
}

load_cached_image() {
  image_name="$1"

  if [ -f "./.containers/${image_name}-image.tar" ]; then
    echo ''
    echo "Loading cached container image \"${image_name}\"..."
    podman load --input ./.containers/${image_name}-image.tar
    echo "Successfully loaded cached container image \"${image_name}\"."
  fi
}
