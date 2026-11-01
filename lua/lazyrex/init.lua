local config_module = require("lazyrex.config")
local rex_config = require("lazyrex.rex_config")

local M = {}

local function open_lazygit(config)
	if vim.fn.executable("lazygit") ~= 1 then
		vim.notify("lazyrex.nvim: lazygit is not available on PATH", vim.log.levels.ERROR)
		return
	end
	if vim.env.REX_SESSION == nil or vim.env.REX_BLOCK == nil then
		vim.notify("lazyrex.nvim: open LazyGit from a Rex pane", vim.log.levels.ERROR)
		return
	end
	if vim.fn.executable(config.rex_path) ~= 1 then
		vim.notify("lazyrex.nvim: rex is not available on PATH", vim.log.levels.ERROR)
		return
	end

	local server = vim.v.servername
	if server == "" then
		server = vim.fn.serverstart()
	end

	local result = vim.system({
		config.rex_path,
		"do",
		"--session",
		vim.env.REX_SESSION,
		"--block",
		vim.env.REX_BLOCK,
		"lazygit_open",
		"nvim_server=" .. server,
	}, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("lazyrex.nvim: " .. result.stderr, vim.log.levels.ERROR)
	end
end

---@param options? table
function M.setup(options)
	local config = config_module.setup(options)
	local err = rex_config.sync(config)
	if err then
		vim.notify("lazyrex.nvim: could not configure Rex: " .. err, vim.log.levels.ERROR)
		return
	end

	vim.keymap.set("n", config.key, function()
		open_lazygit(config)
	end, { desc = "Open LazyGit in Rex" })
end

return M
