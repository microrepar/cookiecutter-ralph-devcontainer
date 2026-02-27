#!/usr/bin/env python3
"""Post-generation hook for cookiecutter-ralph-devcontainer."""

import os
import subprocess
import sys

PROJECT_DIR = os.getcwd()


def make_scripts_executable():
    """Make shell scripts executable."""
    scripts = [
        ".devcontainer/init-firewall.sh",
        ".devcontainer/init-docker.sh",
        ".devcontainer/verify-setup.sh",
        "scripts/ralph/ralph.sh"
    ]

    for script in scripts:
        path = os.path.join(PROJECT_DIR, script)
        if os.path.exists(path):
            os.chmod(path, 0o755)
            print(f"Made executable: {script}")


def rename_example_files():
    """Rename .example files to actual files."""
    examples = [
        "scripts/ralph/prd.json.example",
        "scripts/ralph/prompt.md.example"
    ]

    for example in examples:
        src = os.path.join(PROJECT_DIR, example)
        dst = src.replace(".example", "")
        if os.path.exists(src):
            os.rename(src, dst)
            print(f"Renamed: {example} -> {dst.replace(PROJECT_DIR + '/', '')}")


def initialize_git():
    """Initialize git repository and make initial commit."""
    if os.path.exists(os.path.join(PROJECT_DIR, ".git")):
        print("Git repository already exists, skipping initialization.")
        return

    try:
        # Initialize git
        subprocess.run(["git", "init"], cwd=PROJECT_DIR, check=True, capture_output=True)
        print("Initialized git repository")

        # Add all files
        subprocess.run(["git", "add", "."], cwd=PROJECT_DIR, check=True, capture_output=True)
        print("Added files to git")

        # Create initial commit
        subprocess.run(
            ["git", "commit", "-m", "chore: initial commit from cookiecutter template"],
            cwd=PROJECT_DIR,
            check=True,
            capture_output=True
        )
        print("Created initial commit")

    except subprocess.CalledProcessError as e:
        print(f"Warning: Git initialization failed: {e}", file=sys.stderr)
        print("You can initialize git manually later.")


def print_success_message():
    """Print success message with next steps."""
    project_name = os.path.basename(PROJECT_DIR)

    print("\n" + "=" * 60)
    print(f"✨ Project '{project_name}' generated successfully!")
    print("=" * 60)
    print("\n📋 Next steps:")
    print(f"   1. cd {project_name}")
    print("   2. Open the project in VS Code")
    print("   3. When prompted, select 'Reopen in Container'")
    print("   4. After container builds, verify setup:")
    print("      ./.devcontainer/verify-setup.sh")
    print("\n🤖 To use Ralph agents:")
    print("   1. Edit scripts/ralph/prd.json with your feature requirements")
    print("   2. Run: ./scripts/ralph/ralph.sh")
    print("\n📚 For more information, see:")
    print("   - .devcontainer/README.md - Devcontainer documentation")
    print("   - scripts/ralph/CLAUDE.md - Ralph agent instructions")
    print("=" * 60)


def main():
    """Run all post-generation steps."""
    print("Running post-generation hooks...")

    make_scripts_executable()
    rename_example_files()
    initialize_git()
    print_success_message()


if __name__ == "__main__":
    main()
