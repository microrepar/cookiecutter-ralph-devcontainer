# {{cookiecutter.project_name }}

{{cookiecutter.description }}

This project was generated from the [cookiecutter-ralph-devcontainer](https://github.com/microrepar/cookiecutter-ralph-devcontainer) template.

## Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your host machine
- [Visual Studio Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Quick Start

1. Open this project in VS Code
2. When prompted, select "Reopen in Container" or use `F1` > `Dev Containers: Reopen in Container`

The container will be built automatically with all the necessary tools.

## Pre-installed Tools

| Tool | Version | Description |
|------|---------|-------------|
| Python | {{cookiecutter.python_version }} | Main Python interpreter |
| pip | Latest | Python package installer |
| pipx | Latest | Install and run Python applications in isolated environments |
| poetry | Latest | Modern Python dependency management and packaging |
| virtualenv | Latest | Create virtual environments |
| git | Latest | Version control |
| gh | Latest | GitHub CLI |
| fzf | Latest | Fuzzy finder |
| zsh | Latest | Z shell with Oh My Zsh and Powerlevel10k theme |
| vim | Latest | Text editor |
| jq | Latest | JSON processor |
| delta | {{cookiecutter.git_delta_version }} | Better git diff viewer |
| docker | Latest | Docker CLI (for Docker-in-Docker) |
| docker compose | Latest (v2) | Docker Compose plugin |

## VS Code Extensions

The following extensions are automatically installed:

- **ms-python.python** - Python language support
- **ms-python.vscode-pylance** - Python IntelliSense and linting
- **ms-python.debugger** - Python debugging support
- **anthropic.claude-code** - Claude Code AI assistant
- **eamodio.gitlens** - Git supercharged

## Ralph Agents

This project includes the Ralph autonomous agent system:

- **Location**: `scripts/ralph/`
- **Skills**: `.claude/skills/` (PRD generator, Ralph converter)

To use Ralph:
1. Create a `prd.json` in `scripts/ralph/` following the example format
2. Run `./scripts/ralph/ralph.sh` to start autonomous development

### Ralph Skills

- **prd**: Generate Product Requirements Documents for new features
- **ralph**: Convert PRDs to Ralph's JSON format for autonomous execution

## Configuration

### Timezone

The container timezone is set to `{{cookiecutter.timezone}}`. To change it, modify the `TZ` build arg in `.devcontainer/devcontainer.json`.

### Shell

The default shell is Zsh with Oh My Zsh and Powerlevel10k theme. Your shell history is persisted across container rebuilds.

### Customization

To customize the devcontainer:

1. **Dockerfile**: Modify `.devcontainer/Dockerfile` to add system packages or Python tools
2. **devcontainer.json**: Update extensions, settings, or mounts in `.devcontainer/devcontainer.json`
3. **init-firewall.sh**: Add or remove allowed domains in `.devcontainer/init-firewall.sh`

> **Note:** The firewall includes some specific domains (e.g., `open.bigmodel.cn`, `z.ai`). You can remove these if you don't need them or add your own required domains.

## Verification

Run the verification script inside the container to check all features:

```bash
./.devcontainer/verify-setup.sh
```

## Author

**{{cookiecutter.author_name }}** - {{cookiecutter.author_email }}

## License

Specify your project license here.
