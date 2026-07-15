-- PLUGINS
require("plugins").install({
	"j-hui/fidget.nvim",
	"neovim/nvim-lspconfig",
	"mason-org/mason.nvim",
	-- "mason-org/mason-lspconfig.nvim",
})

-- ALIASES

---Function that gets the current buffer's language and gives you a list
---of available lsps in Mason, inspired by the function with the same name
---in mason-lspconfig (not using that since it doesn't show every lsp)
local function LspInstall(filetype)
	local valid = {}
	local specs = require("mason-registry").get_all_package_specs()
	for _, v in pairs(specs) do
		for _, lang in pairs(v.languages) do
			if string.lower(lang) == filetype then
				for _, cat in pairs(v.categories) do
					if cat == "LSP" then
						table.insert(valid, v)
						break
					end
				end
			end
		end
	end
	table.sort(valid, function(a, b)
		if a.name < b.name then
			return true
		else
			return false
		end
	end)
	vim.ui.select(valid, {
		format_item = function(package)
			local name = package.name .. ":"
			for _, lang in pairs(package.languages) do
				name = name .. " " .. lang
			end
			return name
		end,
	}, function(input)
		if input == nil then
			return
		end
		require("mason.api.command").MasonInstall({ input.name })
	end)
end

vim.api.nvim_create_user_command("LspInfo", "checkhealth lsp", {
	desc = "Check lsp status",
})

vim.api.nvim_create_user_command("LspInstall", function(opts)
	if opts.args == "" then
		LspInstall(vim.bo.filetype)
	else
		LspInstall(opts.args)
	end
end, {
	desc = "Install lsp for current or specified filetype",
	nargs = "*",
})

vim.api.nvim_create_user_command("LspStart", function(opts)
	vim.lsp.enable(opts.fargs)
end, {
	desc = "Start lsp (like vim.lsp.enable(lsp))",
	nargs = "*",
})

vim.api.nvim_create_user_command("LspStop", function(opts)
	vim.lsp.enable(opts.fargs, false)
end, {
	desc = "Stops lsp (like vim.lsp.enable(lsp, false))",
	nargs = "*",
})

vim.api.nvim_create_user_command("NoHarper", function(_)
	vim.lsp.enable("harper_ls", false)
end, {
	desc = "Disable harper_ls's spell check",
})

vim.api.nvim_create_user_command("Harper", function(_)
	vim.lsp.enable("harper_ls", true)
end, {
	desc = "Enable harper_ls's spell check",
})

-- CONFIG
require("fidget").setup({})

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
-- and activates them
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
	{ "ols",                  "",               ""              },
}

--We also need to enable them below for them to work
---@type table<string, vim.lsp.Config>
local servers = {
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

-- local to_install = {}

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
		vim.lsp.enable(lsp_name)
	end
end

-- require("mason-lspconfig").setup({ ensure_installed = to_install })
-- require("mason-lspconfig").setup({}) -- Automatically enable them

-- Automatically enable every installed lsp in Mason
for _, installed in pairs(require("mason-registry").get_installed_package_names()) do
	vim.lsp.enable(installed)
end

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
