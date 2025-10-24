# Dev Container Setup

This directory contains the configuration for running Skills API in a VS Code Dev Container.

## Prerequisites

- Docker (or Docker Desktop)
- VS Code with the "Dev Containers" extension installed

## Quick Start

1. **Open the project in Dev Container**:
   - Open the project folder in VS Code
   - Press `F1` and select "Dev Containers: Reopen in Container"
   - Wait for the container to build and dependencies to install

2. **Configure Environment**:
   - Copy `.env.example` to `.env` in the project root:
     ```bash
     cp .devcontainer/.env.example .env
     ```
   - Edit `.env` and add your Anthropic API key:
     ```
     ANTHROPIC_API_KEY=your-api-key-here
     ```

3. **Verify Installation**:
   ```bash
   ruby --version
   bundle --version
   ruby cli.rb --help
   ```

## Usage in Dev Container

All commands work the same as on your local machine:

```bash
# Analyze a CV
ruby cli.rb analyze data-scientist CV_Example.pdf -o report.html

# Identify roles
ruby cli.rb identify-roles CV_Example.pdf -o roles.json

# With logging enabled
ruby cli.rb analyze software-architect CV_Example.pdf -o report.html -l
```

## Container Features

- **Ruby 3.3** environment with all required gems
- **VS Code Extensions** for Ruby development:
  - Ruby language support
  - Rubocop for code linting
  - Test adapter for running tests
- **Git** integration pre-installed
- **Bundler** for dependency management

## Environment Variables

The dev container automatically loads environment variables from the `.env` file in your project root.

## Troubleshooting

### "Dev Containers" extension not found
Install it from VS Code Extensions (Ctrl+Shift+X) by searching for "Dev Containers"

### Container build fails
- Delete the container: Press `F1` → "Dev Containers: Remove Dev Container"
- Rebuild: Press `F1` → "Dev Containers: Reopen in Container"

### Dependencies not installing
Run `bundle install` manually in the terminal:
```bash
bundle install
```

### Cannot access API
Ensure your `ANTHROPIC_API_KEY` is set in the `.env` file and the container has been reopened after creating the file.

## Advanced Configuration

### Mounting Additional Volumes

Edit `.devcontainer/devcontainer.json` and add to the `mounts` array:
```json
"mounts": [
  "source=/path/to/local/dir,target=/workspaces/local-dir,type=bind"
]
```

### Forwarding Ports

If you need to run a web server or other service, add to `forwardPorts`:
```json
"forwardPorts": [3000, 8000]
```

### Custom VS Code Settings

Modify the `customizations.vscode.settings` section in `devcontainer.json` to customize editor behavior.

## Resources

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Container Specification](https://containers.dev/)
- [Ruby Dev Container Reference](https://github.com/devcontainers/images/tree/main/src/ruby)
