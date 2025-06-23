-- Autocmds for various tasks
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General autocmd group
local general = augroup('General', { clear = true })

-- Insert timestamp after 'LastModified: '
local function last_modified()
  if vim.bo.modified then
    local save_cursor = vim.fn.getpos('.')
    local n = math.min(40, vim.fn.line('$'))
    local pattern = '^(.{,10}LastModified: ).*'
    local replacement = '\\1' .. vim.fn.strftime('%Y-%m-%d %H:%M:%S %z')

    vim.cmd('keepjumps 1,' .. n .. 's#' .. pattern .. '#' .. replacement .. '#e')
    vim.fn.histdel('search', -1)
    vim.fn.setpos('.', save_cursor)
  end
end

autocmd('BufWritePre', {
  group = general,
  callback = last_modified,
  desc = 'Update LastModified timestamp before saving'
})

-- Highlight on yank
autocmd('TextYankPost', {
  group = general,
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight yanked text'
})

-- Auto-resize windows when terminal is resized
autocmd('VimResized', {
  group = general,
  command = 'tabdo wincmd =',
  desc = 'Resize windows on terminal resize'
})

-- Close certain file types with q
autocmd('FileType', {
  group = general,
  pattern = { 'help', 'man', 'qf', 'lspinfo', 'checkhealth' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
  end,
  desc = 'Close with q for certain file types'
})
