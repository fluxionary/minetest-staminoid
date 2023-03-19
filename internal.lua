local s = staminoid.settings

local sprint_start_by_player_name = {}

function staminoid.set_sprinting(player, can_sprint)
	local player_name = player:get_player_name()
	if can_sprint then
		local now = minetest.get_us_time()
		local start = sprint_start_by_player_name[player_name]
		if not start then
			sprint_start_by_player_name[player_name] = now
			start = now
		end
		local sprint_scale = math.tanh((now - start) / staminoid.settings.sprint_acceleration)

		player_monoids.speed:add_change(player, sprint_scale * s.sprint_speed, "staminoid:sprinting")
		player_monoids.jump:add_change(player, s.sprint_jump, "staminoid:sprinting")
	else
		sprint_start_by_player_name[player_name] = nil
		player_monoids.speed:del_change(player, "staminoid:sprinting")
		player_monoids.jump:del_change(player, "staminoid:sprinting")
	end
end

function staminoid.set_reduced_speed(player, reduce_speed)
	if reduce_speed then
		player_monoids.speed:add_change(player, 1 / s.sprint_speed, "staminoid:reduce_speed")
	else
		player_monoids.speed:del_change(player, "staminoid:reduce_speed")
	end
end

function staminoid.set_reduced_jump(player, reduce_jump)
	if reduce_jump then
		player_monoids.jump:add_change(player, 1 / s.sprint_jump, "staminoid:reduce_jump")
	else
		player_monoids.jump:del_change(player, "staminoid:reduce_jump")
	end
end

function staminoid.set_reduced_dig(player, reduce_dig) end

function staminoid.set_reduced_punch(player, reduce_punch) end
