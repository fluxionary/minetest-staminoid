local S = staminoid.S
local s = staminoid.settings

local identifier = "staminoid"

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
		-- TODO: https://codeberg.org/Wuzzy/minetest_hudbars/issues/4
		local state = hb.get_hudtable(identifier).hudstate[player:get_player_name()]
		-- local state = hb.get_hudbar_state(player, identifier)
		if not state then
			return
		elseif state.value > stamina_max then
			hb.change_hudbar(player, identifier, stamina_max, stamina_max)
		else
			hb.change_hudbar(player, identifier, nil, stamina_max)
		end
	end,
})
