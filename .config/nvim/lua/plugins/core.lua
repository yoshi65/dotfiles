-- Core plugins that are fundamental to the setup
return {
  -- Colorscheme
  {
    "sjl/badwolf",
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme badwolf]])
    end,
  },

  -- Essential UI
  {
    "itchyny/lightline.vim",
    event = "VeryLazy",
    config = function()
      vim.g.lightline = {
        active = {
          left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'modified', 'gitbranch' } },
          right = { { 'percent' }, { 'lineinfo' }, { 'fileencoding', 'fileformat', 'filetype' } }
        },
        component_function = {
          gitbranch = 'FugitiveHead'
        },
        colorscheme = 'wombat',
        separator = { left = '', right = '' },
        subseparator = { left = '', right = '' }
      }
    end,
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gwrite", "Gread", "Ggrep", "GMove", "GDelete", "GBrowse" },
    ft = { "fugitive" },
  },

  {
    "airblade/vim-gitgutter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.g.updatetime = 250
      vim.keymap.set('n', '<C-g>g', ':GitGutterToggle<CR>')
      vim.keymap.set('n', '<C-g>h', ':GitGutterLineHighlightsToggle<CR>')
    end,
  },

  -- File explorer
  {
    "lambdalisue/fern.vim",
    cmd = { "Fern" },
    keys = {
      { "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", desc = "Toggle file explorer" },
    },
    dependencies = {
      "lambdalisue/fern-git-status.vim",
      "lambdalisue/nerdfont.vim",
      "lambdalisue/fern-renderer-nerdfont.vim",
      "lambdalisue/glyph-palette.vim",
    },
    config = function()
      vim.g["fern#default_hidden"] = 1
      vim.g["fern#renderer"] = "nerdfont"

      -- Glyph palette setup
      vim.cmd([[
        augroup my-glyph-palette
          autocmd! *
          autocmd FileType fern call glyph_palette#apply()
          autocmd FileType nerdtree,startify call glyph_palette#apply()
        augroup END
      ]])
    end,
  },
}
