local s = staminoid.settings

local movement_speed_walk = tonumber(minetest.settings:get("movement_speed_walk")) or 4.0

local last_y_velocity_by_player_name = {}
local is_jumping_by_player_name = {}

futil.register_globalstep({
	period = s.stamina_update_tick,
	catchup = "single",
	func = function()
		local players = minetest.get_connected_players()
		for i = 1, #players do
			local player = players[i]
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
			local exhaust_at = s.exhaust_move_min * movement_speed_walk
			if is_moving and horizontal_speed > exhaust_at and not has_fast then
				movement_exhaust = s.exhaust_move_scale * ((horizontal_speed / exhaust_at) ^ s.exhaust_move_gamma)
				staminoid.exhaust(player, movement_exhaust, "movement")
			else
				movement_exhaust = 0
			end

			-- next, update behavior based on current stamina values
			local current_stamina = staminoid.stamina_attribute:get(player)

			if s.sprint then
				local can_sprint = (
					controls.aux1
					and not player:get_attach()
					and (s.sprint_with_fast or not has_fast)
					and current_stamina > movement_exhaust
				)

				staminoid.set_sprinting(player, can_sprint)
			end

			if current_stamina == 0 then
				std_effects.exhaustion:add(player, "staminoid", 2)
			elseif current_stamina <= s.exhaustion_stamina_level then
				std_effects.exhaustion:add(player, "staminoid", 1)
			else
				std_effects.exhaustion:clear(player, "staminoid")
			end
		end
	end,
})
