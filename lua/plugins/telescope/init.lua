-- PLUGINS
require("plugins").install({
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-ui-select.nvim",
})

-- CONFIG
require("telescope").setup({})

do -- For the map function
	local builtin = require("telescope.builtin")
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, "<leader>" .. keys, func, { desc = desc })
	end

	map("<leader>", builtin.find_files, "[FIND FILES]")
	map("ff", builtin.find_files, "Find Files")
	map("fb", builtin.buffers, "Find Buffers")
	map("fw", builtin.grep_string, "Find current word")
	map("fg", builtin.live_grep, "Find by grep")
	map("fj", builtin.git_files, "Find Git Files")
	map("fs", builtin.git_status, "Find Git Status")
	map("fc", builtin.git_commits, "Find Git Commits")
	map("fh", builtin.help_tags, "Find Help")
	map("fk", builtin.keymaps, "Find Keymaps")
	map("fa", builtin.commands, "Find commands")
	map("fd", builtin.diagnostics, "Find diagnostics")
	map("fo", builtin.oldfiles, "Find recent files")
	map("f/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, "Find in open buffers")
end
