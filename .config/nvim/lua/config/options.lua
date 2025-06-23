-- Modern nvim options for better performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240

-- Better search and editing (avoiding duplicate with init.vim)
vim.opt.inccommand = 'split'  -- Live preview for :s command

-- UI improvements
vim.opt.signcolumn = 'yes'
vim.opt.pumheight = 10
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

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
