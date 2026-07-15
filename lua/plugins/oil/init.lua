-- PLUGINS
require("plugins").install({
	"stevearc/oil.nvim",
	"benomahony/oil-git.nvim",
})

-- CONFIG
require("oil").setup({
	columns = {},
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<leader>o?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<leader>ol"] = { "actions.select", opts = { vertical = true } },
		["<C-p>"] = "actions.preview",
		["<leader>op"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["<Esc>"] = { "actions.refresh", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
		["<leader>o-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["<leader>o_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["<leader>od"] = { "actions.cd", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["<leader>os"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["<leader>o."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["<leader>o\\"] = { "actions.toggle_trash", mode = "n" },
	},
	view_options = {
		show_hidden = true,
	},
})

require("which-key").add({ "<leader>e", desc = "[TOGGLE OIL]" })

vim.keymap.set("n", "<leader>e", function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end, { desc = "Toggle oil" })
