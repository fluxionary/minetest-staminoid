local sum_values = player_attributes.util.sum_values

staminoid.stamina_attribute = player_attributes.register_bounded_attribute("stamina", {
	min = 0,
	base = staminoid.settings.default_stamina_max,
	base_max = staminoid.settings.default_stamina_max,
	fold_max = function(self, values)
		return sum_values(values, self.max)
	end,
})
