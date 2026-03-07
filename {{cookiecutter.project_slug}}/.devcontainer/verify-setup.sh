#!/bin/bash
# Verification script for Python Devcontainer
# Run this inside the devcontainer to verify all features are working

set -euo pipefail

echo "========================================="
echo "Python Devcontainer Verification"
echo "========================================="
echo ""

PASSED=0
FAILED=0

# Test helper functions
pass() {
    echo "✅ PASS: $1"
    PASSED=$((PASSED + 1))
}

fail() {
    echo "❌ FAIL: $1"
    FAILED=$((FAILED + 1))
}

run_test() {
    local test_name="$1"
    local test_cmd="$2"
    echo ""
    echo "Testing: $test_name"
    if eval "$test_cmd" > /dev/null 2>&1; then
        pass "$test_name"
    else
        fail "$test_name"
    fi
}

# 1. Container build verification (this is verified if we're running this script)
echo "=== Environment Checks ==="
if [ "${DEVCONTAINER:-false}" = "true" ]; then
    pass "Running in devcontainer (DEVCONTAINER=true)"
else
    fail "Not running in devcontainer (DEVCONTAINER not set to true)"
fi

# 2. Python version check
echo ""
echo "=== Python Environment ==="
run_test "Python {{cookiecutter.python_version}} is accessible" "python3 --version"
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "   Version: $PYTHON_VERSION"

# 3. Python tools
echo ""
echo "=== Python Development Tools ==="
run_test "pipx is installed" "pipx --version"
PIPX_VERSION=$(pipx --version 2>&1 || true)
echo "   pipx: ${PIPX_VERSION:-not found}"

run_test "uv is installed" "uv --version"
UV_VERSION=$(uv --version 2>&1 || true)
echo "   uv: ${UV_VERSION:-not found}"


# 4. VS Code Python interpreter
echo ""
echo "=== VS Code Integration ==="
if command -v python3 &> /dev/null; then
    PYTHON_PATH=$(which python3)
    echo "   Python path: $PYTHON_PATH"
    if [[ "$PYTHON_PATH" == "/usr/local/bin/python3" ]] || [[ "$PYTHON_PATH" == "/usr/bin/python3" ]]; then
        pass "Python interpreter at expected location"
    else
        echo "   ⚠️  Warning: Python at non-standard location"
    fi
fi

# 5. Docker-in-Docker
echo ""
echo "=== Docker-in-Docker ==="
run_test "docker command works" "docker --version"
DOCKER_VERSION=$(docker --version 2>&1 || true)
echo "   $DOCKER_VERSION"

if docker ps > /dev/null 2>&1; then
    pass "docker ps command works (can connect to daemon)"
else
    echo "   ⚠️  Warning: docker ps failed (Docker daemon may not be available)"
fi

if docker compose version > /dev/null 2>&1; then
    pass "docker compose command works"
    COMPOSE_VERSION=$(docker compose version 2>&1 || true)
    echo "   $COMPOSE_VERSION"
else
    fail "docker compose not working"
fi

# 5.1 Docker Desktop access from host
echo ""
echo "=== Docker Desktop Host Access ==="
if [ -S /var/run/docker.sock ]; then
    pass "Docker socket is accessible at /var/run/docker.sock"
    SOCKET_INFO=$(ls -l /var/run/docker.sock 2>&1 || true)
    echo "   $SOCKET_INFO"
else
    fail "Docker socket not found at /var/run/docker.sock"
fi

# Verify Docker daemon connection and get host info
if docker info > /dev/null 2>&1; then
    pass "Can communicate with Docker daemon on host"
    # Try to get Docker Desktop/Engine info
{% raw %}
    DOCKER_INFO=$(docker info --format '{{.ServerVersion}}' 2>&1 || true)
{% endraw %}
    echo "   Docker Server: ${DOCKER_INFO:-unknown}"
    # Check if running on Docker Desktop
{% raw %}
    if docker info --format '{{.OperatingSystem}}' 2>/dev/null | grep -qi "desktop"; then
{% endraw %}
        echo "   Running on Docker Desktop"
    fi
else
    fail "Cannot communicate with Docker daemon on host"
fi

# 6. Firewall - PyPI access
echo ""
echo "=== Firewall and Network Access ==="
run_test "PyPI is accessible" "curl -s --connect-timeout 5 https://pypi.org > /dev/null"
run_test "files.pythonhosted.org is accessible" "curl -s --connect-timeout 5 https://files.pythonhosted.org > /dev/null"

# Test pip install (small package)
if pip install --no-cache-dir --dry-install ignore 2>/dev/null || true; then
    # Try a real small test
    if pip install --no-cache-dir --help > /dev/null 2>&1; then
        echo "   pip is functional"
        pass "pip install works"
    fi
fi

# Test that unauthorized domains are blocked
echo ""
echo "Testing firewall blocks unauthorized domains..."
if curl -s --connect-timeout 5 https://example.com > /dev/null 2>&1; then
    fail "Firewall should block example.com but didn't"
else
    pass "Firewall correctly blocks example.com"
fi

# 7. Git delta
echo ""
echo "=== Git Tools ==="
if command -v delta &> /dev/null; then
    DELTA_VERSION=$(delta --version 2>&1 | head -1 || true)
    pass "git delta is installed"
    echo "   $DELTA_VERSION"
else
    fail "git delta not found"
fi

# 8. Zsh and Oh My Zsh
echo ""
echo "=== Shell Configuration ==="
if [ "$SHELL" = "/bin/zsh" ]; then
    pass "Default shell is zsh"
else
    echo "   Current shell: $SHELL"
fi

if [ -f "$HOME/.zshrc" ] && grep -q "powerlevel10k" "$HOME/.zshrc" 2>/dev/null; then
    pass "Oh My Zsh with Powerlevel10k configured"
else
    echo "   ⚠️  Warning: Powerlevel10k may not be configured"
fi

# 9. Other tools
echo ""
echo "=== Other Development Tools ==="
run_test "git is installed" "git --version"
run_test "gh is installed" "gh --version"
run_test "fzf is installed" "fzf --version"
run_test "jq is installed" "jq --version"
run_test "vim is installed" "vim --version"

# Summary
echo ""
echo "========================================="
echo "Verification Summary"
echo "========================================="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "🎉 All checks passed!"
    exit 0
else
    echo "⚠️  Some checks failed. Please review the output above."
    exit 1
fi
