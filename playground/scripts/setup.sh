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
GIT_DIR_PATH="${CONFIG_PATH}/git"
GITCONFIG_PATH="${GIT_DIR_PATH}/config"
OC_PATH="${VOLUMES_PATH}/oc"
OC_COMMANDS_PATH="${OC_PATH}/commands"
OC_CONFIG_PATH="${OC_PATH}/opencode.json"

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
  "${CONFIG_PATH}" \
  "${GIT_DIR_PATH}" \
  "${OC_PATH}" \
  "${OC_COMMANDS_PATH}"

if [ ! -e "${GITCONFIG_PATH}" ]; then
  echo "Creating ${GITCONFIG_PATH}"
  sudo install -o "${TARGET_UID}" -g "${TARGET_GID}" -m 644 /dev/null "${GITCONFIG_PATH}"
fi

if [ ! -e "${OC_CONFIG_PATH}" ]; then
  echo "Creating ${OC_CONFIG_PATH}"
  echo '{}' | sudo tee "${OC_CONFIG_PATH}" > /dev/null
  sudo chown "${TARGET_UID}:${TARGET_GID}" "${OC_CONFIG_PATH}"
  sudo chmod 644 "${OC_CONFIG_PATH}"
fi

echo "Fixing ownership on bind-mount paths to ${TARGET_UID}:${TARGET_GID}"
sudo chown -R "${TARGET_UID}:${TARGET_GID}" \
  "${PROJECTS_PATH}" \
  "${VOLUMES_PATH}"

echo "Setup complete."
