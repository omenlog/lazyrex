local M = {}

local function check_executable(name, label)
	if vim.fn.executable(name) == 1 then
		vim.health.ok(label .. ": " .. vim.fn.exepath(name))
		return
	end

	vim.health.error(label .. " is not available on PATH", {
		"Install " .. label .. " and ensure its executable is available in Neovim's PATH.",
	})
end

function M.check()
	vim.health.start("lazyrex.nvim")

	check_executable("rex", "Rex executable")
	check_executable("lazygit", "LazyGit executable")
end

return M
