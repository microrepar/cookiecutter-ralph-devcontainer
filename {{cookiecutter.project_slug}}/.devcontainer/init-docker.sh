#!/bin/bash
# Configure Docker access for {{cookiecutter.container_user}} user
set -euo pipefail

# Ensure docker group exists with correct GID
DOCKER_GID=${DOCKER_GID:-1001}
if ! getent group docker >/dev/null; then
    groupadd --gid "$DOCKER_GID" docker || true
fi

# Add {{cookiecutter.container_user}} to docker group
if ! groups {{cookiecutter.container_user}} | grep -q '\bdocker\b'; then
    usermod -aG docker {{cookiecutter.container_user}}
    echo "Added {{cookiecutter.container_user}} to docker group"
fi

# Fix socket permissions if needed
if [ -S /var/run/docker.sock ]; then
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
    echo "Fixed /var/run/docker.sock permissions"
fi

echo "Docker access configured for {{cookiecutter.container_user}}"
