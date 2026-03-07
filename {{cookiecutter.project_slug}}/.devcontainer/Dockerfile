FROM python:3.13-slim

ARG TZ
ENV TZ=${TZ}

# Install basic development tools and iptables/ipset
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  git \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  nano \
  vim \
  curl \
  wget \
  locales \
  ca-certificates \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure locale for Brazil
RUN sed -i 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen pt_BR.UTF-8 && \
  update-locale LANG=pt_BR.UTF-8 LANGUAGE=pt_BR:pt LC_ALL=pt_BR.UTF-8

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:pt
ENV LC_ALL=pt_BR.UTF-8

# Install Docker CLI (for Docker-in-Docker support)
RUN install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
  chmod a+r /etc/apt/keyrings/docker.asc && \
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Node.js 22.x Installation ---
# Uses NodeSource repository for version 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
  apt-get install -y nodejs && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Create codata user ---
RUN groupadd --gid 1000 codata \
    && useradd --uid 1000 --gid codata --shell /bin/bash --create-home codata

# --- Configure docker group for Docker-in-Docker ---
ARG DOCKER_GID=1001
RUN groupadd --gid ${DOCKER_GID} docker || true \
    && usermod -aG docker codata

# Ensure default codata user has access to /usr/local/share
RUN mkdir -p /usr/local/share && \
  chown -R codata:codata /usr/local/share

ARG USERNAME=codata

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/codata/.claude && \
  chown -R codata:codata /workspace /home/codata/.claude

WORKDIR /workspace

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Install Python development tools
RUN pip install --no-cache-dir --upgrade pip

# Set up non-root user
USER codata

# Set PATH to include poetry, pipx and local node binaries
ENV PATH=/home/codata/.local/bin:$PATH

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=vim
ENV VISUAL=vim

# Default powerline10k theme
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude
RUN curl -fsSL https://claude.ai/install.sh | bash

 # Install UV (Python task runner) and tools
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv tool install ignr && \
    uv tool install cookiecutter --force && \
    uv tool install poetry && \
    uv tool install pipx

# Copy and set up firewall, docker and git scripts
COPY init-firewall.sh /usr/local/bin/
COPY init-docker.sh /usr/local/bin/
COPY init-git.sh /usr/local/bin/init-git.sh
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh /usr/local/bin/init-docker.sh /usr/local/bin/init-git.sh && \
  echo "{{cookiecutter.container_user}} ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/{{cookiecutter.container_user}}-firewall && \
  echo "{{cookiecutter.container_user}} ALL=(root) NOPASSWD: /usr/local/bin/init-docker.sh" > /etc/sudoers.d/{{cookiecutter.container_user}}-docker && \
  chmod 0440 /etc/sudoers.d/{{cookiecutter.container_user}}-firewall /etc/sudoers.d/{{cookiecutter.container_user}}-docker
USER {{cookiecutter.container_user}}
