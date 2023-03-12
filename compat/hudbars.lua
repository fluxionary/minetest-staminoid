local S = staminoid.S
local s = staminoid.settings

local identifier = "staminoid:stamina"

hb.register_hudbar(
	identifier,
	0x000000,
	S("stamina"),
	{ bar = "[combine:2x16^[noalpha^[colorize:#FF0:255" },
	0,
	s.default_stamina_max,
	false
)

staminoid.register_hud({
	on_joinplayer = function(player, stamina, stamina_max)
		hb.init_hudbar(player, identifier, stamina, stamina_max, false)
	end,
	on_stamina_change = function(player, stamina)
		hb.change_hudbar(player, identifier, stamina, nil)
	end,
	on_stamina_max_change = function(player, stamina_max)
		hb.change_hudbar(player, identifier, nil, stamina_max)
	end,
})
