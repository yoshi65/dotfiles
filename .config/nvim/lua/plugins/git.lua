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
    event = "VeryLazy", -- Load eagerly to ensure keymaps are available
    cmd = { "Git", "Gwrite", "Gread", "Gdiff", "Gblame", "Glog", "Gclog" },
    config = function()
      -- Set up keymaps immediately when plugin loads
      vim.keymap.set('n', 'gs', ':Git status<CR>', { desc = 'Git status' })
      vim.keymap.set('n', 'gc', ':Git commit -m ', { desc = 'Git commit' }) -- Note: space after -m for input
      vim.keymap.set('n', 'gw', function()
        -- Safer git write with error handling and lock file resolution
        local ok, result = pcall(vim.cmd, 'Gwrite')
        if not ok and result:match('index%.lock') then
          vim.notify('Git index lock detected. Attempting to resolve...', vim.log.levels.WARN)

          -- Try to resolve lock file issue
          local git_dir = vim.fn.system('git rev-parse --git-dir 2>/dev/null'):gsub('\n', '')
          if git_dir ~= '' then
            local lock_file = git_dir .. '/index.lock'
            local lock_exists = vim.fn.filereadable(lock_file) == 1

            if lock_exists then
              vim.notify('Removing stale git lock file: ' .. lock_file, vim.log.levels.INFO)
              vim.fn.delete(lock_file)

              -- Retry the operation
              local retry_ok, retry_result = pcall(vim.cmd, 'Gwrite')
              if retry_ok then
                vim.notify('Git write succeeded after lock file removal', vim.log.levels.INFO)
              else
                vim.notify('Git write still failed: ' .. retry_result, vim.log.levels.ERROR)
              end
            else
              vim.notify('Lock file not found. Git process may still be running.', vim.log.levels.WARN)
            end
          end
        elseif not ok then
          vim.notify('Git write failed: ' .. result, vim.log.levels.ERROR)
        end
      end, { desc = 'Git write (with lock resolution)' })
      vim.keymap.set('n', 'gp', ':Git push origin ', { desc = 'Git push origin' }) -- Note: space for branch input

      -- Additional command aliases for compatibility
      vim.cmd("cnoreabbrev Gcb Git checkout -b")
      vim.cmd("cnoreabbrev Gp Git push origin")
      vim.cmd("cnoreabbrev Gc Git commit -m")

      -- Command to manually resolve git lock issues
      vim.api.nvim_create_user_command('GitUnlock', function()
        local git_dir = vim.fn.system('git rev-parse --git-dir 2>/dev/null'):gsub('\n', '')
        if git_dir ~= '' then
          local lock_file = git_dir .. '/index.lock'
          if vim.fn.filereadable(lock_file) == 1 then
            vim.fn.delete(lock_file)
            vim.notify('Removed git lock file: ' .. lock_file, vim.log.levels.INFO)
          else
            vim.notify('No git lock file found', vim.log.levels.INFO)
          end
        else
          vim.notify('Not in a git repository', vim.log.levels.WARN)
        end
      end, { desc = 'Remove git index.lock file' })
    end,
  },
}
