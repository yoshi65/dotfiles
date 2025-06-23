-- Claude Code integration plugins
return {
  -- Snacks.nvim (dependency for claudecode.nvim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Disable features we don't need to reduce warnings
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      image = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      -- Keep only essential features
      toggle = { enabled = true },
      terminal = { enabled = true },
      -- Disable luarocks integration
      rocks = { enabled = false },
    },
  },

  -- Claude Code integration (Official Coder plugin)
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    keys = {
      { "<leader>ac", ":ClaudeCode<CR>", desc = "Claude Code" },
      { "<leader>af", ":ClaudeCodeFocus<CR>", desc = "Claude Code Focus" },
      { "<leader>ar", ":ClaudeCode --resume<CR>", desc = "Claude Code Resume" },
      { "<leader>aC", ":ClaudeCode --continue<CR>", desc = "Claude Code Continue" },
      { "<leader>ab", ":ClaudeCodeAdd %<CR>", desc = "Claude Code Add File" },
      { "<leader>as", ":ClaudeCodeSend<CR>", mode = "v", desc = "Claude Code Send Selection" },
      { "<leader>aa", ":ClaudeCodeDiffAccept<CR>", desc = "Claude Code Diff Accept" },
      { "<leader>ad", ":ClaudeCodeDiffDeny<CR>", desc = "Claude Code Diff Deny" },
    },
  },
}
