local sum_values = player_attributes.util.sum_values
local s = staminoid.settings

staminoid.stamina_regen_effect = status_effects.register_effect("stamina_regen_effect", {
	fold = function(self, t)
		return sum_values(t, s.default_stamina_regen)
	end,
	step_every = 0.09,
	on_step = function(self, player, value, dtime, now)
		local last_exhaust_timestamp = staminoid.get_last_exhaust_timestamp(player)
		if last_exhaust_timestamp + (s.stamina_regen_cooldown * 1e6) <= now then
			local stamina = staminoid.stamina_attribute:get(player) + (value * dtime / s.stamina_regen_tick)
			return staminoid.stamina_attribute:set(player, stamina, "regen")
		end
	end,
})
