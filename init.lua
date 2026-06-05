vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.opt.cmdheight = 0
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "▎ ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 2
vim.opt.sj = -50 -- Emacs like scrolljump
vim.opt.foldmethod = "marker" -- Enables folding
vim.opt.foldlevel = 99 -- Don't close folds on file open
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.signcolumn = "yes"
vim.o.updatetime = 300
vim.o.timeoutlen = 300

-- Aliases
vim.api.nvim_create_user_command("Q", "qa!", {})
vim.api.nvim_create_user_command("LspInfo", "checkhealth lsp", {})

-- Keybinds
vim.keymap.set("n", "<Esc>", "<cmd>nohl<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Tabs, Splits and terminal
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("tabnew")
	vim.cmd("term")
end, { desc = "Open terminal in new tab" })
vim.keymap.set("n", "H", "gT", { desc = "Previus Tab" })
vim.keymap.set("n", "L", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "New Horizontal Split" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "New Vertical Split" })
vim.keymap.set("n", "<leader>sc", ":close<CR>", { desc = "Close Split" })
vim.keymap.set("n", "<leader>st", ":tab split<CR>", { desc = "Split to Tab" })
vim.keymap.set("n", "<leader>so", ":only<CR>", { desc = "Only split" })

-- Moving through splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper split" })

-- Don't deselect on copy (if Y is pressed) or indent/unindent
vim.keymap.set("v", "Y", "ygv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Emacs-like keymaps
vim.keymap.set({ "n", "v", "i" }, "<C-f>", "<Right>")
vim.keymap.set({ "n", "v", "i" }, "<C-b>", "<Left>")
vim.keymap.set({ "n", "v", "i" }, "<C-n>", "<Down>")
vim.keymap.set({ "n", "v", "i" }, "<C-p>", "<Up>")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>^")

-- K for useful info
vim.keymap.set("n", ";", vim.diagnostic.open_float)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

-- Shift enter for folds
vim.keymap.set("n", "<S-CR>", "zA", { silent = true })

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

-- Kickstart.nvim highlight when copying text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
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

-- LSP keybinds (from :help LSP)
vim.api.nvim_create_autocmd("LspAttach", {

	-- stylua: ignore
	callback = function()
		require("which-key").add({ { "<leader>l", desc = "[LSP]" } })
		vim.keymap.set("n", "<leader>k",  vim.lsp.buf.hover,            { desc = "Lsp Hover"        })
		vim.keymap.set("n", "<leader>K",  vim.lsp.buf.signature_help,   { desc = "Signature help"   })
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,           { desc = "Rename"           })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,      { desc = "Code action"      })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.references,       { desc = "References"       })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation,   { desc = "Implementation"   })
		vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition,  { desc = "Type definition"  })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition,       { desc = "Definition"       })
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration,      { desc = "Declaration"      })
		vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol,  { desc = "Document symbol"  })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format,           { desc = "Format"           })
	end,
})

local function run_build(name, cmd, cwd)
	local result = vim.system(cmd, { cwd = cwd }):wait()
	if result.code ~= 0 then
		local stderr = result.stderr or ""
		local stdout = result.stdout or ""
		local output = stderr ~= "" and stderr or stdout
		if output == "" then
			output = "No output from build command."
		end
		vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
			return
		end
	end,
})

---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

