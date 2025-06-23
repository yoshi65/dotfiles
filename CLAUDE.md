# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing configuration files for shell (zsh), editors (vim/neovim), and
terminal multiplexer (tmux). It uses symbolic links to deploy configurations to the home directory.

## Architecture

- **Installation**: `install.sh` creates symbolic links from dotfiles to `$HOME/`
- **Shell**: Custom zsh prompt with git integration (shows branch, status indicators)
- **Editor**: Vim/Neovim with lazy.nvim plugin manager (configs in `.config/nvim/lua/`)
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
- `.config/nvim/lua/`: Neovim Lua configuration directory
- `.tigrc`: Git TUI configuration

## Dependencies

- Moralerspace Nerd Font (migrated from RictyDiminished-with-icons-Regular)
- lazy.nvim plugin manager for Neovim
- Claude Code CLI (for nvim integration)

## Modern Configuration

### Neovim Setup

- **Plugin Manager**: lazy.nvim (migrated from dein.vim for 69% performance improvement)
- **Completion**: nvim-cmp with luasnip snippets
- **LSP**: Built-in Neovim LSP with mason.nvim for server management
- **Statusline**: lualine.nvim (migrated from lightline.vim)
- **Git Integration**: gitsigns.nvim + fugitive.vim (migrated from vim-gitgutter)
- **Claude Integration**: coder/claudecode.nvim with folke/snacks.nvim
- **Auto-pairs**: nvim-autopairs (migrated from lexima.vim)
- **Terraform**: Enhanced support with auto-formatting
- **Configuration**: Pure Lua-based modern configuration

### Key Neovim Features

- Tree-sitter syntax highlighting
- Modern completion with snippets
- Claude Code integration for AI assistance
- Git integration with gitsigns and fugitive
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

- **Complete migration**: Successfully migrated from dein.vim to lazy.nvim (Dec 2024)
- **Performance improvement**: Achieved 69% startup time reduction (146ms → 45ms)
- **Modern ecosystem**: Migrated to Lua-based plugins for better maintainability
- **Safe transition**: Used gradual migration approach with fallback mechanisms
- **Legacy cleanup**: Completely removed dein.vim configuration after successful migration

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
2. Verify plugin installation with `:Lazy` status
3. Review error messages in `:messages`
4. Test minimal configuration to isolate issues

## Migration History (2024-2025)

### E897: List or Blob Required Errors

**Problem**: Lambda functions in vim-lsp configuration causing syntax errors
**Solution**: Add spaces around arrow operator in lambda functions

```vim
" WRONG: {server_info->['command']}
" RIGHT: {server_info -> ['command']}
```

### lazy.nvim Migration (December 2024)

**Achievement**: Complete migration from dein.vim to lazy.nvim
**Performance**: 69% startup improvement (146ms → 45ms)
**Benefits**:

- Modern Lua-based configuration
- Better plugin dependency management
- Lazy loading optimization
- Tree-sitter integration

**Key migrations**:

- lightline.vim → lualine.nvim (custom color scheme)
- vim-gitgutter → gitsigns.nvim (better performance)
- lexima.vim → nvim-autopairs (treesitter-aware)
- Manual LSP → mason.nvim + built-in LSP

### Provider Configuration Issues

**Problem**: Outdated paths to Python/Node.js/Ruby hosts causing warnings
**Solution**: Disable unused providers to eliminate noise

```vim
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
```

### Git Workflow Enhancements

**Problem**: Git index lock file conflicts during operations
**Solution**: Intelligent lock file detection and automatic resolution

```lua
-- Enhanced gw keymap with lock file resolution
vim.keymap.set('n', 'gw', function()
  local ok, result = pcall(vim.cmd, 'Gwrite')
  if not ok and result:match('index%.lock') then
    -- Automatically detect and remove stale lock files
    local git_dir = vim.fn.system('git rev-parse --git-dir 2>/dev/null')
    local lock_file = git_dir:gsub('\n', '') .. '/index.lock'
    if vim.fn.filereadable(lock_file) == 1 then
      vim.fn.delete(lock_file)
      pcall(vim.cmd, 'Gwrite') -- Retry operation
    end
  end
end)
```

**Result**: Seamless git operations with automatic error recovery
