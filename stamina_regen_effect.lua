local sum_values = player_attributes.util.sum_values
local s = staminoid.settings

staminoid.stamina_regen_effect = status_effects.register_effect("stamina_regen_effect", {
	fold = function(self, t)
		return sum_values(t, s.default_stamina_regen)
	end,
	step_every = s.stamina_regen_tick,
	step_catchup = true,
	on_step = function(self, player, value, dtime, now)
		local last_exhaust_timestamp = staminoid.get_last_exhaust_timestamp(player)
		if last_exhaust_timestamp + (s.stamina_regen_cooldown * 1e6) <= now then
			return staminoid.set_stamina(
				player,
				staminoid.get_stamina(player) + staminoid.get_stamina_regen(player),
				"regen"
			)
		end
	end,
})
