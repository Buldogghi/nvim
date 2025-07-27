-- Nvim single-file config

-- ### KEYBINDS ###
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Buffers
vim.keymap.set("n", "<leader>bq", ":Bdelete<CR>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bQ", ":Bwipeout<CR>", { desc = "Wipeout Buffer" })
vim.keymap.set("n", "<leader>bd", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= vim.api.nvim_get_current_buf() then
			require("bufdelete").bufdelete(buf, true)
		end
	end
end, { desc = "Delete other buffers", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New blank buffer" })

-- Tabs (and Splits (and terminal))
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("tabnew")
	vim.cmd("term")
end, { desc = "Open terminal in new tab" })
vim.keymap.set("n", "H", "gT", { desc = "Previus Tab" })
vim.keymap.set("n", "L", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>sn", ":vsplit<CR>", { desc = "New Split (vertical)" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "New Horizontal Split" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "New Vertical Split" })
vim.keymap.set("n", "<leader>sc", ":close<CR>", { desc = "Close Split" })
vim.keymap.set("n", "<leader>st", ":tab split<CR>", { desc = "Split to Tab" })
vim.keymap.set("n", "<leader>so", ":only<CR>", { desc = "Only split" })

-- Git DiffView

-- vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
-- vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
-- vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "Refresh Diffview" })

-- jk in wrapped text
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Moving through splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper split" })

-- paste the last yanked text not deleted text (you can still use Ctrl + Shift + V to paste)
vim.keymap.set({ "n", "v" }, "p", '"0p')
vim.keymap.set({ "n", "v" }, "P", '"0P')

-- ### SETTINGS ###

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2
-- vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.termguicolors = true -- Tell neovim my terminal supports colors
mouse = "a"

-- Save undo history
vim.opt.undofile = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
-- vim.opt.listchars = { trail = "·", nbsp = "␣" }
-- vim.opt.listchars = { tab = "▏ ", trail = "·", nbsp = "␣" }
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = "▎ ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
-- vim.opt.inccommand = "split"

-- Number of lines above/below the cursor everytime
vim.opt.scrolloff = 3

-- ### AUTOCMDS ###

-- Kickstart.nvim highlight when copying text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
			vim.cmd("normal! zz") -- Center the current line
		end
	end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Using conform.nvim
-- -- Format on save (from :help lsp)
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("my.lsp", {}),
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if
-- 			not client:supports_method("textDocument/willSaveWaitUntil")
-- 			and client:supports_method("textDocument/formatting")
-- 		then
-- 			vim.api.nvim_create_autocmd("BufWritePre", {
-- 				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
-- 				buffer = args.buf,
-- 				callback = function()
-- 					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
-- 				end,
-- 			})
-- 		end
-- 	end,
-- })

-- Lsp keybinds (from :help lsp)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: rename" })
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: code action" })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.references, { desc = "LSP: references" })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP: implementation" })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.type_definition, { desc = "LSP: type definition" })
		vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "LSP: document symbol" })
	end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ### PLUGINS ###
require("lazy").setup({
	spec = { -- Plugins:
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		{
			"echasnovski/mini.nvim",
			config = function() -- Configuration of mini.nvim modules
				require("mini.icons").setup()
				require("mini.git").setup()
				require("mini.diff").setup()
				require("mini.statusline").setup()
				require("mini.pairs").setup()
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
				-- local animate = require("mini.animate")
				-- animate.setup({
				-- 	cursor = { enable = false },
				-- 	scroll = {
				-- 		-- To better know where i'm going with <C-d> and <C-u>
				-- 		timing = animate.gen_timing.linear({ duration = 10, unit = "total" }),
				-- 	},
				-- 	resize = { enable = false },
				-- })
				require("mini.notify").setup()
			end,
		},
		{ "karb94/neoscroll.nvim", opts = {
			duration_multiplier = 0.5,
		} },
		{
			"shellRaining/hlchunk.nvim",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				require("hlchunk").setup({
					chunk = {
						enable = true,
						delay = 0,
						duration = 0,
						style = {
							{ fg = "#FF00FF" },
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
			end,
		},
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
				"mason-org/mason.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
			},
			config = function()
				require("mason").setup()
				require("mason-tool-installer").setup({
					ensure_installed = { "lua_ls", "clangd", "stylua", "clang-format", "prettier", "prettierd" },
				})
			end,
		},
		{ -- Configure format_on_save and formatters
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					format_on_save = {
						lsp_format = "fallback",
					},
					formatters_by_ft = { -- :help conform.format
						lua = { "stylua" },
						javascript = { "prettierd", "prettier", stop_after_first = true },
						cpp = { "clang-format" },
						c = { "clang-format" },
					},
				})
			end,
		},
		{
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		},
		{ "nvim-treesitter/nvim-treesitter" },
		{ "folke/which-key.nvim" },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = "super-tab" },
				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},
				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = false } },
				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lazydev", "lsp", "path", "snippets", "buffer" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
					},
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy", -- Or `LspAttach`
			priority = 1000, -- needs to be loaded in first
			config = function()
				require("tiny-inline-diagnostic").setup()
				vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
			end,
		},
		{ "famiu/bufdelete.nvim" }, -- Manage buffers
	},
	lockfile = "/dev/null", -- don't generate a lazy-lock.json file
	checker = { enabled = false },
})

-- local add = MiniDeps.add
--
-- -- Install plugins
-- add({source = "rose-pine/neovim", name = "rose-pine"})
-- add({source = "neovim/nvim-lspconfig", name = "nvim-lspconfig"})
-- add({source = "mason-org/mason.nvim", name = "mason.nvim"})
-- add({source = "mason-org/mason-lspconfig.nvim", name = "mason-lspconfig.nvim"})
-- add({source = "nvim-treesitter/nvim-treesitter", name = "nvim-treesitter"})
-- add({source = "folke/which-key.nvim", name = "which-key.nvim"})
-- add({source = "hrsh7th/vim-vsnip", name = "vim-vsnip"})
-- add({source = "hrsh7th/vim-vsnip-integ", name = "vim-vsnip-integ"})
--
-- vim.cmd("colorscheme rose-pine")
--
-- -- Configure/enable plugins
-- require('rose-pine').setup()
-- require('mini.icons').setup()
-- require('hrsh7th/vim-vsnip').setup()
-- require('hrsh7th/vim-vsnip-integ').setup()
-- require('which-key').setup()
-- require('mini.git').setup()
-- require('mini.diff').setup()
-- require('mini.statusline').setup()
-- require('mini.pairs').setup()
-- require('mini.move').setup({
--	 mappings = {
--		 left = '<M-h>',
--		 right = '<M-l>',
--		 down = '<M-j>',
--		 up = '<M-k>',
--		 line_left = '<M-h>',
--		 line_right = '<M-l>',
--		 line_down = '<M-j>',
--		 line_up = '<M-k>',
--	 },
--	 options = {
--		 reindent_linewise = true,
--	 },
-- })
-- require('mini.comment').setup()
-- require('rafamadriz/friendly-snippets').setup()
-- require('saghen/blink.cmp').setup()
-- require('nvim-treesitter').setup()
-- require('mason').setup()
-- require('mason-lspconfig').setup()
-- local animate = require('mini.animate')
-- animate.setup({
--	 cursor = { enable = false },
--	 scroll = {
--		 -- To better know where i'm going with <C-d> and <C-u>
--		 timing = animate.gen_timing.linear({ duration = 10, unit = 'total' }),
--	 },
--	 resize = { enable = false },
-- })
