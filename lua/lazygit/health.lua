local M = {}

local function rex_config_dir()
	local config_home = vim.env.XDG_CONFIG_HOME
	if not config_home or config_home == "" then
		config_home = vim.fn.expand("~/.config")
	end

	return config_home .. "/rex"
end

local function check_directory(path, label)
	if vim.fn.isdirectory(path) == 1 then
		vim.health.ok(label .. ": " .. path)
	else
		vim.health.error(label .. " is missing: " .. path, {
			"Run require(\"lazygit\").setup() to install the Rex integration.",
		})
	end
end

local function check_file(path, label, executable)
	if vim.fn.filereadable(path) ~= 1 then
		vim.health.error(label .. " is missing: " .. path, {
			"Run require(\"lazygit\").setup() to regenerate the Rex integration.",
		})
		return
	end

	if executable and vim.fn.executable(path) ~= 1 then
		vim.health.error(label .. " is not executable: " .. path, {
			"Run require(\"lazygit\").setup() to repair its permissions.",
		})
		return
	end

	vim.health.ok(label .. ": " .. path)
end

function M.check()
	vim.health.start("lazygit.nvim")

	local rex_dir = rex_config_dir()
	local integration_dir = rex_dir .. "/lazygit"
	check_directory(rex_dir, "Rex configuration directory")
	check_directory(integration_dir, "LazyGit Rex integration directory")
	check_file(rex_dir .. "/init.lua", "Rex configuration loader")
	check_file(integration_dir .. "/init.lua", "Generated Rex action")
	check_file(integration_dir .. "/lazygit.yml", "Generated LazyGit configuration")
	check_file(integration_dir .. "/lazygit-edit", "Generated LazyGit edit helper", true)

	if vim.fn.executable("lazygit") == 1 then
		vim.health.ok("lazygit executable: " .. vim.fn.exepath("lazygit"))
	else
		vim.health.error("lazygit executable is not available on PATH", {
			"Install LazyGit and ensure its executable is available in Neovim's PATH.",
		})
	end
end

return M
