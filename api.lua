staminoid.registered_on_exhaust_players = {}
staminoid.last_exhaust_timestamp_by_player_name = {} -- don't persist this across reboots7

function staminoid.register_on_exhaust_player(callback)
	table.insert(staminoid.registered_on_exhaust_players, callback)
end

function staminoid.exhaust(player, amount, reason)
	for _, callback in ipairs(staminoid.registered_on_exhaust_players) do
		amount = callback(player, amount, reason) or amount
	end

	local previous_stamina = staminoid.stamina_attribute:get(player)
	if amount == 0 then
		return previous_stamina
	end

	staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] = minetest.get_us_time()

	return staminoid.stamina_attribute:set(player, previous_stamina - amount, reason or "exhaust")
end

function staminoid.get_last_exhaust_timestamp(player)
	return staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] or 0
end
