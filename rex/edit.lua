local terminal = "com.superlogical.terminal"
local file = rex.args.file
local line = tonumber(rex.args.line)
local nvim_server = os.getenv("NVIM")
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

local function get_lazygit_layer_id()
	local view, view_err = rex.session.view({})
	if view_err ~= nil then return nil, view_err end

	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			if layer.kind == "floating" then
				for _, block in ipairs(layer.blocks or {}) do
					if block.block_id == rex.block_id and block.label == lazygit_label then return layer.layer_id end
				end
			end
		end
	end
end

local layer_id, layer_err = get_lazygit_layer_id()
if layer_err ~= nil then error(layer_err, 0) end
if layer_id ~= nil then
	local _, minimize_err = rex.session.set_layer_state({
		layer_id = layer_id,
		state = "minimized",
	})
	if minimize_err ~= nil then error(minimize_err, 0) end
end

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

