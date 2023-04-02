staminoid.util = {}

function staminoid.util.is_climbing(player)
	local pos = vector.round(player:get_pos())
	local node = minetest.get_node(pos)
	local def = ItemStack(node.name):get_definition()
	return def.climbable
end
