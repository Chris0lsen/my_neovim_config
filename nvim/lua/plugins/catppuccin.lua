return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- load before anything else so highlights are ready
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          which_key = true,
        },
      })

      -- set it on startup
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

