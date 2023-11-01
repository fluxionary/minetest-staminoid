for _, mod in ipairs({ "hbsprint", "real_stamina", "stamina" }) do
	if minetest.get_modpath(mod) then
		error("balanced_diet is not compatible w/ " .. mod)
	end
end

futil.check_version({ year = 2023, month = 11, day = 1 }) -- is_player

staminoid = fmod.create()

staminoid.dofile("util")
staminoid.dofile("stamina_attribute")
staminoid.dofile("stamina_regen_effect")
staminoid.dofile("sprinting_effect")
staminoid.dofile("api")

staminoid.dofile("hud")
staminoid.dofile("callbacks")
staminoid.dofile("globalstep")

staminoid.dofile("compat", "init")
