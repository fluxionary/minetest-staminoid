function staminoid.get_stamina(player)
	return staminoid.stamina_attribute:get(player)
end

function staminoid.set_stamina(player, stamina, reason)
	return staminoid.stamina_attribute:set(player, stamina, reason)
end

staminoid.last_exhaust_timestamp_by_player_name = {}

function staminoid.exhaust(player, amount, reason)
	if amount > 0 then
		staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] = minetest.get_us_time()
	end
	return staminoid.set_stamina(player, staminoid.get_stamina(player) - amount, reason or "exhaust")
end

function staminoid.get_last_exhaust_timestamp(player)
	return staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] or 0
end

function staminoid.get_stamina_max(player)
	error("TODO") -- TODO
end

function staminoid.set_stamina_max(player, stamina_max)
	error("TODO") -- TODO
end

function staminoid.get_stamina_regen(player)
	error("TODO") -- TODO
end

function staminoid.set_stamina_regen(player, stamina_regen)
	error("TODO") -- TODO
end
