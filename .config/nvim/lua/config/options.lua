-- Modern nvim options for better performance
-- Enable faster Lua module loading
if vim.loader then
  vim.loader.enable()
end

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240
vim.opt.ttimeoutlen = 10  -- Faster key sequence completion

-- Better search and editing (avoiding duplicate with init.vim)
vim.opt.inccommand = 'split'  -- Live preview for :s command

-- UI improvements
vim.opt.signcolumn = 'yes'
vim.opt.pumheight = 10
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Lua-specific optimizations
if vim.fn.has('nvim-0.9') == 1 then
  -- Use faster regex engine in newer versions
  vim.opt.re = 0
end

-- Better diff experience
vim.opt.diffopt:append('linematch:60')

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
