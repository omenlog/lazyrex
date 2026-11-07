local args = rex.args

if type(args.label) ~= "string" or args.label == "" then
	error("Missing LazyGit label", 0)
end
if type(args.rex_dir) ~= "string" or args.rex_dir == "" then
	error("Missing lazyrex Rex script directory", 0)
end

package.path = args.rex_dir .. "/?.lua;" .. package.path
local utils = require("utils")

local layer_id, layer_err = utils.get_floating_layer_id_by_label(args.label)
if layer_err ~= nil then error(layer_err, 0) end
if layer_id == nil then return end

local closed, close_err = rex.session.close_layer({ layer_id = layer_id })
if close_err ~= nil then error(close_err, 0) end
return closed
