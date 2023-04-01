local f = string.format
local S = staminoid.S
local s = staminoid.settings

function staminoid.on_craft(itemstack, player, old_craft_grid, craft_inv)
	local remaining_stamina = staminoid.exhaust(player, s.exhaust_craft, "craft")
	if remaining_stamina == 0 and s.craft_bungling_enabled and math.random() < s.craft_bungling_chance then
		local player_name = player:get_player_name()
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
	end
end

minetest.register_on_craft(function(...)
	return staminoid.on_craft(...)
end)

minetest.register_on_placenode(function(pos, oldnode, player, ext)
	staminoid.exhaust(player, s.exhaust_place, "place")
end)

minetest.register_on_dignode(function(pos, oldnode, player, ext)
	staminoid.exhaust(player, s.exhaust_dig, "dig")
end)

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	staminoid.exhaust(puncher, s.exhaust_punch, "punch")
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
