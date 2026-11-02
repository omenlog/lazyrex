local config_module = require("lazyrex.config")

local M = {}

local source = debug.getinfo(1, "S").source
local rex_scripts_dir = vim.fn.fnamemodify(source:sub(2), ":p:h:h:h") .. "/rex"
local nvim_server

local function get_nvim_server()
	if nvim_server == nil then
		nvim_server = vim.v.servername
		if nvim_server == "" then
			nvim_server = vim.fn.serverstart()
		end
	end
	return nvim_server
end

local function check_requirements(config)
	if vim.fn.executable("lazygit") ~= 1 then return "lazygit is not available on PATH" end
	if vim.env.REX_SESSION == nil or vim.env.REX_BLOCK == nil then return "open LazyGit from a Rex pane" end
	if vim.fn.executable(config.rex_path) ~= 1 then return "rex is not available on PATH" end
end

local function open_lazygit(config)
	local err = check_requirements(config)
	if err then
		vim.notify("lazyrex.nvim: " .. err, vim.log.levels.ERROR)
		return
	end

	local server = get_nvim_server()

	local result = vim.system({
		config.rex_path,
		"do",
		"--session",
		vim.env.REX_SESSION,
		"--block",
		vim.env.REX_BLOCK,
		rex_scripts_dir .. "/lazygit.lua",
		"--args",
		vim.json.encode({
			nvim_server = server,
			rex_dir = rex_scripts_dir,
			bounds = config.bounds,
			lazygit_command = config.lazygit_command,
		}),
	}, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("lazyrex.nvim: " .. result.stderr, vim.log.levels.ERROR)
	end
end

---@param options? table
function M.setup(options)
	local config = config_module.setup(options)
	vim.api.nvim_create_user_command("Lazyrex", function()
		open_lazygit(config)
	end, { desc = "Open LazyGit in Rex", force = true })
end

return M
