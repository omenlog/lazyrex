local M = {}

local function find_layer(predicate)
	local view, view_err = rex.session.view({})
	if view_err ~= nil then return nil, view_err end

	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			for _, block in ipairs(layer.blocks or {}) do
				if predicate(block) then return layer end
			end
		end
	end
end

function M.get_layer(block_id, label)
	return find_layer(function(block)
		return block.block_id == block_id and block.label == label
	end)
end

function M.get_block_id_by_label(label)
	local layer, layer_err = find_layer(function(block)
		return block.label == label
	end)
	if layer_err ~= nil then return nil, layer_err end

	for _, block in ipairs(layer and layer.blocks or {}) do
		if block.label == label then return block.block_id end
	end
end

return M
