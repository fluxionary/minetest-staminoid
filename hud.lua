staminoid.registered_huds = {}

function staminoid.register_hud(def)
	table.insert(staminoid.registered_huds, def)
end

staminoid.stamina_attribute:register_on_change(function(self, player, stamina, old_stamina)
	if stamina ~= old_stamina then
		for _, hud_def in ipairs(staminoid.registered_huds) do
			hud_def.on_stamina_change(player, stamina)
		end
	end
end)

staminoid.stamina_attribute:register_on_max_change(function(self, player, stamina_max, old_stamina_max)
	if stamina_max ~= old_stamina_max then
		for _, hud_def in ipairs(staminoid.registered_huds) do
			hud_def.on_stamina_max_change(player, stamina_max)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local stamina = staminoid.stamina_attribute:get(player)
	local stamina_max = staminoid.stamina_attribute:get_max(player)
	for _, hud_def in ipairs(staminoid.registered_huds) do
		hud_def.on_joinplayer(player, stamina, stamina_max)
	end
end)

minetest.register_on_leaveplayer(function(player)
	for _, hud_def in ipairs(staminoid.registered_huds) do
		if hud_def.on_leaveplayer then
			hud_def.on_leaveplayer(player)
		end
	end
end)
