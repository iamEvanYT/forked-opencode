#!/usr/bin/env bash

set -euo pipefail

mkdir -p "${HOME}/.config/git"
touch "${HOME}/.config/git/config"

if [ -e "${HOME}/.gitconfig" ] && [ ! -L "${HOME}/.gitconfig" ]; then
  rm -rf "${HOME}/.gitconfig"
fi

ln -sfn "${HOME}/.config/git/config" "${HOME}/.gitconfig"

exec opencode serve --hostname 0.0.0.0
