minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	if not meta:get("staminoid:initialized") then
		local stamina_max = staminoid.stamina_max_monoid:value(player)
		local stamina_regen = staminoid.stamina_regen_monoid:value(player)
		staminoid.set_stamina_max(player, stamina_max)
		staminoid.set_stamina(player, stamina_max)
		staminoid.set_stamina_regen(player, stamina_regen)
		meta:set_int("staminoid:initialized", 1)
	end
end)
