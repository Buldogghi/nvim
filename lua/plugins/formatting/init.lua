-- PLUGINS
require("plugins").install({
	"stevearc/conform.nvim",
})

-- CONFIG
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
