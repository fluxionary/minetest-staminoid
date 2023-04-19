if staminoid.has.exhaustion_effect then
	staminoid.dofile("compat", "exhaustion_effect")
end

if staminoid.has.farming and farming.mod == "redo" then
	staminoid.dofile("compat", "farming")
end

if staminoid.has.hudbars then
	staminoid.dofile("compat", "hudbars")
end
