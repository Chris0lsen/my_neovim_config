----------------------------------------------------------------------
-- LSP: Global defaults (optional)
----------------------------------------------------------------------
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Global diagnostic UI config
vim.diagnostic.config({
	virtual_text = false, -- disable virtual text
	virtual_lines = { only_current_line = true }, -- show virtual lines only for current line
	signs = true, -- show signs in the gutter
	underline = true, -- underline offending code
	update_in_insert = false, -- don't spam while typing
	severity_sort = true,
})

----------------------------------------------------------------------
-- Typescript / TSX via typescript-language-server
----------------------------------------------------------------------
vim.lsp.config("tsserver", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"typescript",
		"typescriptreact", -- *.tsx
		"javascript",
		"javascriptreact",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},
})

-- Enable tsserver (auto-start on matching buffers)
vim.lsp.enable("tsserver")

----------------------------------------------------------------------
-- LspAttach: keymaps, formatting, extras
----------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Enable completion with built-in omnifunc (if you want it)
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Helper for buffer-local mappings
		local opts = { buffer = bufnr, noremap = true, silent = true }

		-- Standard LSP navigation / actions
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		-- Formatting (normal + visual)
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Optional: diagnostics shortcuts
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

		------------------------------------------------------------------
		-- Per-client tweaks
		------------------------------------------------------------------

		-- If you use prettier or another formatter, you might want
		-- tsserver *not* to format:
		if client and client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		------------------------------------------------------------------
		-- Document highlight (symbol under cursor)
		------------------------------------------------------------------
		if client and client.server_capabilities.documentHighlightProvider then
			local hl_group = vim.api.nvim_create_augroup("UserLspHighlight" .. bufnr, { clear = true })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = hl_group,
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd("CursorMoved", {
				group = hl_group,
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
