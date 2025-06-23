" Minimal init.vim - most configuration moved to Lua
" Load Lua configuration first
lua require('config.options')
lua require('config.keymaps')

" FZF configuration (external dependency)
set rtp+=/opt/local/share/fzf/vim

" Enable syntax highlighting for treesitter
syntax on

" XDG directories
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" Legacy augroup (kept for compatibility)
augroup MyAutoCmd
autocmd!
augroup END

" Load lazy.nvim plugin manager
lua require('config.lazy')
