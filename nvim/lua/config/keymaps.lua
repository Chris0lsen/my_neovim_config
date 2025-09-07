local map = vim.keymap.set
vim.opt.mouse = "a"

-- LSP-first, gf fallback
local function goto_here()
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if c.server_capabilities.definitionProvider then
      return vim.lsp.buf.definition()
    end
  end
  vim.cmd.normal({ args = { "gf" }, bang = true })
end

map("n", "<C-LeftMouse>", goto_here, { silent = true })
map("n", "<D-LeftMouse>", goto_here, { silent = true }) -- mac terminals

vim.keymap.set("n", "<leader>fo", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer" })

-- Useful LSP keys (work even if you also click)
map("n", "gd", vim.lsp.buf.definition, { silent = true })
map("n", "gr", vim.lsp.buf.references, { silent = true })
map("n", "gD", vim.lsp.buf.declaration, { silent = true })
map("n", "gi", vim.lsp.buf.implementation, { silent = true })

-- Make gf smarter for TS/TSX imports
vim.opt.suffixesadd:append({ ".ts", ".tsx", ".d.ts", ".js", ".jsx", ".json" })
vim.opt.path:append({ "src", "app", "lib" })

