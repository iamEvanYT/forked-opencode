# OpenCode Playground

This is a Docker image for running OpenCode inside an isolated Ubuntu-based development environment.

The goal is not a minimal runtime container. The goal is a container the agent can live in and use like a normal CLI dev box.

## Image workflow

- The development image is defined in `Dockerfile`.
- It includes common Ubuntu CLI and development tools, plus `sudo`, `nano`, `ripgrep`, `fd`, `jq`, `tmux`, `tree`, `build-essential`, Node via `nvm`, Bun, GitHub CLI, and OpenCode.
- The container runs as the non-root `opencode` user with passwordless sudo.
- The default working directory is `/projects`.
- The compose setup mounts the parent directory at `/workspaces`, so sibling cloned repos are accessible from inside the container.

## Compose workflow

`docker-compose.yml` and the `scripts/` helpers are still the main way to run the image as a long-lived sandbox.
