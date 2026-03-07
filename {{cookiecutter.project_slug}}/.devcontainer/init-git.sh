#!/bin/bash
# init-git.sh - Configuração do Git para ambientes com fakeowner
# Gerado por cookiecutter-ralph-devcontainer

set -e

WORKSPACE="/workspace"
GIT_DIR="/tmp/{{ cookiecutter.project_slug }}-git"
GIT_REPO_SYMLINK="$WORKSPACE/.git"

# Se já existe um symlink funcional, não fazer nada
if [ -L "$GIT_REPO_SYMLINK" ] && [ -d "$GIT_REPO_SYMLINK" ]; then
    echo "✓ Git já configurado corretamente"
    exit 0
fi

# Se existe um .git local (problemático), backup
if [ -d "$GIT_REPO_SYMLINK" ] && [ ! -L "$GIT_REPO_SYMLINK" ]; then
    echo "⚠️  Detectado .git local problemático, criando backup..."
    mv "$GIT_REPO_SYMLINK" "${GIT_REPO_SYMLINK}.backup.$(date +%s)"
fi

# Criar repositório Git em /tmp
if [ ! -d "$GIT_DIR" ]; then
    echo "→ Criando repositório Git em $GIT_DIR..."
    mkdir -p "$GIT_DIR"
    GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git init
    GIT_DIR="$GIT_DIR" git config core.worktree "$WORKSPACE"

    # Fazer commit inicial se não houver commits
    if [ -z "$(GIT_DIR="$GIT_DIR" git rev-parse --short HEAD 2>/dev/null)" ]; then
        echo "→ Criando commit inicial..."
        GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git add -A
        GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git commit -m "feat: initial commit"
    fi
fi

# Criar symlink
echo "→ Criando symlink $GIT_REPO_SYMLINK → $GIT_DIR"
ln -s "$GIT_DIR" "$GIT_REPO_SYMLINK"

echo "✓ Git configurado com sucesso!"
