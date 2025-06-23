# dotfiles

Personal dotfiles repository for managing development environment configurations with modern tooling and AI integration.

## 🛠️ Included Configurations

### Core Tools

* **Shell**: zsh with custom git-aware prompt
* **Editor**: vim/neovim with modern plugin ecosystem
* **Terminal**: tmux with vim-like keybindings
* **Git**: tig for TUI, enhanced gitignore patterns

### Modern Features

* **AI Integration**: Claude Code support for nvim
* **Completion**: nvim-cmp for intelligent autocompletion
* **Syntax**: Tree-sitter for enhanced highlighting
* **Package Management**: Brewfile for dependency management
* **Security**: Whitelist-based .gitignore for sensitive data protection

## 🚀 Quick Start

### Installation

```bash
git clone https://github.com/yoshi65/dotfiles.git
cd dotfiles
./install.sh
```

### Optional: Install dependencies

```bash
brew bundle  # Install packages from Brewfile
```

## 📁 Repository Structure

```bash
├── install.sh              # Safe installation with backup
├── Brewfile               # Package dependencies
├── CLAUDE.md              # AI assistant context
├── .zshrc/.zshenv         # Shell configuration
├── .vimrc                 # Vim configuration
├── .tmux.conf             # Terminal multiplexer
├── .tigrc                 # Git TUI configuration
└── .config/
    ├── nvim/              # Neovim configuration
    ├── dein/              # Plugin management
    ├── git/               # Git settings
    └── template/          # Code templates
```

## 🔧 Key Features

### Shell (zsh)

* Git-aware prompt with branch status
* Custom aliases and functions
* Environment optimization

### Neovim

* Modern completion with nvim-cmp
* Claude Code AI integration
* Tree-sitter syntax highlighting
* LSP support for development

### Tmux

* Custom prefix key (C-q)
* Vim-like pane navigation
* Enhanced status line

## 🔒 Security

* Whitelist-based .gitignore prevents credential leaks
* Automatic backup before installation
* Individual .config directory management
* Sensitive data exclusion patterns

## 📋 Dependencies

### Required

* [Moralerspace Nerd Font](https://github.com/yuru7/moralerspace)
* [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (for AI integration)

### Optional

* Homebrew (for package management)
* Node.js (via volta)
* Python (via uv)

## 💡 Usage Tips

### Neovim with Claude Code

```vim
" Launch Claude Code
:ClaudeCode

" Send selection to Claude
(select text in visual mode)
\as

" Add current file to Claude context
\ab
```

### Tmux Navigation

```bash
# Split windows
C-q v  # vertical split
C-q s  # horizontal split

# Navigate panes
C-q h/j/k/l  # vim-like movement
```

## 🔄 Maintenance

```bash
# Update plugins
nvim -c "call dein#update()" -c "q"

# Update packages
brew bundle
brew upgrade

# Health check for neovim
nvim -c "checkhealth" -c "q"

# Backup current config
cp -r ~/.config ~/.config.backup
```

## 🐛 Troubleshooting

### Common Error Patterns

* **E897 errors**: Check lambda function syntax (`{var -> expr}` not `{var->expr}`)
* **Plugin setup failures**: Use `hook_source` for Lua plugin initialization
* **Provider warnings**: Disable unused providers to reduce noise
* **LSP conflicts**: Remove manual configurations when using vim-lsp-settings

### Health Check Commands

```bash
# Full system health check
:checkhealth

# Specific component checks
:checkhealth lsp
:checkhealth nvim-treesitter
:checkhealth snacks
```

### Quick Fixes

```vim
" Disable optional providers
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Check plugin status
:call dein#check_install()
```

---

**Note**: This repository emphasizes security, modularity, and modern development practices.
Review CLAUDE.md for detailed configuration guidance and recent error resolution examples.
