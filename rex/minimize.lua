local lazygit_label = os.getenv("LAZYREX_LABEL")

if rex.block_id == nil then
	error("Open LazyGit from a Rex pane", 0)
end
if lazygit_label == nil or lazygit_label == "" then
	error("LazyGit was not started by lazyrex.nvim", 0)
end

local rex_dir = os.getenv("LAZYREX_REX_DIR")
if rex_dir == nil or rex_dir == "" then
	error("LazyGit was not started by lazyrex.nvim", 0)
end

package.path = rex_dir .. "/?.lua;" .. package.path
local utils = require("utils")

local layer_id, layer_err = utils.get_floating_layer_id(rex.block_id, lazygit_label)
if layer_err ~= nil then error(layer_err, 0) end
if layer_id == nil then error("LazyGit floating layer not found", 0) end

local _, minimize_err = rex.session.set_layer_state({
	layer_id = layer_id,
	state = "minimized",
})
if minimize_err ~= nil then error(minimize_err, 0) end
