# Build stage for the GitHub CLI package.
FROM ubuntu:24.04 AS gh-builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gpg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Build stage for Bun, nvm, and the default Node.js installation.
FROM ubuntu:24.04 AS tool-builder

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/opt/nvm
ENV BUN_INSTALL=/opt/bun

SHELL ["/bin/bash", "-lc"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates curl unzip \
    && mkdir -p "${NVM_DIR}" "${BUN_INSTALL}" \
    && curl -fsSL https://bun.sh/install | env BUN_INSTALL="${BUN_INSTALL}" bash \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && source "${NVM_DIR}/nvm.sh" \
    && nvm install --lts \
    && nvm alias default lts/* \
    && ln -s "${NVM_DIR}/versions/node/$(nvm version default)" /opt/node-current \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Final runtime image with only the required tools and a non-root user.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=opencode
ENV HOME=/home/opencode
ENV UID=1000
ENV GID=1000
ENV NVM_DIR=/opt/nvm
ENV BUN_INSTALL=/opt/bun

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates curl git \
    && USER_GROUP="$(getent group "${GID}" | cut -d: -f1)" \
    && if [ -z "${USER_GROUP}" ]; then groupadd --gid "${GID}" "${USER}"; USER_GROUP="${USER}"; fi \
    && useradd --uid "${UID}" --gid "${USER_GROUP}" --create-home --shell /bin/bash "${USER}" \
    && mkdir -p /projects "${HOME}/.opencode/bin" "${NVM_DIR}" "${BUN_INSTALL}" \
    && chown -R "${USER}:${USER}" /projects "${HOME}" "${NVM_DIR}" "${BUN_INSTALL}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy runtime artifacts from the builder stages.
COPY --from=gh-builder /usr/bin/gh /usr/bin/gh
COPY --from=tool-builder /opt/nvm /opt/nvm
COPY --from=tool-builder /opt/bun /opt/bun
COPY --from=tool-builder /opt/node-current /opt/node-current

# Load nvm automatically for interactive shells.
RUN printf 'export NVM_DIR="%s"\n[ -s "%s/nvm.sh" ] && . "%s/nvm.sh"\n' "${NVM_DIR}" "${NVM_DIR}" "${NVM_DIR}" \
        > /etc/profile.d/nvm.sh \
    && ln -sf /opt/bun/bin/bun /usr/local/bin/bun \
    && ln -sf /opt/node-current/bin/node /usr/local/bin/node \
    && ln -sf /opt/node-current/bin/npm /usr/local/bin/npm \
    && ln -sf /opt/node-current/bin/npx /usr/local/bin/npx \
    && chown -R "${USER}:${USER}" "${NVM_DIR}" "${BUN_INSTALL}"

USER ${USER}
WORKDIR /projects

# Install Evan's fork of OpenCode into the non-root user's environment.
RUN curl -fsSL https://raw.githubusercontent.com/iamEvanYT/forked-opencode/refs/heads/main/install.sh | bash \
    && test -x "${HOME}/.opencode/bin/opencode"

USER root
RUN ln -sf "${HOME}/.opencode/bin/opencode" /usr/local/bin/opencode \
    && command -v opencode

USER ${USER}

CMD ["opencode", "serve", "--hostname", "0.0.0.0"]
