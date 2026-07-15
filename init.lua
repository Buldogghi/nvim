do -- SETTINGS
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
	vim.opt.sj = -50 -- Emacs-like scrolljump
	vim.opt.foldmethod = "marker" -- Enables folding
	vim.opt.foldlevel = 99 -- Don't automatically close folds when opening a file
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)
	vim.o.signcolumn = "yes"
	vim.o.updatetime = 300
	vim.o.timeoutlen = 300

	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },
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
end

do -- BASIC ALIASES
	vim.api.nvim_create_user_command("Q", "qa!", {})
end

do -- KEYBINDS
	vim.keymap.set("n", "<Esc>", "<cmd>nohl<CR>")
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
	-- vim.keymap.set({ "n", "v" }, "j", "gj")
	-- vim.keymap.set({ "n", "v" }, "k", "gk")

	-- Tabs and splits
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
	-- vim.keymap.set("n", "<S-CR>", "zA", { silent = true })
end

do -- AUTOCMDS
	-- From kickstart.nvim, highlight when copying text
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
				return -- Oil is the file explorer
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

	-- From kickstart.nvim
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
end

do -- PLUGINS
	require("plugins/appearance")
	require("plugins/general")
	require("plugins/telescope")
	require("plugins/lsp")
	require("plugins/formatting")
	require("plugins/autocomplete")
	require("plugins/treesitter")
	require("plugins/oil")
end
