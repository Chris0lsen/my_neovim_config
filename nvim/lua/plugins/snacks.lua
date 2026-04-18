return {
    "folke/snacks.nvim",
 	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		picker = { 
            enabled = true,
            preset = "telescope"
        },
	},
	keys = {
		{ "<leader>ff", function() Snacks.picker.files() end,       desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.grep() end,        desc = "Live Grep" },
		{ "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Find Buffers" },
		{ "<leader>fh", function() Snacks.picker.help() end,        desc = "Help Tags" },
		{ "<leader>fs", function() Snacks.picker.grep_word() end,   desc = "Grep String",
		  mode = { "n", "x" } },
	},
} 
