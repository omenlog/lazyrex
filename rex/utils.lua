local M = {}

function M.get_floating_layer_id(block_id, label)
	local view, view_err = rex.session.view({})
	if view_err ~= nil then return nil, view_err end

	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			if layer.kind == "floating" then
				for _, block in ipairs(layer.blocks or {}) do
					if block.block_id == block_id and block.label == label then return layer.layer_id end
				end
			end
		end
	end
end

return M
