# Contributing to cookiecutter-ralph-devcontainer

First off, thank you for considering contributing to this template! It's people like you that make the open-source community such a great place to learn and create.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## How to Contribute

There are many ways to contribute:

- **Report bugs** - If you find a bug, please open an issue
- **Suggest features** - Have an idea? Let us know!
- **Submit pull requests** - Fix bugs, add features, improve documentation
- **Improve documentation** - Help make the template easier to use
- **Share your experience** - Blog about it, show your projects

## Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/cookiecutter-ralph-devcontainer.git
cd cookiecutter-ralph-devcontainer
```

### 2. Install Dependencies

```bash
pip install cookiecutter
```

### 3. Test Your Changes

```bash
# Generate a test project
cookiecutter .

# Or test with specific values
cookiecutter . project_name="Test Project" python_version="3.12"
```

### 4. Verify Generated Projects

After making changes, always test that the generated projects work:

```bash
cd <generated_project>
code .

# Then in VS Code, reopen in container and verify:
# - Container builds successfully
# - All tools are installed (run ./.devcontainer/verify-setup.sh)
# - Ralph agents work correctly
```

## Submitting Changes

### Step 1: Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### Step 2: Make Your Changes

- **Follow the existing code style**
- **Update documentation** if you change functionality
- **Test thoroughly** with different cookiecutter variable values
- **Keep changes focused** - one PR per feature/fix

### Step 3: Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature"
# or
git commit -m "fix: resolve issue with XYZ"
```

**Commit message format:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Formatting, code style
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### Step 4: Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then open a Pull Request on GitHub with:
- Clear title and description
- Reference any related issues
- Screenshot if applicable (for UI changes)

### PR Review Process

- Your PR will be reviewed as soon as possible
- Address any feedback requests
- Keep the conversation friendly and constructive

## Reporting Bugs

### Before Creating a Bug Report

- **Check existing issues** - Someone may have already reported it
- **Test with the latest version** - The issue may already be fixed
- **Isolate the problem** - Make sure it's this template, not your setup

### Bug Report Template

```markdown
### Description
A clear description of the bug.

### Steps to Reproduce
1. Generate project with these cookiecutter values: `...`
2. Run this command: `...`
3. Observe this error: `...`

### Expected Behavior
What you expected to happen.

### Actual Behavior
What actually happened.

### Environment
- OS: [e.g., Ubuntu 22.04, Windows 11, macOS 14]
- Docker version: [e.g., 24.0.7]
- VS Code version: [e.g., 1.85.0]
- Cookiecutter version: [e.g., 2.6.0]

### Additional Context
Logs, screenshots, or any other relevant information.
```

## Suggesting Enhancements

### Feature Requests

We welcome feature suggestions! Before proposing:

1. **Check if it fits the scope** - This is a Python devcontainer template
2. **Consider the audience** - Will this benefit most users?
3. **Think about maintenance** - Can we maintain this long-term?

### Feature Request Template

```markdown
### Feature Description
A clear description of the proposed feature.

### Problem Statement
What problem does this solve? Why do we need it?

### Proposed Solution
How should it work? Any implementation ideas?

### Alternatives Considered
What other options did you think about?

### Additional Context
Examples, references, or mockups if applicable.
```

## Coding Guidelines

### Python Code

- Follow PEP 8 style guide
- Use type hints where appropriate
- Add docstrings to functions and classes
- Keep functions focused and small

### Shell Scripts

- Use `set -euo pipefail` for error handling
- Quote variables: `"$VAR"` not `$VAR`
- Add comments for complex logic
- Make scripts executable: `chmod +x script.sh`

### JSON Files

- Use 2-space indentation
- No trailing commas
- Double quotes for strings and keys

## Documentation

When adding features:

1. **Update README.md** - Add feature to the list
2. **Update cookiecutter.json** - Add new variables with defaults
3. **Add comments** - Explain complex parts
4. **Update examples** - Show how to use the feature

## Testing

### Manual Testing Checklist

Before submitting a PR, test:

- [ ] Generate project with default values
- [ ] Generate project with custom values
- [ ] Container builds successfully
- [ ] All tools installed (run `./.devcontainer/verify-setup.sh`)
- [ ] Ralph agents work correctly
- [ ] No errors in container logs
- [ ] Documentation is accurate

## Getting Help

- **GitHub Issues** - For bugs and feature requests
- **Discussions** - For questions and ideas
- **Existing documentation** - Check README and generated project docs

## Code of Conduct

Be respectful, constructive, and inclusive. We're all here to learn and build great things together.

## Recognition

Contributors will be acknowledged in the project documentation. Thank you for your contributions!

---

**Questions?** Feel free to open an issue or discussion. We're here to help!
