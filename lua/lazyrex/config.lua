local M = {}

M.defaults = {
	rex_path = "rex",
	bounds = { 0.2, 0.2, 0.7, 0.7 },
	lazygit_command = { "lazygit" },
}

---@param options? table
---@return table
function M.setup(options)
	local config = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
	return config
end

return M
