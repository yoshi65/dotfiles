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
          theme = 'auto', -- Automatically adapt to colorscheme
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
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
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
          lualine_c = {
            {
              'filename',
              path = 1, -- Show relative path
              shorting_target = 40,
            },
          },
          lualine_x = {
            'encoding',
            {
              'fileformat',
              symbols = {
                unix = 'LF',
                dos = 'CRLF',
                mac = 'CR',
              },
            },
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
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
