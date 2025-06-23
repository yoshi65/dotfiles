# dotfiles

Personal dotfiles repository for managing development environment configurations with modern tooling and AI integration.

## 🛠️ Included Configurations

### Core Tools

* **Shell**: zsh with custom git-aware prompt
* **Editor**: vim/neovim with lazy.nvim plugin manager (69% performance improvement)
* **Terminal**: tmux with vim-like keybindings
* **Git**: tig for TUI, enhanced gitignore patterns

### Modern Features

* **AI Integration**: Claude Code support for nvim (with immediate command availability)
* **Completion**: nvim-cmp with luasnip for intelligent autocompletion
* **LSP**: Built-in Neovim LSP with mason.nvim for server management
* **Syntax**: Tree-sitter for enhanced highlighting
* **Statusline**: lualine.nvim with custom color schemes
* **Git Integration**: gitsigns.nvim + fugitive.vim with intelligent lock file resolution
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
    ├── nvim/              # Neovim with lazy.nvim configuration
    │   └── lua/           # Modern Lua-based plugin configuration
    ├── git/               # Git settings
    └── template/          # Code templates
```

## 🔧 Key Features

### Shell (zsh)

* Git-aware prompt with branch status
* Custom aliases and functions
* Environment optimization

### Neovim

* lazy.nvim plugin manager for 69% faster startup (146ms → 45ms)
* Built-in LSP with mason.nvim for automatic server management
* Modern completion with nvim-cmp and luasnip snippets
* Claude Code AI integration with immediate command availability
* Tree-sitter syntax highlighting
* lualine.nvim statusline with custom color schemes
* Enhanced git workflow with automatic lock file resolution

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
nvim -c ":Lazy sync" -c "q"

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

* **Plugin commands not available**: Some plugins need `lazy = false` for immediate command registration
* **E897 errors**: Check lambda function syntax (`{var -> expr}` not `{var->expr}`)
* **Git index lock**: Automatic resolution implemented in git workflow
* **Provider warnings**: Disable unused providers to reduce noise
* **Startup performance**: Use lazy loading strategically, but not for critical plugins

### Health Check Commands

```bash
# Full system health check
:checkhealth

# Specific component checks
:checkhealth lsp
:checkhealth nvim-treesitter
:checkhealth claudecode
:checkhealth lazy
```

### Quick Fixes

```vim
" Disable optional providers
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Check plugin status
:Lazy
```

---

## 📚 Migration History

### lazy.nvim Migration (December 2024)

Successfully migrated from dein.vim to lazy.nvim with significant improvements:

* **Performance**: 69% startup time reduction (146ms → 45ms)
* **Modern ecosystem**: Pure Lua-based configuration
* **Enhanced features**: Better dependency management and lazy loading
* **Critical lesson**: Some plugins require `lazy = false` for immediate command availability

For detailed migration history, troubleshooting guides, and configuration examples, see [CLAUDE.md](./CLAUDE.md).

---

**Note**: This repository emphasizes security, modularity, and modern development practices with AI-powered development workflows.
