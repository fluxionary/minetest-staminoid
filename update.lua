local s = staminoid.settings

local last_y_velocity_by_player_name = {}
local is_jumping_by_player_name = {}

local elapsed = 0
function staminoid.update_tick(dtime)
	elapsed = elapsed + dtime
	if elapsed < s.stamina_update_tick then
		return
	end
	elapsed = elapsed - s.stamina_update_tick

	for _, player in ipairs(minetest.get_connected_players()) do
		-- first, exhaust the player for actions we can see via controls
		local player_name = player:get_player_name()
		local controls = player:get_player_control()
		local cur_vel = player:get_velocity().y
		local prev_vel = last_y_velocity_by_player_name[player_name] or 0
		if controls.jump and not is_jumping_by_player_name[player_name] then
			staminoid.exhaust(player, s.exhaust_jump, "jump")
			is_jumping_by_player_name[player_name] = true
		elseif cur_vel > 0 and prev_vel <= 0 then
			is_jumping_by_player_name[player_name] = false
		end
		if is_jumping_by_player_name[player_name] and futil.is_on_ground(player) then
			is_jumping_by_player_name[player_name] = false
		end
		last_y_velocity_by_player_name[player_name] = cur_vel

		local has_fast = minetest.check_player_privs(player, { fast = true })
		local horizontal_speed = futil.get_horizontal_speed(player)
		local is_moving = controls.up or controls.down or controls.left or controls.right

		local movement_exhaust
		if is_moving and horizontal_speed > s.exhaust_move_min and not has_fast then
			movement_exhaust = s.exhaust_move_scale * ((horizontal_speed - s.exhaust_move_min) ^ s.exhaust_move_gamma)
			staminoid.exhaust(player, movement_exhaust, "movement")
		else
			movement_exhaust = 0
		end

		-- next, update behavior based on current stamina values
		local current_stamina = staminoid.get_stamina(player)

		if s.sprint then
			local can_sprint = (
				controls.aux1
				and not player:get_attach()
				and (s.sprint_with_fast or not has_fast)
				and current_stamina > movement_exhaust
			)

			staminoid.set_sprinting(player, can_sprint)
		end

		if not has_fast then
			staminoid.set_reduced_speed(player, current_stamina <= movement_exhaust)
			staminoid.set_reduced_jump(player, current_stamina <= s.exhaust_jump)
		end
		staminoid.set_reduced_dig(player, current_stamina <= s.exhaust_dig)
		staminoid.set_reduced_punch(player, current_stamina <= s.exhaust_punch)
	end
end

minetest.register_globalstep(function(dtime)
	return staminoid.update_tick(dtime)
end)
