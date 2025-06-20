# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing configuration files for shell (zsh), editors (vim/neovim), and terminal multiplexer (tmux). It uses symbolic links to deploy configurations to the home directory.

## Architecture

- **Installation**: `install.sh` creates symbolic links from dotfiles to `$HOME/`
- **Shell**: Custom zsh prompt with git integration (shows branch, status indicators)
- **Editor**: Vim/Neovim with dein.vim plugin manager (configs in `.config/dein/`)
- **Terminal**: Tmux with custom prefix key (C-q) and vim-like keybindings
- **Templates**: Code templates for various languages in `.config/template/`

## Commands

### Deployment
```bash
./install.sh    # Create symbolic links for all dotfiles
```

### Key Bindings
- **Tmux prefix**: `C-q` (not default C-b)
- **Tmux pane navigation**: `h/j/k/l` (vim-like)
- **Tmux split**: `v` (vertical), `s` (horizontal)

## Important Files

- `.zshrc`: Shell configuration with custom git-aware prompt
- `.vimrc` & `.config/nvim/init.vim`: Editor configurations
- `.tmux.conf`: Terminal multiplexer setup
- `.config/dein/dein.toml`: Vim plugin management
- `.tigrc`: Git TUI configuration

## Dependencies

- RictyDiminished-with-icons-Regular font
- dein.vim plugin manager for Vim/Neovim