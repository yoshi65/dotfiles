-- Terraform development support
return {
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    config = function()
      -- Auto format on save
      vim.g.terraform_fmt_on_save = 1

      -- Enable folding
      vim.g.terraform_fold_sections = 1

      -- Align settings
      vim.g.terraform_align = 1

      -- Comment string for terraform files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "terraform", "tf" },
        callback = function()
          vim.bo.commentstring = "# %s"
        end,
      })
    end,
  },

  -- Additional HCL/Terraform language support
  {
    "jvirtanen/vim-hcl",
    ft = { "hcl", "terraform" },
  },
}
