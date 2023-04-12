local s = staminoid.settings

staminoid.stamina_regen_effect = status_effects.register_effect("stamina_regen_effect", {
	fold = function(self, t)
		local value = s.default_stamina_regen
		local multiplier = 1
		for k, v in pairs(t) do
			if type(v) == "number" then
				value = value + v
			elseif type(v) == "table" and v.multiplier then
				multiplier = multiplier * v.multiplier
			end
		end
		return value * multiplier
	end,
	step_every = 0.09,
	on_step = function(self, player, value, dtime, now)
		local controls = player:get_player_control()
		local doing_something = controls.aux1
			or (controls.sneak and (controls.up or controls.down or controls.left or controls.right))
			or controls.dig
			or controls.place
		local last_exhaust_timestamp = staminoid.get_last_exhaust_timestamp(player)
		if not doing_something and last_exhaust_timestamp + (s.stamina_regen_cooldown * 1e6) <= now then
			local stamina = staminoid.stamina_attribute:get(player) + (value * dtime / s.stamina_regen_tick)
			return staminoid.stamina_attribute:set(player, stamina, "regen")
		end
	end,
})
