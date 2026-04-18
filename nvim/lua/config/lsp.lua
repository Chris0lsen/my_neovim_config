----------------------------------------------------------------------
-- LSP: Global defaults
----------------------------------------------------------------------
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Global diagnostic UI config
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { only_current_line = true },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

----------------------------------------------------------------------
-- Typescript / TSX via typescript-language-server
----------------------------------------------------------------------
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"typescript",
		"typescriptreact",
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
vim.lsp.enable("ts_ls")

----------------------------------------------------------------------
-- Elixir via Expert
----------------------------------------------------------------------
-- nvim-lspconfig ships a default config for `expert` (cmd = { "expert", "--stdio" },
-- filetypes = elixir/eelixir/heex/surface, umbrella-aware root_dir).
-- We just enable it. Override the cmd here if your binary isn't on $PATH.
vim.lsp.config("expert", {
	-- cmd = { vim.fn.expand("~/.local/bin/expert"), "--stdio" },
})
vim.lsp.enable("expert")

----------------------------------------------------------------------
-- LspAttach: keymaps, formatting, extras
----------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = bufnr, noremap = true, silent = true }

		-- Navigation / actions
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		-- Formatting
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Diagnostics (updated to vim.diagnostic.jump for 0.11+)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

		------------------------------------------------------------------
		-- Per-client tweaks
		------------------------------------------------------------------
		-- If you use prettier or another formatter, disable ts_ls formatting
		if client and client.name == "ts_ls" then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		-- Expert is still early; it currently doesn't expose a formatter,
		-- so `mix format` via an autocmd or formatter plugin is a better
		-- bet than relying on LSP formatting for Elixir buffers.

		------------------------------------------------------------------
		-- Document highlight
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
