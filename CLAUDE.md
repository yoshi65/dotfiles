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
- **Plugin loading**: Critical lesson - some plugins need `lazy = false` to ensure commands are available immediately

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

### Claude Code Plugin Loading Issue (December 2024)

**Problem**: ClaudeCode commands not available after lazy.nvim migration
**Root cause**: Plugin loading with `event = "VeryLazy"` prevented immediate command registration
**Solution**: Change to `lazy = false` and explicit setup call

```lua
{
  "coder/claudecode.nvim",
  lazy = false, -- Load immediately to ensure commands are available
  config = function()
    require("claudecode").setup()
  end,
}
```

**Lesson**: Critical plugins that provide commands should not be lazy-loaded if immediate availability is required

### Configuration Cleanup (June 2025)

**Problem**: Legacy configurations and plugin conflicts after migration
**Issues identified**:

- FZF keymaps remained after plugin removal (causing command errors)
- Duplicate vim-fugitive loading in both `core.lua` and `git.lua`
- LSP configuration referencing Telescope without proper dependency

**Solutions applied**:

- Removed orphaned FZF keymaps (`<C-t>`, `<C-g><C-f>`, `<C-g><C-h>`)
- Eliminated duplicate fugitive configuration from `core.lua`
- Added Telescope as explicit LSP dependency for references/symbols functionality

**Additional items for future consideration**:

- Review `vim.opt.re = 0` setting for compatibility with newer Neovim versions
- Evaluate provider disabling strategy (may affect LSP functionality)
- Standardize plugin loading patterns for consistency

**Result**: Cleaner configuration with resolved conflicts and proper dependencies

### Performance Optimization Analysis (June 2025)

**Current Performance**: ~166ms startup time (already optimized from 69% improvement via lazy.nvim migration)

**High Impact Optimization Opportunities (15-30% improvement potential)**:

- **trouble.nvim**: Missing lazy loading despite having keybindings (heavy diagnostic plugin)
- **neo-tree.nvim**: Missing lazy loading despite having keybindings (multiple dependencies)
- **vim-fugitive**: Redundant loading (both `VeryLazy` AND `cmd` triggers)

**Medium Impact Opportunities (5-15% improvement potential)**:

- **Event inconsistency**: treesitter uses `BufReadPost` while LSP uses `BufReadPre`
- **snacks.nvim**: Could be lazy-loaded as dependency rather than immediate

**Plugin Loading Pattern Analysis**:

- **Current immediate loading**: 3 plugins (colorscheme, snacks, claudecode)
- **Recommended immediate loading**: 1-2 plugins (colorscheme + critical deps only)
- **Current lazy loading**: ~85% of plugins
- **Optimal lazy loading**: ~90% of plugins

**Loading Strategy Verification**:

- ✅ Completion (nvim-cmp): `InsertEnter` - optimal
- ✅ LSP (nvim-lspconfig): File events - optimal
- ✅ Telescope: Key-based + command-based - optimal
- ❌ trouble.nvim: No lazy loading - needs key-based loading
- ❌ neo-tree.nvim: No lazy loading - needs key/command-based loading
- ❌ vim-fugitive: Redundant `VeryLazy` + `cmd` - remove VeryLazy

**Expected Total Impact**: 20-45% additional startup improvement on top of existing optimizations
