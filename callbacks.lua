local f = string.format
local S = staminoid.S
local s = staminoid.settings

function staminoid.on_craft(itemstack, player, old_craft_grid, craft_inv)
	local remaining_stamina = staminoid.exhaust(player, s.exhaust_craft, "craft")
	if remaining_stamina == 0 then
		-- TODO create a "chance" that this will happen, and possibly disable it by default
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
