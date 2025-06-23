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



}
