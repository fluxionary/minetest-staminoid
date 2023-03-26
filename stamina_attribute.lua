local s = staminoid.settings

staminoid.stamina_attribute = player_attributes.register_bounded_attribute("stamina", {
	min = 0,
	base = s.default_stamina_max,
	base_max = s.default_stamina_max,
})
