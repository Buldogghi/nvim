return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		opts = {
			check_ts = true, -- use treesitter to skip pairs in comments/strings
			enable_check_bracket_line = false,
			fast_wrap = {}, -- configure the fast wrap keybindings if you like
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)
			-- integrate with nvim-cmp
			local has_cmp, cmp = pcall(require, "cmp")
			if has_cmp then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},
}

