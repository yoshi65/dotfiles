" Minimal init.vim - most configuration moved to Lua
" Load Lua configuration first
lua require('config.options')
lua require('config.keymaps')

" Enable syntax highlighting for treesitter
syntax on

" Load lazy.nvim plugin manager
lua require('config.lazy')
