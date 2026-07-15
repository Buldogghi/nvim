local M = {}

-- Function to install plugins assuming they are from github,
-- if they aren't you can just write them like { src "https://mysite/plugin" },
---@param plugins table<string|vim.pack.Spec>
function M.install(plugins)
	local toinstall = {} --- @type vim.pack.Plug[]
	for i, e in pairs(plugins) do
		e = type(e) == "string" and { src = "https://github.com/" .. e } or e
		local name = e.name or e.src:gsub("%.git$", "")
		name = (type(name) == "string" and name or ""):match("[^/]+$") or ""
		toinstall[i] = e
	end
	vim.pack.add(toinstall)
end

return M
