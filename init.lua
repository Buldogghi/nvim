-- Nvim single-file config

-- {{{ Settings

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.termguicolors = true -- Tell neovim my terminal supports colors
vim.opt.mouse = "a"
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.splitright = true -- Open splits to the right instead of left
vim.opt.splitbelow = true -- Open splits below instead of above
vim.opt.list = true -- Enable custom whitespace characters
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = "▎ ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 3 -- Number of lines above/below the cursor everytime
vim.schedule(function() -- Sync clipboard between OS and Neovim.
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.foldmethod = "marker" -- Enables folding

-- Aliases
vim.api.nvim_command("cabbrev Q q!")

--- }}}

-- {{{ Keybinds

-- stylua: ignore start
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic keybinds
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Buffers
vim.keymap.set("n", "<leader>bq", ":Bdelete<CR>",  { desc = "Delete Buffer"  })
vim.keymap.set("n", "<leader>bQ", ":Bwipeout<CR>", { desc = "Wipeout Buffer" })
vim.keymap.set("n", "<leader>bo", function()
	local currentBuf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= currentBuf then
			require("bufdelete").bufdelete(buf, true)
		end
	end
end, { desc = "Delete other buffers", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New blank buffer" })

-- Tabs (and Splits (and terminal))
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>",   { desc = "New Tab"   })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("tabnew")
	vim.cmd("term")
end, { desc = "Open terminal in new tab" })
vim.keymap.set("n", "H",          "gT",             { desc = "Previus Tab"          })
vim.keymap.set("n", "L",          "gt",             { desc = "Next Tab"             })
vim.keymap.set("n", "<leader>sn", ":vsplit<CR>",    { desc = "New Split (vertical)" })
vim.keymap.set("n", "<leader>sh", ":split<CR>",     { desc = "New Horizontal Split" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>",    { desc = "New Vertical Split"   })
vim.keymap.set("n", "<leader>sc", ":close<CR>",     { desc = "Close Split"          })
vim.keymap.set("n", "<leader>st", ":tab split<CR>", { desc = "Split to Tab"         })
vim.keymap.set("n", "<leader>so", ":only<CR>",      { desc = "Only split"           })

-- Git DiffView
vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "Refresh Diffview" })

-- jk in wrapped text
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Moving through splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left split"  })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper split" })

-- paste the last yanked text not deleted text (you can still use Ctrl + Shift + V to paste)
-- vim.keymap.set({ "n", "v" }, "p", '"0p')
-- vim.keymap.set({ "n", "v" }, "P", '"0P')

-- Don't deselect on copy (if Y is pressed) or indent/deindent
vim.keymap.set("v", "Y", "ygv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- stylua: ignore end

-- }}}

-- {{{ Autocmds

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
	callback = function()
		if vim.bo.filetype == "oil" then
			return
		end
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Lsp keybinds (from :help lsp)
vim.api.nvim_create_autocmd("LspAttach", {

	-- stylua: ignore
	callback = function()
		require("which-key").add({ { "<leader>l", desc = "[LSP]" } })

		vim.keymap.set({ "n"      }, "<leader>lr", vim.lsp.buf.rename,           { desc = "Rename"           })
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action,      { desc = "Code action"      })
		vim.keymap.set({ "n"      }, "<leader>lf", vim.lsp.buf.references,       { desc = "References"       })
		vim.keymap.set({ "n"      }, "<leader>li", vim.lsp.buf.implementation,   { desc = "Implementation"   })
		vim.keymap.set({ "n"      }, "<leader>lt", vim.lsp.buf.type_definition,  { desc = "Type definition"  })
		vim.keymap.set({ "n"      }, "<leader>ld", vim.lsp.buf.definition,       { desc = "Definition"       })
		vim.keymap.set({ "n"      }, "<leader>lD", vim.lsp.buf.declaration,      { desc = "Declaration"      })
		vim.keymap.set({ "n"      }, "<leader>ls", vim.lsp.buf.document_symbol,  { desc = "Document symbol"  })
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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		require("which-key").add({ "<leader>o", "[OIL]" })
		-- Only to set a description
		vim.keymap.set("n", "<leader>o?", "", { desc = "Show help [g?]" })
		vim.keymap.set("n", "<leader>ol", "", { desc = "Open dir on another split [gs]" })
		vim.keymap.set("n", "<leader>op", "", { desc = "Toggle preview [<C-p>]" })
		vim.keymap.set("n", "<leader>o-", "", { desc = "Go to parent [-]" })
		vim.keymap.set("n", "<leader>o_", "", { desc = "Go to cwd [_]" })
		vim.keymap.set("n", "<leader>od", "", { desc = "Get cwd [~]" })
		vim.keymap.set("n", "<leader>os", "", { desc = "Change sort [gs]" })
		vim.keymap.set("n", "<leader>oh", "", { desc = "Toggle hidden file [g.]" })
		vim.keymap.set("n", "<leader>o\\", "", { desc = "Toggle trash view [g\\]" })
	end,
})

-- }}}

