local terminal = "com.superlogical.terminal"
local args = rex.args

if rex.block_id == nil then
	error("Open LazyGit from a Rex pane", 0)
end

if type(args.nvim_server) ~= "string" or args.nvim_server == "" then
	error("Missing Neovim server address", 0)
end
if type(args.rex_dir) ~= "string" or args.rex_dir == "" then
	error("Missing lazyrex Rex script directory", 0)
end
if type(args.lazygit_command) ~= "table" or #args.lazygit_command == 0 then
	error("Missing LazyGit command", 0)
end
for _, argument in ipairs(args.lazygit_command) do
	if type(argument) ~= "string" or argument == "" then
		error("Invalid LazyGit command", 0)
	end
end

local process, process_err = rex.block.call(terminal, "process", {
	block_id = rex.block_id,
})
if process_err ~= nil then error(process_err, 0) end
local cwd = process.foreground and process.foreground.cwd
if cwd == nil then error("Current pane has no readable working directory", 0) end

local lazygit_config = args.rex_dir .. "/lazygit.yml"

local function lazygit_config_files()
	local result = rex.exec({ "lazygit", "--print-config-dir" }, { timeout = 2 })
	if result ~= nil and result.ok then
		local directory = result.stdout:match("^%s*(.-)%s*$")
		if directory ~= "" then return directory .. "/config.yml," .. lazygit_config end
	end
	return lazygit_config
end

local label = "lazygit:" .. args.nvim_server
local view, view_err = rex.session.view({})
if view_err ~= nil then error(view_err, 0) end

for _, window in ipairs(view.windows or {}) do
	for _, layer in ipairs(window.layers or {}) do
		for _, block in ipairs(layer.blocks or {}) do
			if block.label == label then
				local status = rex.block.call(terminal, "process", { block_id = block.block_id })
				if status ~= nil and status.last_exit == nil then
					local restored, restore_err = rex.session.set_layer_state({
						layer_id = layer.layer_id,
						state = "normal",
						focus = true,
					})
					if restore_err ~= nil then error(restore_err, 0) end
					return restored
				end
			end
		end
	end
end

local command = {
	"env",
	"LG_CONFIG_FILE=" .. lazygit_config_files(),
	"LAZYREX_REX_DIR=" .. args.rex_dir,
	"LAZYREX_LABEL=" .. label,
	"NVIM=" .. args.nvim_server,
}
for _, argument in ipairs(args.lazygit_command) do
	table.insert(command, argument)
end
local layer, layer_err = rex.session.new_layer({
	bounds = args.bounds,
	focus = true,
	layout = rex.layout.block({
		flavor = "com.superlogical.terminal.shell",
		label = label,
		options = { command = command, cwd = cwd },
	}),
})
if layer_err ~= nil then error(layer_err, 0) end
return layer
