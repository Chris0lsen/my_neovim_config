local lsp = vim.lsp

lsp.config('*', {
  capabilities = (function()
    local caps = vim.lsp.protocol.make_client_capabilities()
    return caps
  end)(),

  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, {buffer = bufnr}) end
    map('n', 'gd', lsp.buf.definition)
    map('n', 'gr', lsp.buf.references)
    map('n', 'K',  lsp.buf.hover)
    map('n', '<leader>rn', lsp.buf.rename)
    map('n', '<leader>ca', lsp.buf.code_action)
    map('n', 'gD', lsp.buf.declaration)

    -- optional niceties in 0.11
    vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})          -- if your server supports it
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"   -- formatexpr hook
  end})


vim.lsp.config('vtsls', { cmd = { "vtsls", "--stdio" } })

vim.lsp.enable({ 'vtsls' })
