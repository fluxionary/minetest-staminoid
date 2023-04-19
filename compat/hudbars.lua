local f = string.format
local S = staminoid.S
local s = staminoid.settings

local identifier = "staminoid"

local function make_bar(value, max)
	local exhaustion_stamina_level = s.exhaustion_stamina_level
	local percent = math.max(0, (value - exhaustion_stamina_level) / (max - exhaustion_stamina_level))
	local red, green
	if percent > 0.5 then
		red = f("%02x", math.round(510 * (1 - percent)))
		green = "ff"
	else
		red = "ff"
		green = f("%02x", math.round(510 * percent))
	end
	return f("[combine:2x16^[noalpha^[colorize:#%s%s00:255", red, green)
end

--[[
hb.register_hudbar(
	identifier,
	text_color,
	label,
	{
		bar = ...,
		icon = ...,
		bgicon = ...,
	},
	default_start_value,
	default_start_max,
	default_start_hidden,
	format_string,
	format_string_config
)
]]
hb.register_hudbar(
	identifier,
	0x000000,
	S("stamina"),
	{ bar = make_bar(s.default_stamina_max, s.default_stamina_max) },
	0,
	s.default_stamina_max,
	false
)

--[[
hb.change_hudbar(player, identifier, new_value, new_max_value, new_icon, new_bgicon, new_bar, new_label, new_text_color)
]]

staminoid.register_hud({
	on_joinplayer = function(player, stamina, stamina_max)
		hb.init_hudbar(player, identifier, stamina, stamina_max, false)
	end,
	on_stamina_change = function(player, stamina)
		-- TODO: https://codeberg.org/Wuzzy/minetest_hudbars/issues/4
		local state = hb.get_hudtable(identifier).hudstate[player:get_player_name()]
		-- local state = hb.get_hudbar_state(player, identifier)
		if not state then
			return
		end
		local stamina_max = state.max
		stamina = math.min(stamina, stamina_max)
		local bar = make_bar(stamina, stamina_max)
		hb.change_hudbar(player, identifier, stamina, stamina_max, nil, nil, bar)
	end,
	on_stamina_max_change = function(player, stamina_max)
		-- TODO: https://codeberg.org/Wuzzy/minetest_hudbars/issues/4
		local state = hb.get_hudtable(identifier).hudstate[player:get_player_name()]
		-- local state = hb.get_hudbar_state(player, identifier)
		if not state then
			return
		end
		local stamina = math.min(state.value, stamina_max)
		local bar = make_bar(stamina, stamina_max)
		hb.change_hudbar(player, identifier, stamina, stamina_max, nil, nil, bar)
	end,
})
