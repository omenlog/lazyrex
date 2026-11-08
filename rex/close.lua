local args = rex.args

if type(args.label) ~= "string" or args.label == "" then
	error("Missing LazyGit label", 0)
end
if type(args.rex_dir) ~= "string" or args.rex_dir == "" then
	error("Missing lazyrex Rex script directory", 0)
end

package.path = args.rex_dir .. "/?.lua;" .. package.path
local utils = require("utils")

local block_id, block_err = utils.get_block_id_by_label(args.label)
if block_err ~= nil then error(block_err, 0) end
if block_id == nil then return end

local closed, close_err = rex.call("block.close", {
	session_id = rex.session_id,
	block_id = block_id,
})
if close_err ~= nil then error(close_err, 0) end
return closed
