local default_stamina_max = staminoid.settings.default_stamina_max
local default_stamina_regen = staminoid.settings.default_stamina_regen

staminoid.stamina_max_monoid = persistent_monoids.make_monoid("stamina_max", {
	identity = default_stamina_max,
	fold = function(t)
		local total = default_stamina_max
		for _, stamina in pairs(t) do
			total = total + stamina
		end
		return total
	end,
	apply = function(stamina_max, player)
		staminoid.set_max_stamina(player, stamina_max)
	end,
})

staminoid.stamina_regen_monoid = persistent_monoids.make_monoid("stamina_regen", {
	identity = default_stamina_regen,
	fold = function(t)
		local total = default_stamina_regen
		for _, stamina_regen in pairs(t) do
			total = total + stamina_regen
		end
		return total
	end,
	apply = function(stamina_regen, player)
		staminoid.set_stamina_regen(player, stamina_regen)
	end,
})
