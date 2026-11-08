local terminal = "com.superlogical.terminal"
local file = rex.args.file
local line = tonumber(rex.args.line)
local nvim_server = os.getenv("NVIM")
local nvim_block = os.getenv("LAZYREX_NVIM_BLOCK")
local lazygit_label = os.getenv("LAZYREX_LABEL")

if rex.block_id == nil then
	error("Open a LazyGit file from a Rex pane", 0)
end
if type(file) ~= "string" or file == "" then
	error("Missing file to edit", 0)
end
if nvim_server == nil or nvim_server == "" then
	error("LazyGit was not started by lazyrex.nvim", 0)
end
if nvim_block == nil or nvim_block == "" then
	error("LazyGit was not started by lazyrex.nvim", 0)
end

local rex_dir = os.getenv("LAZYREX_REX_DIR")
if rex_dir == nil or rex_dir == "" then
	error("LazyGit was not started by lazyrex.nvim", 0)
end
package.path = rex_dir .. "/?.lua;" .. package.path
local utils = require("utils")

local layer, layer_err = utils.get_layer(rex.block_id, lazygit_label)
if layer_err ~= nil then error(layer_err, 0) end

local _, minimize_err = utils.minimize_layer(layer)
if minimize_err ~= nil then error(minimize_err, 0) end

local opened, open_err = rex.exec({
	"nvim",
	"--server",
	nvim_server,
	"--remote-tab",
	file,
})
if opened == nil then error(open_err, 0) end
if not opened.ok then error(opened.stderr, 0) end

if line ~= nil then
	local moved, move_err = rex.exec({
		"nvim",
		"--server",
		nvim_server,
		"--remote-send",
		":" .. math.floor(line) .. "<CR>",
	})
	if moved == nil then error(move_err, 0) end
	if not moved.ok then error(moved.stderr, 0) end
end

local _, focus_err = rex.session.focus_block({ block_id = nvim_block })
if focus_err ~= nil then error(focus_err, 0) end
