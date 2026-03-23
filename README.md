# Evan's Forked OpenCode

## Installation

To install, use the installation script:
```bash
curl -fsSL https://raw.githubusercontent.com/iamEvanYT/forked-opencode/refs/heads/main/install.sh | bash
```

## Features

- Show estimated costs on GitHub Copilot usage, so you can find out how much credits you used.
- Improve Premium Request handling for GitHub Copilot provider.
- Optional Codex proxy support for ChatGPT Pro/Plus OAuth traffic.

## Codex Proxy

This fork can route Codex requests through a proxy without changing the OAuth flow. OpenCode still obtains the normal ChatGPT OAuth tokens, then sends the resulting Codex HTTP requests to your proxy instead of directly to `chatgpt.com`.

Recommended proxy:

- [iamEvanYT/codex-proxy](https://github.com/iamEvanYT/codex-proxy)

Supported env vars:

```bash
export OPENCODE_CODEX_PROXY_BASE_URL=http://localhost:3000
export OPENCODE_CODEX_PROXY_ACCESS_CODE=your-local-gate
```

Behavior:

- If `OPENCODE_CODEX_PROXY_BASE_URL` is unset, Codex requests go directly to the normal Codex endpoint.
- If `OPENCODE_CODEX_PROXY_BASE_URL` is set, Codex requests are sent to that proxy base URL.
- If `OPENCODE_CODEX_PROXY_ACCESS_CODE` is set, OpenCode adds it as the `x-access-code` header on proxied Codex requests.
- The proxy access code is only for your proxy. OpenCode still sends the normal upstream OAuth headers like `authorization` and `ChatGPT-Account-Id`, and the proxy should forward those to Codex.
