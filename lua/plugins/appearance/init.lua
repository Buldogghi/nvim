-- PLUGINS
require("plugins").install({
	-- {{{ APPEARANCE
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
	"shellRaining/hlchunk.nvim",
	"lewis6991/gitsigns.nvim",
	"brenoprata10/nvim-highlight-colors",
})

-- CONFIG
require("rose-pine").setup({
	variant = "moon",
	styles = {
		transparency = true,
	},
})

vim.cmd("colorscheme rose-pine")
vim.opt.colorcolumn = "80"

require("hlchunk").setup({
	chunk = {
		enable = true,
		delay = 0,
		duration = 0,
		use_treesitter = true,
		style = {
			{ fg = "#ffffff" },
			{ fg = "#c21f30" },
		},
	},
	indent = {
		enable = true,
		style = { -- Pastel rainbow palette
			"#ffadad",
			"#ffd6a5",
			"#fdffb6",
			"#caffbf",
			"#9bf6ff",
			"#a0c4ff",
			"#bdb2ff",
			"#ffc6ff",
		},
	},
})

require("gitsigns").setup()

require("nvim-highlight-colors").setup({
	-- render = "virtual",
	render = "background",
	-- virtual_symbol_prefix = "[",
	-- virtual_symbol_suffix = "]",
	-- virtual_symbol_position = "eow", -- 'end of word'
})
