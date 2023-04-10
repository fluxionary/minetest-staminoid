local s = staminoid.settings

staminoid.register_on_stamina_tick(function(player, current_stamina, now)
	if current_stamina < 1 then
		exhaustion_effect.effect:add(player, "staminoid", 2)
	elseif current_stamina <= s.exhaustion_stamina_level then
		exhaustion_effect.effect:add(player, "staminoid", 1)
	else
		exhaustion_effect.effect:clear(player, "staminoid")
	end
end)
