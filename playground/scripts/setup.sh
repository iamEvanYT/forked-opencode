#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_TARGET_PATH="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET_PATH="${1:-${DEFAULT_TARGET_PATH}}"
TARGET_UID="${TARGET_UID:-1000}"
TARGET_GID="${TARGET_GID:-1000}"
PROJECTS_PATH="${TARGET_PATH}/projects"
VOLUMES_PATH="${TARGET_PATH}/volumes"
LOCAL_PATH="${VOLUMES_PATH}/local"
CACHE_PATH="${VOLUMES_PATH}/cache"
CONFIG_PATH="${VOLUMES_PATH}/config"
GITCONFIG_PATH="${CONFIG_PATH}/gitconfig"

if [ ! -d "${TARGET_PATH}" ]; then
  echo "Creating ${TARGET_PATH}"
  sudo mkdir -p "${TARGET_PATH}"
fi

echo "Creating OpenCode bind-mount directories in ${TARGET_PATH}"
sudo install -d -o "${TARGET_UID}" -g "${TARGET_GID}" -m 755 \
  "${PROJECTS_PATH}" \
  "${LOCAL_PATH}" \
  "${LOCAL_PATH}/share" \
  "${CACHE_PATH}" \
  "${CONFIG_PATH}"

if [ ! -e "${GITCONFIG_PATH}" ]; then
  echo "Creating ${GITCONFIG_PATH}"
  sudo install -o "${TARGET_UID}" -g "${TARGET_GID}" -m 644 /dev/null "${GITCONFIG_PATH}"
fi

echo "Fixing ownership on bind-mount paths to ${TARGET_UID}:${TARGET_GID}"
sudo chown -R "${TARGET_UID}:${TARGET_GID}" \
  "${PROJECTS_PATH}" \
  "${VOLUMES_PATH}"

echo "Setup complete."
