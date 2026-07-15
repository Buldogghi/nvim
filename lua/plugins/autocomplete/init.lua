-- PLUGINS
require("plugins").install({
	"saghen/blink.lib",
	"saghen/blink.cmp",
	"rafamadriz/friendly-snippets",
})

-- CONFIG
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
