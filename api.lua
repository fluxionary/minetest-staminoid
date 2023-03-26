staminoid.last_exhaust_timestamp_by_player_name = {}

function staminoid.exhaust(player, amount, reason)
	local previous_stamina = staminoid.stamina_attribute:get(player)
	if amount == 0 then
		return previous_stamina
	end
	if amount > 0 then
		staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] = minetest.get_us_time()
	end
	return staminoid.stamina_attribute:set(player, previous_stamina - amount, reason or "exhaust")
end

function staminoid.get_last_exhaust_timestamp(player)
	return staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] or 0
end
