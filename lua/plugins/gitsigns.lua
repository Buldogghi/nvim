return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 250,
			icons = {
				mappings = true,
			},
			-- spec = {
			-- 	{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
			-- 	{ "<leader>d", group = "[D]ocument" },
			-- 	{ "<leader>r", group = "[R]ename" },
			-- 	{ "<leader>s", group = "[S]earch" },
			-- 	{ "<leader>w", group = "[W]orkspace" },
			-- 	{ "<leader>t", group = "[T]oggle" },
			-- 	{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			-- },
		},
	},
}
