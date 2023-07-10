#!/bin/sh
#
# Function library for podman commands.

################################################################################
# Executes a containerized command.
# Arguments:
#   - container_name: name of the container
#   - volume_mount_path: path to the volume to mount
#   - container_command: command to execute
#   - podman_image_tag: optional tag for podman
#   - podman_storage_cache_path: optional path to podman storage cache
#   - pnpm_storage_cache_path: optional path to pnpm storage cache
################################################################################
containerized_command() {
  current_directory_path=$(pwd)

  container_name="$1"
  volume_mount_path="${2:-$current_directory_path}"
  container_command="$3"
  podman_image_tag="${4:-quay.io/podman/stable:v4.5.1}"

  # podman_storage_cache_path="${5:-/home/user/.local/share/containers/storage}"
  podman_storage_cache_path="${5:-$volume_mount_path/.containers/storage}"

  if [ ! -d $podman_storage_cache_path ]; then
    mkdir --parents $podman_storage_cache_path
  fi

  # podman_storage_overlay_cache_path="$podman_storage_cache_path/overlay"
  # podman_storage_overlay_images_cache_path="$podman_storage_cache_path/overlay-images"
  # podman_storage_overlay_layers_cache_path="$podman_storage_cache_path/overlay-layers"

  # if [ ! -d $podman_storage_overlay_cache_path ]; then
  #   mkdir --parents $podman_storage_overlay_cache_path
  # fi

  # if [ ! -d $podman_storage_overlay_images_cache_path ]; then
  #   mkdir --parents $podman_storage_overlay_images_cache_path
  # fi

  # if [ ! -d $podman_storage_overlay_layers_cache_path ]; then
  #   mkdir --parents $podman_storage_overlay_layers_cache_path
  # fi

  # pnpm_storage_cache_path=$(pnpm store path)
  pnpm_storage_cache_path="${6:-$volume_mount_path/.containers/pnpm-store}"

  if [ ! -d $pnpm_storage_cache_path ]; then
    mkdir --parents $pnpm_storage_cache_path
  fi

  echo ''
  echo "Starting podman in container \"$container_name\"..."

  podman run \
    --name $container_name \
    --rm \
    --interactive \
    --tty \
    --privileged \
    --network host \
    --volume $podman_storage_cache_path:/var/lib/containers/storage/:U,z \
    --volume $pnpm_storage_cache_path:/var/cache/pnpm:U \
    --volume $volume_mount_path:/context \
    --workdir /context/ \
    $podman_image_tag \
    $container_command

  # --volume $podman_storage_overlay_cache_path:/var/lib/containers/storage/overlay \
  # --volume $podman_storage_overlay_images_cache_path:/var/lib/containers/storage/overlay-images \
  # --volume $podman_storage_overlay_layers_cache_path:/var/lib/containers/storage/overlay-layers \
}