-- PLUGINS
vim.pack.add({
	-- {{{ APPEARANCE
	{
		src = gh("rose-pine/neovim"),
		name = "rose-pine",
	},
	gh("shellRaining/hlchunk.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("brenoprata10/nvim-highlight-colors"),
	-- }}}
	-- {{{ GENERAL
	gh("echasnovski/mini.nvim"),
	gh("NMAC427/guess-indent.nvim"),
	gh("folke/which-key.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("windwp/nvim-ts-autotag"), -- html auto tag completion
	-- }}}
	-- {{{ TELESCOPE
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-ui-select.nvim"),
	-- }}}
	-- {{{ LSP
	gh("j-hui/fidget.nvim"),
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	-- }}}
	-- {{{ FORMATTING
	gh("stevearc/conform.nvim"),
	-- }}}
	-- {{{ AUTOCOMPLETE
	gh("saghen/blink.lib"),
	gh("saghen/blink.cmp"),
	gh("rafamadriz/friendly-snippets"),
	-- }}}
	-- {{{ TREESITTER
	gh("nvim-treesitter/nvim-treesitter"),
	-- }}}
	-- {{{ OIL
	gh("stevearc/oil.nvim"),
	gh("benomahony/oil-git.nvim"),
	-- }}}
})

-- {{{ APPEARANCE
require("rose-pine").setup({
	variant = "moon",
	styles = {
		transparency = true,
	},
})
vim.cmd("colorscheme rose-pine")
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
-- }}}

-- {{{ GENERAL
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

		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." }, -- LEFT: not backslash
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." }, -- RIGHT: any character
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

		-- To open in a nice way the brackets when pressing enter
		[">"] = { action = "open", pair = "><", neigh_pattern = "$^$^", register = { cr = true } }, -- For html
		['"'] = { action = "open", pair = '""', neigh_pattern = "$^$^", register = { cr = true } }, -- Neigh pattern that never matches
		["'"] = { action = "open", pair = "''", neigh_pattern = "$^$^", register = { cr = true } },
		['`'] = { action = "open", pair = "``", neigh_pattern = "$^$^", register = { cr = true } },
		-- For actual autopairs
		-- ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = "[%c (%[{<'`=][%c )%]}>'`]", register = { cr = true } },
		-- ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = "[%c (%[{<\"`=][%c )%]}>\"`]", register = { cr = true } },
		-- ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = "[%c (%[{<'\"=][%c )%]}>'\"]", register = { cr = true } },
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
-- }}}

-- {{{ TELESCOPE

require("telescope").setup()

do -- For the map function
	local builtin = require("telescope.builtin")
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, "<leader>" .. keys, func, { desc = desc })
	end

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
	map("<leader>", builtin.buffers, "[FIND BUFFERS]")

	map("f/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, "Find in open buffers")
end
-- }}}

-- {{{ LSP
require("fidget").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, "<leader>" .. keys, func, { buffer = event.buf, desc = desc })
		end

		map("k", vim.lsp.buf.hover, "Lsp Hover")
		map("K", vim.lsp.buf.signature_help, "Signature help")
		map("lr", vim.lsp.buf.rename, "Rename")
		map("la", vim.lsp.buf.code_action, "Code action")
		map("lf", vim.lsp.buf.references, "References")
		map("li", vim.lsp.buf.implementation, "Implementation")
		map("lt", vim.lsp.buf.type_definition, "Type definition")
		map("ld", vim.lsp.buf.definition, "Definition")
		map("lD", vim.lsp.buf.declaration, "Declaration")
		map("ls", vim.lsp.buf.document_symbol, "Document symbol")
		map("lf", vim.lsp.buf.format, "Format")

		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("lh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "Toggle Inlay Hints")
		end
	end,
})

-- Checks if the LSP servers are already installed on the system
-- and installs them with Mason if needed
-- stylua: ignore
local to_check = {
	-- LSP EXECUTABLE NAME -- NVIM LSP NAME  -- CMDLINE ARGUMENTS
	{ "lua-language-server",  "lua_ls",         ""              },
	{ "clangd",               "",               ""              },
	{ "harper-ls",            "harper_ls",      "--stdio"       },
	{ "vtsls",                "",               "--stdio"       },
	{ "stylua",               "",               "--lsp"         },
	{ "prettier",             "",               ""              },
	{ "rust-analyzer",        "rust_analyzer",  ""              },
	{ "bash-language-server", "bashls",         "start"         },
}

--We also need to enable them below for them to work
---@type table<string, vim.lsp.Config>
local servers = {
	clangd = {},
	harper_ls = {},
	vtsls = {},
	stylua = {},
	prettier = {},
	rust_analyzer = {},
	bashls = {},
	lua_ls = { -- {{{
		on_init = function(client)
			client.server_capabilities.documentFORMATTINGProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					}),
				},
			})
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	}, -- }}}
}

require("mason").setup()
-- local ensure_installed = vim.tbl_keys(servers or {})

local function checkfor(s)
	local f = io.popen("which " .. tostring(s), "r")
	if not f then
		return nil
	end
	local path = f:read("*a"):gsub("\n*$", "")
	local suc = not (path == "")
	f:close() -- f:close() success/status code isn't accurate
	return suc, path
