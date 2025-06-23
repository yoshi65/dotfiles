-- Claude Code integration plugins
return {
  -- Snacks.nvim (dependency for claudecode.nvim) - minimal config
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      -- Minimal setup - only enable what claudecode.nvim needs
      require("snacks").setup({
        -- Disable all features except what's absolutely necessary
        bigfile = { enabled = false },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        image = { enabled = false },
        input = { enabled = false },
        lazygit = { enabled = false },
        notifier = { enabled = false },
        picker = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        terminal = { enabled = false },
        toggle = { enabled = false },
        words = { enabled = false },
      })
    end,
  },

  -- Claude Code integration (Official Coder plugin)
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false, -- Load immediately to ensure commands are available
    config = function()
      -- Ensure plugin is loaded and commands are available
      require("claudecode").setup()
    end,
    keys = {
      { "<leader>cc", ":ClaudeCodeOpen<CR>", desc = "Claude Code Open" },
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
