return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Make sure TSX files are detected as 'typescriptreact'
      vim.filetype.add({ extension = { tsx = "typescriptreact" } })
      -- Map the 'typescriptreact' filetype to the 'tsx' parser
      -- (sometimes this mapping is missing depending on versions)
      pcall(function()
        vim.treesitter.language.register("tsx", "typescriptreact")
      end)

      require("nvim-treesitter.configs").setup({
        ensure_installed = { "tsx", "typescript", "elixir", "eex", "heex" },
        -- auto-install parsers you open (so tsx/typescript actually get pulled down)
        auto_install = true,
        highlight = {
          enable = true,
          -- avoid conflicts with legacy regex highlighters
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },
}
