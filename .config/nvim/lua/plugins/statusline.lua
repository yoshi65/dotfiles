-- Modern statusline with lualine.nvim
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter", -- Load immediately when UI starts for better UX
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
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
            -- Match original: readonly, filename, modified, gitbranch
            {
              'filename',
              symbols = { modified = '[+]', readonly = '[RO]' },
            },
            'branch',
          },
          lualine_c = {
            -- Add modern features: diff and diagnostics
            {
              'diff',
              symbols = { added = '+', modified = '~', removed = '-' },
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
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
