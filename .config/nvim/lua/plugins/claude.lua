-- Claude Code integration plugins
return {
  -- Snacks.nvim (dependency for claudecode.nvim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {}, -- Use opts instead of config to avoid duplicate setup
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
