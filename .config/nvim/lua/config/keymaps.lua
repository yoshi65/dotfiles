-- Modern keymaps with better defaults
local map = vim.keymap.set

-- Better window navigation (keeping your existing style)
map('n', 'tj', '<C-w>j', { desc = 'Move to window below' })
map('n', 'tk', '<C-w>k', { desc = 'Move to window above' })
map('n', 'tl', '<C-w>l', { desc = 'Move to window right' })
map('n', 'th', '<C-w>h', { desc = 'Move to window left' })

-- Better buffer navigation
map('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', ']b', ':bnext<CR>', { desc = 'Next buffer' })

-- Modern terminal escape (existing mapping in init.vim, skipping)

-- Better indenting in visual mode
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Quick save
map('n', '<C-s>', ':w<CR>', { desc = 'Save file' })

-- Better diagnostics navigation (for future LSP)
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
