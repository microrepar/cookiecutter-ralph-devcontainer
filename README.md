# cookiecutter-ralph-devcontainer

[![Cookiecutter](https://img.shields.io/badge/cookiecutter-2.6%2B-brightgreen.svg)](https://cookiecutter.readthedocs.io/)
[![Python](https://img.shields.io/badge/python-3.13%2B-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/microrepar/cookiecutter-ralph-devcontainer?style=social)](https://github.com/microrepar/cookiecutter-ralph-devcontainer)

A [cookiecutter](https://cookiecutter.readthedocs.io/) template for creating Python projects with a modern development container and the [Ralph](https://github.com/anthropics/anthropic-quickstarts) autonomous agent system.

## Features

- 🐳 **Devcontainer** with Python {{cookiecutter.python_version}}, Docker-in-Docker, and development tools
- 🤖 **Ralph Agents** - Autonomous AI agents for development
- 🔒 **Firewall** - Pre-configured firewall for secure development
- 🛠️ **Pre-installed tools** - poetry, pipx, git, gh, fzf, zsh, vim, jq, delta
- 📦 **Claude Code** - AI assistant integration

## Quick Start

### Prerequisites

```bash
pip install cookiecutter
```

### Generate a Project

```bash
cookiecutter https://github.com/microrepar/cookiecutter-ralph-devcontainer
```

Or clone and generate locally:

```bash
git clone https://github.com/microrepar/cookiecutter-ralph-devcontainer.git
cd cookiecutter-ralph-devcontainer
cookiecutter .
```

### Follow the Prompts

You'll be asked for:
- `project_name` - Name of your project
- `project_slug` - Slug for directory names (auto-generated from project_name)
- `description` - Short description of your project
- `author_name` - Your name
- `author_email` - Your email
- `python_version` - Python version (default: {{cookiecutter.python_version}})
- `timezone` - Container timezone (default: {{cookiecutter.timezone}})
- `git_delta_version` - Git delta version (default: {{cookiecutter.git_delta_version}})
- `zsh_in_docker_version` - Zsh in Docker version (default: {{cookiecutter.zsh_in_docker_version}})
- `docker_gid` - Docker GID (default: {{cookiecutter.docker_gid}})
- `container_user` - Container user name (default: claude_ralph)

### Open in VS Code

```bash
cd {{cookiecutter.project_slug}}
code .
```

When prompted, select **"Reopen in Container"**.

## Example

Here's a quick example of generating a new project:

```bash
$ cookiecutter https://github.com/microrepar/cookiecutter-ralph-devcontainer

project_name [My Python Project]: my-awesome-app
description [A Python project with devcontainer and Ralph agents]: An awesome web application
author_name [Your Name]: John Doe
author_email [your.email@example.com]: john@example.com
python_version [3.13]: 3.12
timezone [America/Sao_Paulo]: America/New_York
```

This creates a new project `my_awesome_app/` with:

```
my_awesome_app/
├── .devcontainer/
│   ├── Dockerfile              # Python 3.12, Node.js, dev tools
│   ├── devcontainer.json       # VS Code config
│   └── init-firewall.sh        # Security firewall
├── .claude/
│   └── skills/                 # PRD and Ralph skills
└── scripts/ralph/              # Autonomous agents
```

Then open in VS Code and start developing! 🚀

## Workflow Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Run            │    │  Container       │    │  Start          │
│  cookiecutter   │───▶│  builds &        │───▶│  developing     │
│                 │    │  installs tools  │    │  with all       │
│                 │    │                  │    │  tools ready    │
└─────────────────┘    └──────────────────┘    └────────┬────────┘
                                                          │
                                                          ▼
                                              ┌─────────────────────┐
                                              │  Use Ralph Agents   │
                                              │  to implement       │
                                              │  features           │
                                              └─────────────────────┘
```

## What's Included

### Devcontainer

- **Python {{cookiecutter.python_version}}** with development tools (poetry, pipx, virtualenv)
- **Docker-in-Docker** - Run Docker commands from within the devcontainer
- **Firewall** - Pre-configured to allow only necessary domains
- **Zsh** with Oh My Zsh and Powerlevel10k theme
- **VS Code extensions** - Python, Pylance, Debugger, Claude Code, GitLens

### Ralph Agents

- **Location**: `scripts/ralph/`
- **Skills**: `.claude/skills/` (PRD generator, Ralph converter)

Ralph is an autonomous AI agent system that can:
- Generate Product Requirements Documents (PRDs)
- Convert PRDs to executable JSON format
- Implement features autonomously based on PRD requirements

To use Ralph:
1. Create a `prd.json` in `scripts/ralph/`
2. Run `./scripts/ralph/ralph.sh`

### Project Structure

```
{{cookiecutter.project_slug}}/
├── .devcontainer/
│   ├── Dockerfile              # Container definition
│   ├── devcontainer.json       # VS Code devcontainer config
│   ├── init-firewall.sh        # Firewall setup script
│   ├── init-docker.sh          # Docker-in-Docker setup
│   ├── verify-setup.sh         # Verification script
│   └── README.md               # Devcontainer documentation
├── .claude/
│   ├── agents/                 # Custom Claude Code agents
│   └── skills/                 # Claude Code skills
│       ├── prd/                # PRD generator skill
│       └── ralph/              # Ralph PRD converter skill
└── scripts/
    └── ralph/                  # Ralph autonomous agent system
        ├── CLAUDE.md           # Agent instructions
        ├── ralph.sh            # Agent runner script
        ├── prd.json            # PRD configuration (create this)
        └── prompt.md           # Custom prompt (optional)
```

## Verification

After opening the project in the devcontainer, run the verification script:

```bash
./.devcontainer/verify-setup.sh
```

This will check:
- Python environment
- Development tools (poetry, pipx, virtualenv)
- Docker-in-Docker functionality
- Firewall configuration
- VS Code integration

## Customization

### Devcontainer

Edit `.devcontainer/Dockerfile` to:
- Add system packages
- Install additional Python tools
- Change base image

Edit `.devcontainer/devcontainer.json` to:
- Add/remove VS Code extensions
- Change container settings
- Modify mount points

### Firewall

Edit `.devcontainer/init-firewall.sh` to:
- Add allowed domains
- Modify firewall rules

### Ralph Agents

Edit `scripts/ralph/CLAUDE.md` to customize agent behavior.

## Troubleshooting

### Container fails to build

Check Docker logs for specific errors. Common issues:
- Port conflicts
- Insufficient disk space
- Network connectivity issues

### Firewall blocking legitimate traffic

Edit `.devcontainer/init-firewall.sh` and add your domain to the allowed domains list, then rebuild the container.

### Python interpreter not detected

In VS Code:
1. `F1` > `Python: Select Interpreter`
2. Choose `/usr/local/bin/python`

### Docker commands not working

Ensure Docker is running on your host machine. The Docker socket is mounted from the host.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

For detailed guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

Quick ways to contribute:
- 🐛 Report bugs
- 💡 Suggest new features
- 📖 Improve documentation
- 🔧 Fix issues
- 🎨 Share your projects built with this template

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- [Augusto Galego - Youtube](https://youtu.be/IJGfd2WTRvg?si=xF6mEJsnZHPZixxK)
- [cookiecutter](https://cookiecutter.readthedocs.io/)
- [Claude Code](https://claude.ai/code)
- [Ralph Agents](https://github.com/anthropics/anthropic-quickstarts)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
