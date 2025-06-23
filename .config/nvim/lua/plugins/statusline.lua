-- Modern statusline with lualine.nvim
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter", -- Load immediately when UI starts for better UX
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      -- Define custom colors for better visual separation
      local colors = {
        filename_bg = '#585858',
        filename_fg = '#e4e4e4',
        branch_bg = '#8a8a8a',
        branch_fg = '#000000',
      }

      require('lualine').setup({
        options = {
          theme = 'wombat', -- Match original lightline colorscheme
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true, -- Use global statusline
          refresh = {
            statusline = 100, -- Fast refresh for responsive feel
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          -- Match original lightline layout: mode, paste in left section a
          lualine_a = { 'mode' },
          lualine_b = {
            -- Filename with distinct styling
            {
              'filename',
              symbols = { modified = '[+]', readonly = '[RO]' },
              color = { bg = colors.filename_bg, fg = colors.filename_fg }, -- Darker background for filename
            },
          },
          lualine_c = {
            -- Branch with smart icons based on branch type
            {
              'branch',
              color = { bg = colors.branch_bg, fg = colors.branch_fg, gui = 'bold' },
              fmt = function(str)
                -- Smart branch icons:
                -- 👑 main/master (production)
                -- ✨ feature/ (new features)
                -- 🔧 fix/hotfix (bug fixes)
                -- 🚧 dev/develop (development)
                -- 🌿 other branches
                if str == 'main' or str == 'master' then
                  return '👑 ' .. str
                elseif str:match('^feature/') then
                  return '✨ ' .. str
                elseif str:match('^fix/') or str:match('^hotfix/') then
                  return '🔧 ' .. str
                elseif str:match('^dev') or str:match('^develop') then
                  return '🚧 ' .. str
                else
                  return '🌿 ' .. str
                end
              end,
            },
            -- Add modern features: diff and diagnostics with color coding
            {
              'diff',
              symbols = { added = '+', modified = '~', removed = '-' },
              colored = true, -- Use diff colors
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
              colored = true, -- Use diagnostic colors
            },
          },
          lualine_x = {
            -- Match original right side: fileencoding, fileformat, filetype
            'encoding',
            'fileformat',
            'filetype',
          },
          lualine_y = {
            -- Match original: lineinfo
            'location',
          },
          lualine_z = {
            -- Match original: percent
            'progress',
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'fugitive', 'fzf' },
      })
    end,
  },
}
