local M = {}

function M.get_counts(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	return {
		error = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
		warn = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
		info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }),
		hint = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT }),
	}
end

-- Somewhere in your config (after the module above)

function _G.LspDiagStatus()
	local c = M.get_counts(0)
	local parts = {}

	if c.error > 0 then
		table.insert(parts, " " .. c.error)
	end
	if c.warn > 0 then
		table.insert(parts, " " .. c.warn)
	end
	if c.info > 0 then
		table.insert(parts, " " .. c.info)
	end
	if c.hint > 0 then
		table.insert(parts, " " .. c.hint)
	end

	if #parts == 0 then
		return "" -- clean buffer: show nothing (or return "✓")
	end

	return table.concat(parts, " ")
end

-- Append it to your statusline
vim.o.statusline = vim.o.statusline .. " %{v:lua.LspDiagStatus()}"

-- Put all diagnostics for all buffers into the quickfix list and open it
vim.keymap.set("n", "<leader>DQ", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { desc = "Project diagnostics (quickfix)" })

-- Open quickfix (generic)
vim.keymap.set("n", "<leader>qo", vim.cmd.copen, { desc = "Quickfix open" })

-- Close quickfix
vim.keymap.set("n", "<leader>qc", vim.cmd.cclose, { desc = "Quickfix close" })

-- Navigate between quickfix items without even focusing the list
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Quickfix next" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Quickfix prev" })

local function toggle_qf()
	local has_qf = false

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "quickfix" then
			has_qf = true
			break
		end
	end

	if has_qf then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

vim.keymap.set("n", "<leader>qq", toggle_qf, { desc = "Toggle quickfix" })

return M
