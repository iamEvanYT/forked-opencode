#!/usr/bin/env sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

bash "${SCRIPT_DIR}/setup.sh" "${PROJECT_ROOT}"
sudo docker compose up -d
sudo docker compose logs --follow
