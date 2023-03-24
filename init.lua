if minetest.get_modpath("stamina") then
	error("staminoid is not compatible w/ stamina")
end

futil.check_version({ year = 2023, month = 3, day = 10 })

staminoid = fmod.create()

staminoid.dofile("api")
staminoid.dofile("hud")
staminoid.dofile("internal")

staminoid.dofile("callbacks")
staminoid.dofile("initialize")
staminoid.dofile("update")

staminoid.dofile("compat", "init")
