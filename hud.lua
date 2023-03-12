staminoid.registered_huds = {}

function staminoid.register_hud(def)
	table.insert(staminoid.registered_huds, def)
end

staminoid.register_on_stamina_change(function(player, stamina)
	for _, hud_def in ipairs(staminoid.registered_huds) do
		hud_def.on_stamina_change(player, stamina)
	end
end)

staminoid.register_on_stamina_max_change(function(player, stamina_max)
	for _, hud_def in ipairs(staminoid.registered_huds) do
		hud_def.on_stamina_max_change(player, stamina_max)
	end
end)

minetest.register_on_joinplayer(function(player)
	local stamina = staminoid.get_stamina(player)
	local stamina_max = staminoid.get_stamina_max(player)
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
