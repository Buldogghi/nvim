return {
	{ -- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{ -- Manage Buffers
		"famiu/bufdelete.nvim",
	},
	{ -- Git Diff View
		"sindrets/diffview.nvim",
	},
	{ -- Show Hex Colors
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	{ -- Undotree
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require('undotree').setup()
		end,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>ut", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
}
