# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing configuration files for shell (zsh), editors (vim/neovim), and
terminal multiplexer (tmux). It uses symbolic links to deploy configurations to the home directory.

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

- Moralerspace Nerd Font (migrated from RictyDiminished-with-icons-Regular)
- dein.vim plugin manager for Vim/Neovim
- Claude Code CLI (for nvim integration)

## Modern Configuration

### Neovim Setup

- **Plugin Manager**: dein.vim (considering migration to lazy.nvim)
- **Completion**: nvim-cmp (migrated from ddc.vim)
- **LSP**: vim-lsp (considering migration to built-in nvim LSP)
- **Claude Integration**: coder/claudecode.nvim with folke/snacks.nvim
- **Lua Configuration**: Mixed VimScript/Lua (migrating to pure Lua)

### Key Neovim Features

- Tree-sitter syntax highlighting
- Modern completion with snippets
- Claude Code integration for AI assistance
- Git integration with fugitive and gitgutter
- File explorer with fern.vim

## Security & Best Practices

### .gitignore Strategy

- **Whitelist approach**: `.config/*` blocks all, then allow specific directories
- **Sensitive data protection**: Exclude credentials, tokens, logs, databases
- **Runtime data exclusion**: Block cloud provider configs, session data

### Symbolic Link Management

- **Individual linking**: Link specific `.config` subdirectories, not entire `.config`
- **Backup strategy**: `install.sh` backs up existing files before linking
- **Conflict prevention**: Check for existing configurations before deployment

## Development Lessons Learned

### Plugin Management

- **Verify repository names**: Exact spelling matters (e.g., `claudecode.nvim` not `claude-code.nvim`)
- **Check dependencies**: Always read README for required dependencies
- **Official vs community**: Prefer official plugins when available
- **Gradual migration**: Don't change multiple systems simultaneously

### Configuration Migration

- **Stage changes**: Implement modern features alongside existing setup
- **Conflict detection**: Check for duplicate keybindings and option settings
- **Compatibility testing**: Verify all features work before removing old configs
- **Documentation**: Record migration decisions and configuration choices

### Security Considerations

- **Content auditing**: Review all files before adding to git
- **Credential detection**: Scan for API keys, tokens, personal information
- **Access patterns**: Understand what each tool stores in `.config`
- **Exclusion maintenance**: Regularly update `.gitignore` for new tools

## Troubleshooting

### Common Issues

- **Plugin not found**: Verify exact repository path on GitHub
- **Command not available**: Check if plugin is properly installed and loaded
- **Conflicts**: Look for duplicate settings between VimScript and Lua configs
- **Performance issues**: Review startup time with `:profile start`
- **Lambda function errors**: Ensure proper spacing around `->` in Vim lambda functions
- **Provider warnings**: Disable unused providers (Node.js, Python, Ruby, Perl) if not needed

### Debugging Steps

1. Check `:checkhealth` for system issues
2. Verify plugin installation with `:PluginList` or dein status
3. Review error messages in `:messages`
4. Test minimal configuration to isolate issues

## Recent Error Resolution (2025-06-23)

### E897: List or Blob Required Errors

**Problem**: Lambda functions in vim-lsp configuration causing syntax errors
**Solution**: Add spaces around arrow operator in lambda functions

```vim
" WRONG: {server_info->['command']}
" RIGHT: {server_info -> ['command']}
```

### Snacks.nvim Setup Errors

**Problem**: Plugin setup not called, causing health check failures
**Solution**: Use `hook_source` instead of `hook_add` for plugin initialization

```toml
[[plugins]]
repo = 'folke/snacks.nvim'
hook_source = '''
lua << EOF
require("snacks").setup({})
EOF
'''
```

### Provider Configuration Issues

**Problem**: Outdated paths to Python/Node.js/Ruby hosts causing warnings
**Solution**: Disable unused providers to eliminate noise

```vim
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
```

### Legacy LSP Server Configuration

**Problem**: Manual LSP server registration conflicting with vim-lsp-settings
**Solution**: Remove manual server configurations; let vim-lsp-settings handle auto-detection

- Removed manual `pyls` and `clangd` configurations
- Keep vim-lsp-settings plugin for automatic LSP management
