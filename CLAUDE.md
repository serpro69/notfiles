# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages shell configurations, CLI tools, and development environment setup primarily for zsh across macOS and Linux systems. The repository uses symlinks to manage dotfiles in the user's home directory.

## Architecture & Structure

### Core Configuration System

The dotfiles are managed through a custom directory structure that symlinks files into the user's home directory:

- **`.redpill/`** - The main directory where most dotfiles are symlinked (created from symlinks in init.zsh)
- **`init.zsh`** - Installation script that creates symlinks for all dotfiles
- **`dotfiles_config`** - Configuration file that defines environment settings (default user, ZSH plugins, theme, etc.)

### Key Components

**Shell Configuration Hierarchy:**
1. `~/.zshenv` - Created by init.zsh, sets ZDOTDIR and sources `.redpill/.zshenv`
2. `zshenv` - Environment variables and PATH setup (symlinked to `.redpill/.zshenv`)
3. `zprofile` - Login shell configuration (symlinked to `.redpill/.zprofile`)
4. `zshrc` - Interactive shell setup, loads oh-my-zsh and sources other configs (symlinked to `.redpill/.zshrc`)
5. Sources in order: `aliases`, `exports`, `extra`, `functions`, and `*.sops` files

**Platform-Specific Configs:**
- `alacritty/darwin/` and `alacritty/linux/` - Platform-specific alacritty terminal configs
- `git/darwin/` and `git/linux/` - Platform-specific git configurations
- Automatically selected by init.zsh based on `$OSTYPE`

**Custom Plugins & Themes:**
- `bluepill/` - Custom zsh plugins and themes (ZSH_CUSTOM directory)
- `ohmyzsh/` - Oh-My-Zsh framework (git submodule)
- Spaceship prompt theme configured via `spaceshiprc.zsh`

**Configuration Files:**
- `aliases` - Shell aliases (cross-platform compatible)
- `functions` - Shell functions (utilities like `swap`, `remind`, `fh`, `vl`)
- `exports` - Environment variable exports
- `extra` - Additional utilities (optional, user prompted during init)
- `exports.sops` - Encrypted secrets managed with SOPS

**Tool-Specific Configs:**
- `git/` - Git configuration split into `config`, `config.delta`, and `config.extra`
- `tmux/` and `tmux.conf.local` - Tmux configuration
- `vimrc`, `vimrc.bundles`, `ideavimrc`, `vrapperrc` - Vim/Neovim configurations
- `karabiner/` - Keyboard customization for macOS
- `alacritty/` - Alacritty terminal emulator configuration
- `mise.zsh` - Version manager integration

## Installation & Setup

### Initial Setup

```bash
# Clone with submodules
git clone --recurse-submodules git@github.com:serpro69/dotfiles.git ~/dotfiles

# Run installation
cd ~/dotfiles
./init.zsh

# Restart shell
exec zsh
```

The init script:
- Creates symlinks for all dotfiles defined in the `dotfiles` array
- Handles platform-specific configs automatically
- Decrypts SOPS-encrypted files (requires SOPS and age keys)
- Prompts to link the optional `extra` file
- Creates necessary directories (e.g., `~/.redpill/completions`)

### Prerequisites

Key dependencies documented in README.md:
- `zsh` (set as default shell)
- Modern CLI tools: `fzf`, `bat`, `delta`, `eza`, `fd`, `ripgrep`, `sd`
- Optional: `alacritty` terminal

## Testing

The repository includes testing infrastructure for validating dotfiles in isolated environments:

### Docker Testing

```bash
# Build test image
docker build -f test/Dockerfile -t dotfiles-test:latest .
```

### Vagrant Testing

```bash
# From test/ directory
make vagrant_up          # Start and provision VM
make vagrant_rebuild     # Destroy and recreate VM
```

Requirements: `vagrant`, `vagrant-scp` plugin, `virtualbox`

## CI/CD

GitHub Actions workflow (`.github/workflows/lint.yml`):
- Runs `gitleaks` to scan for leaked secrets on all pushes

## Important Conventions

### Symlink Management

All dotfiles are symlinked, not copied. Editing a file in the repository immediately affects the active configuration.

### Platform Detection

Functions check platform with:
- `is_darwin()` - macOS detection
- `is_zsh()` - zsh shell detection
- Platform-specific aliases/functions are conditionally defined

### SOPS Encryption

Sensitive files use SOPS encryption:
- Configuration: `.sops.yaml`
- Encrypted files have `.sops` extension
- Decrypted during init.zsh to `.redpill/` directory

### ZSH Plugins

Plugins are configured in `dotfiles_config` via `CONFIG_ZSH_PLUGINS` variable. The extensive plugin list includes development tools (git, docker, kubectl, terraform/opentofu), utilities (fzf-tab, zsh-autosuggestions, fast-syntax-highlighting), and custom integrations.

### Path Management

Custom functions in `zshenv`:
- `_prepend_path()` - Add to beginning of PATH
- `_append_path()` - Add to end of PATH
- `path_remove()` - Remove from PATH

## Common Patterns

### Aliases

Global terminating aliases (zsh-specific) use `-g` flag:
- `:L` pipes to less
- `:H` pipes to head
- `:G` pipes to grep
- `:NE`, `:NO`, `:NUL` for output redirection

### Functions

Anonymous functions used for conditional aliasing:
```bash
alias foo='_f() { command args "$1"; unset -f _f }; _f'
```

### GNU Tools on macOS

When GNU findutils/coreutils are installed via Homebrew or MacPorts, aliases map to prefixed versions:
- `find` → `gfind`
- `date` → `gdate`
- `make` → `gmake`
- `sed` → `gsed`
- etc.

## macOS-Specific Setup

Post-install steps documented in README.md:
- Update iTerm2 preferences to load from `~/dotfiles/config/iterm2`
- Disable Keyboard Shortcuts for Input Sources (`^space` conflicts)

## Development Workflow

When modifying dotfiles:
1. Edit files in the repository (they're already active via symlinks)
2. Test changes in current shell or restart with `exec zsh`
3. Commit changes to git
4. Changes automatically apply on any system that has these dotfiles installed
