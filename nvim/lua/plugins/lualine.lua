-- Local helper components
local function lsp_name()
	local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
	if not buf_clients or #buf_clients == 0 then
		return ""
	end
	return " " .. buf_clients[1].name
end

local function spaces()
	if vim.bo.expandtab then
		return "␣ " .. vim.bo.shiftwidth
	else
		return "⇥ " .. vim.bo.shiftwidth
	end
end

local function search_count()
	local ok, search = pcall(vim.fn.searchcount, { recompute = 0, maxcount = 9999 })
	if not ok or not search or search.total == 0 then
		return ""
	end
	return string.format(" %d/%d", search.current, search.total)
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		-- lazy.nvim will do: require("lualine").setup(opts)
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "NvimTree", "neo-tree", "packer" },
			},

			sections = {
				-- LEFT
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{ "diff", symbols = { added = "+", modified = "~", removed = "-" } },
				},
				lualine_c = {
					{ "filename", path = 1 },
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " " },
						colored = true,
						update_in_insert = false,
					},
				},

				-- RIGHT
				lualine_x = {
					lsp_name, --  tsserver / lua_ls / etc.
					spaces, -- ␣ 2 / ⇥ 4 etc.
					"encoding", -- utf-8
					"filetype", -- typescript, lua, etc.
				},
				lualine_y = {
					search_count, --  1/10 when searching
					"progress",
				},
				lualine_z = { "location" },
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			tabline = {},
			extensions = { "quickfix", "fugitive", "nvim-tree" },
		},
	},
}
