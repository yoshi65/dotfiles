-- Modern keymaps with better defaults
local map = vim.keymap.set

-- Disable arrow keys in normal mode
map('n', '<Up>', '<Nop>', { desc = 'Disabled' })
map('n', '<Down>', '<Nop>', { desc = 'Disabled' })
map('n', '<Left>', '<Nop>', { desc = 'Disabled' })
map('n', '<Right>', '<Nop>', { desc = 'Disabled' })

-- jj to escape in insert mode
map('i', 'jj', '<ESC>', { silent = true, desc = 'Exit insert mode' })

-- ESC to clear search highlights
map('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', { desc = 'Clear search highlights' })

-- Better line navigation for wrapped lines
map('n', 'j', 'gj', { desc = 'Move down display line' })
map('n', 'k', 'gk', { desc = 'Move up display line' })

-- Window navigation and management
map('n', 't', '<Nop>', { desc = 'Tab prefix' })
map('n', 'tj', '<C-w>j', { desc = 'Move to window below' })
map('n', 'tk', '<C-w>k', { desc = 'Move to window above' })
map('n', 'tl', '<C-w>l', { desc = 'Move to window right' })
map('n', 'th', '<C-w>h', { desc = 'Move to window left' })
map('n', 'tJ', '<C-w>J', { desc = 'Move window to bottom' })
map('n', 'tK', '<C-w>K', { desc = 'Move window to top' })
map('n', 'tL', '<C-w>L', { desc = 'Move window to right' })
map('n', 'tH', '<C-w>H', { desc = 'Move window to left' })
map('n', 'tn', 'gt', { desc = 'Next tab' })
map('n', 'tp', 'gT', { desc = 'Previous tab' })
map('n', 'ts', ':<C-u>sp<CR>', { desc = 'Split horizontal' })
map('n', 'tv', ':<C-u>vs<CR>', { desc = 'Split vertical' })
map('n', 'tt', ':<C-u>tabnew<CR>', { desc = 'New tab' })
map('n', 'tw', '<C-w>', { desc = 'Window command' })

-- Terminal mode escape
map('t', '<ESC>', '<C-\\><C-n>', { silent = true, desc = 'Exit terminal mode' })

-- File explorer toggle (Fern)
map('n', '<C-n>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>', { desc = 'Toggle file explorer' })


-- Better buffer navigation and management
map('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', ']b', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
map('n', '<leader>bD', ':bdelete!<CR>', { desc = 'Force delete buffer' })
map('n', '<leader>ba', ':%bdelete|edit #|normal `"<CR>', { desc = 'Delete all buffers except current' })
map('n', '<leader>bo', ':only<CR>', { desc = 'Close all windows except current' })
map('n', '<leader>bn', ':enew<CR>', { desc = 'New empty buffer' })
map('n', '<leader>bl', ':buffers<CR>:buffer<Space>', { desc = 'List and select buffer' })

-- Buffer switching with numbers
for i = 1, 9 do
  map('n', '<leader>' .. i, ':buffer ' .. i .. '<CR>', { desc = 'Switch to buffer ' .. i })
end

-- Better indenting in visual mode
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Quick save
map('n', '<C-s>', ':w<CR>', { desc = 'Save file' })

-- Better diagnostics navigation
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- Moving lines up and down
map('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
map('v', '<A-j>', ':m \'>+1<CR>gv=gv', { desc = 'Move selection down' })
map('v', '<A-k>', ':m \'<-2<CR>gv=gv', { desc = 'Move selection up' })
