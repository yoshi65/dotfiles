-- Git integration plugins
return {
  -- Modern git signs with better performance than vim-gitgutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)

      -- Key mappings for git operations
      local gs = require('gitsigns')

      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc="Next git hunk"})

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc="Previous git hunk"})

      -- Actions
      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {desc="Stage git hunk"})
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {desc="Reset git hunk"})
      vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Stage git hunk"})
      vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Reset git hunk"})
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {desc="Stage buffer"})
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {desc="Undo stage hunk"})
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {desc="Reset buffer"})
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {desc="Preview git hunk"})
      vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc="Git blame line"})
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {desc="Toggle git blame"})
      vim.keymap.set('n', '<leader>hd', gs.diffthis, {desc="Git diff this"})
      vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, {desc="Git diff this ~"})
      vim.keymap.set('n', '<leader>td', gs.toggle_deleted, {desc="Toggle git deleted"})

      -- Text object
      vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="Select git hunk"})
    end,
  },

  -- Git fugitive for advanced git operations
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gwrite", "Gread", "Gdiff", "Gblame", "Glog", "Gclog" },
    keys = {
      { "gs", ":Git status<CR>", desc = "Git status" },
      { "gc", ":Git commit -m", desc = "Git commit" },
      { "gw", ":Gwrite<CR>", desc = "Git write" },
      { "gp", ":Git push origin", desc = "Git push origin" },
    },
  },
}
