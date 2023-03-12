local s = staminoid.settings

local elapsed = 0
function staminoid.regen_tick(dtime)
	elapsed = elapsed + dtime
	if elapsed < s.stamina_regen_tick then
		return
	end
	elapsed = elapsed - s.stamina_regen_tick -- allow catchup during lag
	local now = minetest.get_us_time()
	for _, player in ipairs(minetest.get_connected_players()) do
		local last_exhaust_timestamp = staminoid.get_last_exhaust_timestamp(player)
		if last_exhaust_timestamp + (s.stamina_regen_cooldown * 1e6) <= now then
			staminoid.regen_stamina(player)
		end
	end
end

minetest.register_globalstep(function(dtime)
	return staminoid.regen_tick(dtime)
end)
