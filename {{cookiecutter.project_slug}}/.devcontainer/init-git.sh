#!/bin/bash
# init-git.sh - Configuração do Git para ambientes com fakeowner
# Este script resolve problemas do Git com o sistema de arquivos fakeowner
# usado por Docker/VS Code em montagens de volume.
# Gerado por cookiecutter-ralph-devcontainer

set -e

# Configurações
WORKSPACE="${workspaceFolder:-/workspace}"
GIT_DIR_BASE="/git-storage"
PROJECT_NAME="${devcontainerId:-{{ cookiecutter.project_slug}}}"
GIT_DIR="$GIT_DIR_BASE/${PROJECT_NAME}-git"
GIT_REPO_SYMLINK="$WORKSPACE/.git"

echo "→ Configurando Git para fakeowner..."
echo "  Workspace: $WORKSPACE"
echo "  Git Dir: $GIT_DIR"

# Se já existe um symlink funcional, não fazer nada
if [ -L "$GIT_REPO_SYMLINK" ] && [ -d "$(readlink -f "$GIT_REPO_SYMLINK")" ]; then
    echo "✓ Git já configurado corretamente"
    echo "  Symlink: $(readlink -f "$GIT_REPO_SYMLINK")"
    exit 0
fi

# Se existe um .git local (problemático), migrar para o volume persistente
if [ -d "$GIT_REPO_SYMLINK" ] && [ ! -L "$GIT_REPO_SYMLINK" ]; then
    echo "⚠️  Detectado .git local problemático, migrando para volume persistente..."
    echo "  Origem: $GIT_REPO_SYMLINK"
    echo "  Destino: $GIT_DIR"

    # Se já existe um repositório no volume, fazer backup
    if [ -d "$GIT_DIR" ]; then
        BACKUP_DIR="${GIT_DIR}.backup.$(date +%s)"
        echo "  Repositório de destino já existe, criando backup: $BACKUP_DIR"
        mv "$GIT_DIR" "$BACKUP_DIR"
    fi

    # Criar diretório de destino
    mkdir -p "$GIT_DIR"

    # Mover conteúdo do .git local para o volume
    echo "  Migrando conteúdo..."
    cp -a "$GIT_REPO_SYMLINK"/* "$GIT_DIR"/
    rm -rf "$GIT_REPO_SYMLINK"

    echo "  ✓ Migração concluída"
else
    echo "✓ Nenhum .git local encontrado para migrar"
fi

# Criar ou verificar repositório Git no volume persistente
if [ ! -d "$GIT_DIR" ]; then
    echo "→ Criando repositório Git em $GIT_DIR..."
    mkdir -p "$GIT_DIR"

    # Inicializar repositório
    GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git init -q
    GIT_DIR="$GIT_DIR" git config core.worktree "$WORKSPACE"

    # Configurações recomendadas
    GIT_DIR="$GIT_DIR" git config core.fileMode false
    GIT_DIR="$GIT_DIR" git config core.trustctime false

    # Fazer commit inicial se não houver commits
    if GIT_DIR="$GIT_DIR" git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -z "$(GIT_DIR="$GIT_DIR" git rev-parse --short HEAD 2>/dev/null)" ]; then
            echo "→ Criando commit inicial..."
            GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git add -A
            GIT_DIR="$GIT_DIR" GIT_WORK_TREE="$WORKSPACE" git commit -q -m "feat: initial commit"
            echo "  Commit inicial criado"
        fi
    fi
else
    echo "✓ Repositório Git já existe em $GIT_DIR"
    # Verificar se tem commits
    if GIT_DIR="$GIT_DIR" git rev-parse --git-dir > /dev/null 2>&1; then
        COMMIT_COUNT=$(GIT_DIR="$GIT_DIR" git rev-list --all --count 2>/dev/null || echo "0")
        echo "  Commits existentes: $COMMIT_COUNT"
        if [ "$COMMIT_COUNT" -gt 0 ]; then
            echo "  Último commit: $(GIT_DIR="$GIT_DIR" git log -1 --format='%h - %s' 2>/dev/null || echo 'N/A')"
        fi
    fi
fi

# Criar symlink
echo "→ Criando symlink $GIT_REPO_SYMLINK → $GIT_DIR"
ln -s "$GIT_DIR" "$GIT_REPO_SYMLINK"

# Verificar configuração
if GIT_DIR="$GIT_DIR" git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✓ Git configurado com sucesso!"
    echo "  Repo: $GIT_DIR"
    echo "  Worktree: $WORKSPACE"
    echo "  Branch: $(GIT_DIR="$GIT_DIR" git branch --show-current 2>/dev/null || echo 'main')"
    echo "  Status: $(GIT_DIR="$GIT_DIR" git status --short 2>/dev/null | wc -l) arquivos modificados"
else
    echo "✗ Erro na configuração do Git"
    exit 1
fi
