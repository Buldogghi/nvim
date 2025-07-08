-- KEYBINDS
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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

-- Tabs (and Splits)
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Only Tab" })
vim.keymap.set("n", "H", "gT", { desc = "Previus Tab" })
vim.keymap.set("n", "L", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>tsn", ":vsplit<CR>", { desc = "New Split (vertical)" })
vim.keymap.set("n", "<leader>tsh", ":split<CR>", { desc = "New Horizontal Split" })
vim.keymap.set("n", "<leader>tsv", ":vsplit<CR>", { desc = "New Vertical Split" })
vim.keymap.set("n", "<leader>tsc", ":close<CR>", { desc = "Close Split" })
vim.keymap.set("n", "<leader>tst", ":tab split<CR>", { desc = "Split to Tab" })
vim.keymap.set("n", "<leader>tso", ":only<CR>", { desc = "Only split" })

-- Git DiffView

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "Refresh Diffview" })

-- jk in wrapped text
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")

-- Moving through splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper split" })

-- Kickstart.nvim highlight when copying text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- paste the last yanked text not deleted text (you can still use Ctrl + Shift + V to pase)
vim.keymap.set("n", "p", "\"0p")
vim.keymap.set("n", "P", "\"0P")
vim.keymap.set("v", "p", "\"0p")
vim.keymap.set("v", "P", "\"0P")

-- OPTIONS

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.mouse = "a"

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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Number of lines above/below the cursor everytime
vim.opt.scrolloff = 3