-- {{{ Plugins

require("lazy").setup({
	spec = { -- Plugins:
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
		{
			"echasnovski/mini.nvim",
			config = function() -- Configuration of mini.nvim modules
				require("mini.icons").setup()
				require("mini.git").setup()
				require("mini.diff").setup()
				require("mini.statusline").setup()
				require("mini.pairs").setup({
					-- stylua: ignore
					mappings = {
						-- For more info about lua patterns:
						-- https://gitspartv.github.io/lua-patterns/

						-- [%c ][%c ] Means that for the quotes to be doubled the character
						-- before the cursor needs to be an escape character (%c = "\t\n\r")
						-- or a space and the next/previous character needs to also be that.


						["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." }, -- LEFT: not backslash
						["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." }, -- RIGHT: any character
						["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

						[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
						["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
						["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

						['"'] = { action = 'closeopen', pair = '""', neigh_pattern = "[%c (%[{<'`=][%c )%]}>'`]", register = { cr = true } },
						["'"] = { action = 'closeopen', pair = "''", neigh_pattern = "[%c (%[{<\"`=][%c )%]}>\"`]", register = { cr = true } },
						['`'] = { action = 'closeopen', pair = '``', neigh_pattern = "[%c (%[{<'\"=][%c )%]}>'\"]", register = { cr = true } },
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
				require("mini.notify").setup()
			end,
		},
		{ "karb94/neoscroll.nvim", opts = {
			duration_multiplier = 0.5,
		} },
		{
			"sindrets/diffview.nvim",
			config = function()
				require("diffview").setup()
			end,
		},
		{
			"NMAC427/guess-indent.nvim",
			config = function()
				require("guess-indent").setup({})
			end,
		},
		{
			"shellRaining/hlchunk.nvim",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
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
					ensure_installed = { "lua_ls", "clangd", "stylua", "prettier", "prettierd" },
				})
				require("mason-lspconfig").setup()
			end,
		},
		{ -- Configure format_on_save and formatters
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					format_on_save = function(bufnr) -- From kickstart.nvim
						-- Disable "format_on_save lsp_fallback" for languages that don't
						-- have a well standardized coding style. You can add additional
						-- languages here or re-enable it for the disabled ones.
						local disable_filetypes = { c = true, cpp = true }
						if disable_filetypes[vim.bo[bufnr].filetype] then
							return nil
						else
							return {
								timeout_ms = 500,
								lsp_format = "fallback",
							}
						end
					end,
					formatters_by_ft = { -- :help conform.format
						lua = { "stylua" },
						javascript = { "prettierd", "prettier", stop_after_first = true },
					},
				})
			end,
		},
		{
			"brenoprata10/nvim-highlight-colors",
			config = function()
				require("nvim-highlight-colors").setup({
					render = "virtual",
					virtual_symbol_prefix = "[",
					virtual_symbol_suffix = "]",
					virtual_symbol_position = "eow", -- Stands for end of word
				})
			end,
		},
		{ "nvim-treesitter/nvim-treesitter" },
		{
			"folke/which-key.nvim",
			config = function()
				-- stylua: ignore
				require("which-key").setup({
					icons = {
						group = "",
						mappings = false,
					}
				})
				require("which-key").add({
					{ "<leader>b", desc = "[BUFFERS]" },
					{ "<leader>s", desc = "[SPLITS]" },
					{ "<leader>t", desc = "[TABS]" },
					{ "<leader>f", desc = "[TELESCOPE]" },
					{ "<leader>d", desc = "[DIFFVIEW]" },
				})
			end,
		},
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
			"folke/flash.nvim",
			event = "VeryLazy",
			---@type Flash.Config
			opts = {
				label = {
					style = "inline",
					rainbow = {
						enabled = true,
						shade = 2,
					},
				},
				modes = {
					search = {
						enabled = false,
					},
					char = {
						enabled = false,
					},
				},
			},
			-- stylua: ignore
			keys = {
				{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash"               },
				{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter"    },
				{ "r",     mode = {           "o" }, function() require("flash").remote() end,            desc = "Remote Flash"        },
				{ "R",     mode = {      "x", "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search"   },
				{ "<c-s>", mode =        "c",        function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
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
			"nvim-telescope/telescope.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				require("telescope").setup({
					defaults = require("telescope.themes").get_ivy({}),
				})
				-- stylua: ignore start
				vim.keymap.set("n", "<leader>ff",       require("telescope.builtin").find_files,  { desc = "Find Files"       })
				vim.keymap.set("n", "<leader>fb",       require("telescope.builtin").buffers,     { desc = "Find Buffers"     })
				vim.keymap.set("n", "<leader>fj",       require("telescope.builtin").git_files,   { desc = "Find Git Files"   })
				vim.keymap.set("n", "<leader>fk",       require("telescope.builtin").git_status,  { desc = "Find Git Status"  })
				vim.keymap.set("n", "<leader>fd",       require("telescope.builtin").live_grep,   { desc = "Find in Current"  })
				vim.keymap.set("n", "<leader>fh",       require("telescope.builtin").help_tags,   { desc = "Find Help"        })
				vim.keymap.set("n", "<leader>fc",       require("telescope.builtin").git_commits, { desc = "Find Git Commits" })
				vim.keymap.set("n", "<leader><leader>", require("telescope.builtin").buffers,     { desc = "[FIND BUFFERS]"   })
				-- stylua: ignore end
			end,
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
		{
			"kevinhwang91/nvim-ufo",
			dependencies = {
				"kevinhwang91/promise-async",
			},
			config = function()
				vim.o.foldcolumn = "1"
				vim.o.foldlevel = 99
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true
				vim.keymap.set("n", "zR", require("ufo").openAllFolds)
				vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				}
				local language_servers = vim.lsp.get_clients()
				for _, ls in ipairs(language_servers) do
					require("lspconfig")[ls].setup({
						capabilities = capabilities,
					})
				end
				require("ufo").setup()
			end,
		},
		{
			"stevearc/oil.nvim",
			---@module 'oil'
			---@type oil.SetupOpts
			dependencies = {
				"folke/which-key.nvim",
			},
			config = function()
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
			end,
			lazy = false,
		},
		{
			"benomahony/oil-git.nvim",
			dependencies = { "stevearc/oil.nvim" },
		},
	},
	lockfile = "/dev/null", -- don't generate a lazy-lock.json file
	checker = { enabled = false },
})

-- }}}
