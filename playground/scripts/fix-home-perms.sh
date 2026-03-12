#!/usr/bin/env bash

set -euo pipefail

TARGET_PATH="${1:-.}"
TARGET_UID="${TARGET_UID:-1000}"
TARGET_GID="${TARGET_GID:-1000}"

if [ ! -d "${TARGET_PATH}" ]; then
  echo "Creating ${TARGET_PATH}"
  sudo mkdir -p "${TARGET_PATH}"
fi

echo "Fixing ownership on ${TARGET_PATH} to ${TARGET_UID}:${TARGET_GID}"
sudo chown -R "${TARGET_UID}:${TARGET_GID}" "${TARGET_PATH}"

echo "Creating OpenCode runtime directories"
sudo install -d -o "${TARGET_UID}" -g "${TARGET_GID}" -m 755 \
  "${TARGET_PATH}/volumes/local" \
  "${TARGET_PATH}/volumes/config" \
  "${TARGET_PATH}/volumes/cache"

echo "Done. Restart the container after this."