end

local to_install = {}

for _, lsp_item in ipairs(to_check) do
	local suc, path = checkfor(lsp_item[1])
	local lsp_name = lsp_item[1]
	if not (lsp_item[2] == "") then
		lsp_name = lsp_item[2]
	end
	if suc then
		if lsp_item[3] == "" then
			vim.lsp.config(lsp_name, {
				cmd = { path },
			})
		else
			vim.lsp.config(lsp_name, {
				cmd = { path, lsp_item[3] },
			})
		end
		-- vim.lsp.enable(lspitem)
	else
		table.insert(to_install, lsp_name)
	end
end

require("mason-tool-installer").setup({ ensure_installed = to_install })

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
-- }}}

-- {{{ FORMATTING
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
		javascript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		markdown = { "prettier" },
	},
	formatters = {
		prettier = {
			prepend_args = { "--use-tabs" },
		},
	},
})
-- }}}

-- {{{ AUTOCOMPLETE
require("blink.cmp").setup({
	keymap = {
		-- All presets have the following mappings:
		-- <tab>/<s-tab>: move to right/left of your snippet expansion
		-- <c-space>: Open menu or open docs if already open
		-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
		-- <c-e>: Hide menu
		-- <c-k>: Toggle signature help
		--
		-- See `:help blink-cmp-config-keymap` for defining your own keymap
		preset = "default",
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		-- By default, you may press `<c-space>` to show the documentation.
		-- Optionally, set `auto_show = true` to show the documentation after a delay.
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},

	sources = {
		default = { "lsp", "path", "snippets" },
	},
	fuzzy = { implementation = "lua" },
	-- Shows a signature help window while you type arguments for a function
	signature = { enabled = true },
})
-- }}}

-- {{{ TREESITTER
local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
}
require("nvim-treesitter").install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
	if not vim.treesitter.language.add(language) then
		return
	end
	-- Enable syntax highlighting and other treesitter features
	vim.treesitter.start(buf, language)

	-- Enable treesitter based folds
	-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	-- vim.wo.foldmethod = 'expr'

	-- Check if treesitter indentation is available for this language, and if so enable it
	-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
	local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

	-- Enable treesitter based indentation
	if has_indent_query then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		local installed_parsers = require("nvim-treesitter").get_installed("parsers")

		if vim.tbl_contains(installed_parsers, language) then
			-- Enable the parser if it is already installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
			require("nvim-treesitter").install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end,
})
-- }}}
-- {{{ OIL
require("oil").setup({
	columns = {},
	-- keymaps = {
	-- 	["g?"] = { "actions.show_help", mode = "n" },
	-- 	["<leader>o?"] = { "actions.show_help", mode = "n" },
	-- 	["<CR>"] = "actions.select",
	-- 	["<C-s>"] = { "actions.select", opts = { vertical = true } },
	-- 	["<leader>ol"] = { "actions.select", opts = { vertical = true } },
	-- 	["<C-p>"] = "actions.preview",
	-- 	["<leader>op"] = "actions.preview",
	-- 	["<C-c>"] = { "actions.close", mode = "n" },
	-- 	["<Esc>"] = { "actions.refresh", mode = "n" },
	-- 	["-"] = { "actions.parent", mode = "n" },
	-- 	["<leader>o-"] = { "actions.parent", mode = "n" },
	-- 	["_"] = { "actions.open_cwd", mode = "n" },
	-- 	["<leader>o_"] = { "actions.open_cwd", mode = "n" },
	-- 	["`"] = { "actions.cd", mode = "n" },
	-- 	["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
	-- 	["<leader>od"] = { "actions.cd", mode = "n" },
	-- 	["gs"] = { "actions.change_sort", mode = "n" },
	-- 	["<leader>os"] = { "actions.change_sort", mode = "n" },
	-- 	["gx"] = "actions.open_external",
	-- 	["g."] = { "actions.toggle_hidden", mode = "n" },
	-- 	["<leader>o."] = { "actions.toggle_hidden", mode = "n" },
	-- 	["g\\"] = { "actions.toggle_trash", mode = "n" },
	-- 	["<leader>o\\"] = { "actions.toggle_trash", mode = "n" },
	-- },
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
-- }}}
