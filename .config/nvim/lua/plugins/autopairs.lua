-- Auto-pairing brackets, quotes, etc.
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")

      autopairs.setup({
        check_ts = true, -- Enable treesitter
        ts_config = {
          lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- Don't add pairs in javascript template_string
          java = false, -- Don't check treesitter on java
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        disable_in_macro = true, -- Disable when recording or executing a macro
        disable_in_visualblock = false, -- Disable when insert after visual block mode
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true, -- Add bracket pairs after quote
        enable_check_bracket_line = true, -- Check bracket in same line
        enable_bracket_in_quote = true, --
        enable_abbr = false, -- Trigger abbreviation
        break_undo = true, -- Switch for basic rule break undo sequence
        check_comma = true,
        map_cr = true,
        map_bs = true, -- Map the <BS> key
        map_c_h = false, -- Map the <C-h> key to delete a pair
        map_c_w = false, -- Map <c-w> to delete a pair if possible
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- Custom rules for specific filetypes
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      -- Add spaces inside parentheses for function calls
      autopairs.add_rules({
        Rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ '()', '[]', '{}' }, pair)
          end),
        Rule('( ', ' )')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%)') ~= nil
          end)
          :use_key(')'),
        Rule('{ ', ' }')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%}') ~= nil
          end)
          :use_key('}'),
        Rule('[ ', ' ]')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%]') ~= nil
          end)
          :use_key(']'),
      })

      -- Arrow function shortcut for JavaScript/TypeScript
      autopairs.add_rules({
        Rule('%(.*%)%s*%=>$', ' {  }', {'javascript', 'typescript'})
          :use_regex(true)
          :set_end_pair_length(2),
      })
    end,
  },
}
