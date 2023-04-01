local s = staminoid.settings

local sprint_start_by_player_name = {}

-- TODO this should perhaps be using status_effects instead of player_monoids directly
function staminoid.set_sprinting(player, can_sprint)
	local player_name = player:get_player_name()
	if can_sprint then
		local now = minetest.get_us_time() / 1e6
		local start = sprint_start_by_player_name[player_name]
		if not start then
			sprint_start_by_player_name[player_name] = now
			start = now
		end
		local sprint_scale = math.tanh((now - start) * staminoid.settings.sprint_acceleration)

		player_monoids.speed:add_change(player, 1 + (sprint_scale * (s.sprint_speed - 1)), "staminoid:sprinting")
		player_monoids.jump:add_change(player, s.sprint_jump, "staminoid:sprinting")
	else
		sprint_start_by_player_name[player_name] = nil
		player_monoids.speed:del_change(player, "staminoid:sprinting")
		player_monoids.jump:del_change(player, "staminoid:sprinting")
	end
end
