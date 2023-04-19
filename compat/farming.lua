local s = staminoid.settings

local old_place_seed = farming.place_seed

function farming.place_seed(itemstack, placer, pointed_thing, plantname)
	local rv = old_place_seed(itemstack, placer, pointed_thing, plantname)
	if minetest.is_player(placer) then
		staminoid.exhaust(placer, s.exhaust_place, "place")
	end
	return rv
end
