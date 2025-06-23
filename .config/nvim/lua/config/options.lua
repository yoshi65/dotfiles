-- Modern nvim options for better performance
-- Enable faster Lua module loading
if vim.loader then
  vim.loader.enable()
end

-- Leader key
vim.g.mapleader = ","

-- File encoding and format
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8' }

-- File handling
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true

-- UI and display
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.virtualedit = 'onemore'
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.wildmode = 'list:longest'
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.nrformats = ''

-- Search settings
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'  -- Live preview for :s command

-- Tab and indentation
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Folding
vim.opt.foldmethod = 'marker'
vim.opt.foldmarker = '<details>,</details>'

-- Terminal and GUI
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamed'  -- macOS clipboard integration

-- Performance optimizations
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240
vim.opt.ttimeoutlen = 10

-- UI improvements
vim.opt.signcolumn = 'yes'
vim.opt.pumheight = 10
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Better diff experience
vim.opt.diffopt:append('linematch:60')

-- Lua-specific optimizations
if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.re = 0
end

-- Disable providers to avoid warnings
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Performance: disable some built-in plugins
local disabled_built_ins = {
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
  "2html_plugin", "logipat", "rrhelper", "spellfile_plugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
