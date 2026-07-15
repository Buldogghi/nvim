-- PLUGINS
require("plugins").install({
	"echasnovski/mini.nvim",
	"NMAC427/guess-indent.nvim",
	"folke/which-key.nvim",
	"folke/todo-comments.nvim",
	"windwp/nvim-ts-autotag", -- HTML auto tag completion
})

-- CONFIG
require("guess-indent").setup({})

require("todo-comments").setup({ signs = false })

if vim.g.have_nerd_font then
	require("mini.icons").setup()
end

require("mini.ai").setup() -- select around stuff

require("mini.git").setup()

-- require("mini.diff").setup()

require("mini.statusline").setup({
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			-- local git = MiniStatusline.section_git({ trunc_width = 40 })
			-- local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			-- local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			-- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			-- local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 1000 })
			-- local location = MiniStatusline.section_location({ trunc_width = 75 })
			local location = (function()
				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				local tot_row = vim.api.nvim_buf_line_count(0)
				local tot_col = #vim.api.nvim_get_current_line() - 1
				-- local winwidth = vim.api.nvim_win_get_width(0)
				return string.format("%d/%d %d/%d %d%%%%", row, tot_row, col, tot_col, row / tot_row * 100)
				-- I don't know why %%%% = '%' but it works
			end)()
			local search = (function()
				local res = MiniStatusline.section_searchcount({ trunc_width = 75 })
				if res ~= "" then
					return "search '" .. res .. "'"
				else
					return ""
				end
			end)()

			local macro = (function()
				local rec = vim.fn.reg_recording()
				if rec ~= "" then
					return "recording @" .. rec
				else
					return ""
				end
			end)()
			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				-- { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
				-- "%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFilename", strings = { macro } },
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})

require("mini.pairs").setup({
	-- stylua: ignore
	mappings = {
		-- For more info about Lua patterns:
		-- https://gitspartv.github.io/lua-patterns/

		-- [%c ][%c ] Means that for the quotes to be doubled the character
		-- before the cursor needs to be an escape character (%c = "\t\n\r")
		-- or a space and the next/previous character needs to also be that.

		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]%s" }, -- LEFT: not backslash
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]%s" }, -- RIGHT: whitespace
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]%s" },

		[")"] = { action = "close", pair = "()" },
		["]"] = { action = "close", pair = "[]" },
		["}"] = { action = "close", pair = "{}" },

		-- To open the brackets in a nice way when pressing enter
		['>'] = { action = "open", pair = '><', neigh_pattern = "$^$^", register = { cr = true } }, -- Neigh pattern that never matches
		-- ['"'] = { action = "open", pair = '""', neigh_pattern = "$^$^", register = { cr = true } }, -- Neigh pattern that never matches
		-- ["'"] = { action = "open", pair = "''", neigh_pattern = "$^$^", register = { cr = true } },
		-- ['`'] = { action = "open", pair = "``", neigh_pattern = "$^$^", register = { cr = true } },

		-- Disable them
		['"'] = false,
		["'"] = false,
		['`'] = false,
	},
})

require("mini.move").setup({
	mappings = {
		left = "<M-h>",
		right = "<M-l>",
		down = "<M-j>",
		up = "<M-k>",
		line_left = "<M-h>",
		line_right = "<M-l>",
		line_down = "<M-j>",
		line_up = "<M-k>",
	},
	options = {
		reindent_linewise = true,
	},
})

require("mini.comment").setup()

require("mini.notify").setup({
	lsp_progress = {
		enable = false,
	},
})

require("which-key").setup({
	delay = 500,
	icons = {
		group = "",
		mappings = false,
	},
	spec = {
		{ "<leader>b", desc = "[BUFFERS]" },
		{ "<leader>s", desc = "[SPLITS]" },
		{ "<leader>t", desc = "[TABS]" },
		{ "<leader>f", desc = "[TELESCOPE]" },
		{ "<leader>d", desc = "[DIFFVIEW]" },
	},
})

require("nvim-ts-autotag").setup()
