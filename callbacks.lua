local f = string.format
local S = staminoid.S
local s = staminoid.settings

function staminoid.on_craft(itemstack, player, old_craft_grid, craft_inv)
	local remaining_stamina = staminoid.exhaust(player, s.exhaust_craft, "craft")
	if remaining_stamina == 0 then
		local player_name = player:get_player_name()
		if s.exhausted_craft_behavior == "bungle" and math.random() < s.craft_bungling_chance then
			staminoid.log(
				"action",
				f(
					"%s bungles crafting %q from %s",
					player_name,
					itemstack:to_string(),
					dump(old_craft_grid):gsub("%s+", "%s")
				)
			)
			minetest.chat_send_player(player_name, S("you are too tired to craft, and bungle the recipe"))
			return ItemStack()
		elseif s.exhausted_craft_behavior == "fumble" then
			local pos = vector.add(player:get_pos(), futil.random_unit_vector())
			local obj = minetest.add_item(pos, itemstack)
			if obj then
				obj:add_velocity(2 * futil.random_unit_vector())
				return ItemStack()
			end
		elseif s.exhausted_craft_behavior == "fumble_ingredients" then
			for _, item in ipairs(old_craft_grid) do
				local pos = vector.add(player:get_pos(), futil.random_unit_vector())
				local obj = minetest.add_item(pos, item)
				if obj then
					obj:add_velocity(2 * futil.random_unit_vector())
				end
			end
			craft_inv:set_list("craft", {})
			return ItemStack()
		end
	end
end

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not minetest.is_player(player) then
		return
	end
	return staminoid.on_craft(itemstack, player, old_craft_grid, craft_inv)
end)

minetest.register_on_placenode(function(pos, oldnode, player)
	if not minetest.is_player(player) then
		return
	end
	staminoid.exhaust(player, s.exhaust_place, "place")
end)

minetest.register_on_dignode(function(pos, oldnode, player)
	if not minetest.is_player(player) then
		return
	end
	local node_groups = ItemStack(oldnode.name):get_definition().groups or {}
	if (node_groups.dig_immediate or 0) > 0 then
		return
	end
	local wielded_item = player:get_wielded_item()
	local dig_params =
		minetest.get_dig_params(node_groups, wielded_item:get_tool_capabilities(), wielded_item:get_wear())
	if not dig_params.diggable then
		local inv = player:get_inventory()
		local hand = inv:get_stack("hand", 1)
		dig_params = minetest.get_dig_params(node_groups, hand:get_tool_capabilities())
	end
	if dig_params.diggable then
		staminoid.exhaust(player, s.exhaust_dig * dig_params.time, "dig")
	else
		staminoid.exhaust(player, s.exhaust_dig, "dig")
	end
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if minetest.is_player(player) then
		staminoid.exhaust(player, s.exhaust_punch, "punch")
	end
	if minetest.is_player(hitter) then
		staminoid.exhaust(hitter, s.exhaust_punch, "punch")
	end
end)

minetest.register_on_respawnplayer(function(player)
	staminoid.stamina_attribute:set(player, 0)
end)
