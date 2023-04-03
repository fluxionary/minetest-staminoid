local s = staminoid.settings

local is_climbing = staminoid.util.is_climbing

local movement_speed_walk = tonumber(minetest.settings:get("movement_speed_walk")) or 4.0
local movement_speed_jump = tonumber(minetest.settings:get("movement_speed_jump")) or 6.5
local movement_gravity = tonumber(minetest.settings:get("movement_gravity")) or 9.81

local last_y_velocity_by_player_name = {}
local last_jump_by_player_name = {}
local last_exhaust_climb_by_player_name = {}

local function get_jump_duration(player)
	local jump_multiplier = player_monoids.jump:value(player)
	local gravity_multiplier = player_monoids.gravity:value(player)
	-- us
	return 1e6 * 2 * movement_speed_jump * jump_multiplier / (movement_gravity * gravity_multiplier)
end

local function exhaust_climbing(player, now)
	if minetest.check_player_privs(player, { fly = true }) then
		return
	end
	local player_name = player:get_player_name()
	local controls = player:get_player_control()
	local jump_duration = get_jump_duration(player)
	local last_exhaust_climb = last_exhaust_climb_by_player_name[player_name] or 0
	if controls.jump and now - last_exhaust_climb >= (jump_duration / 2) then
		staminoid.exhaust(player, s.exhaust_jump, "climb")
		last_exhaust_climb_by_player_name[player_name] = now
	end
end

local function exhaust_jumping(player, now)
	if minetest.check_player_privs(player, { fly = true }) then
		return
	end
	local player_name = player:get_player_name()
	local controls = player:get_player_control()

	local cur_y_velocity = player:get_velocity().y
	local prev_y_velocity = last_y_velocity_by_player_name[player_name] or 0
	local last_jump = last_jump_by_player_name[player_name] or 0
	local jump_duration = get_jump_duration(player)
	local is_jumping = controls.jump or (cur_y_velocity > 0 and prev_y_velocity <= 0)

	if is_jumping and now - last_jump >= jump_duration then
		staminoid.exhaust(player, s.exhaust_jump, "jump")
		last_jump_by_player_name[player_name] = now
	elseif futil.is_on_ground(player) then
		last_jump_by_player_name[player_name] = nil
	end

	last_y_velocity_by_player_name[player_name] = cur_y_velocity
end

local function exhaust_movement(player)
	local controls = player:get_player_control()
	local has_fast = minetest.check_player_privs(player, { fast = true })

	local horizontal_speed = futil.get_horizontal_speed(player)

	local is_moving = controls.up or controls.down or controls.left or controls.right
	local is_sprinting = staminoid.sprinting_effect:value(player)

	local movement_exhaust
	local exhaust_at = s.exhaust_move_min * movement_speed_walk
	if is_moving and is_sprinting and horizontal_speed > exhaust_at and not has_fast then
		movement_exhaust = s.exhaust_move_scale * ((horizontal_speed / exhaust_at) ^ s.exhaust_move_gamma)
		staminoid.exhaust(player, movement_exhaust, "movement")
	else
		movement_exhaust = 0
	end

	return movement_exhaust
end

local function set_sprinting(player, current_stamina, movement_exhaust)
	local controls = player:get_player_control()
	local has_fast = minetest.check_player_privs(player, { fast = true })
	local can_sprint = (
		controls.aux1
		and not player:get_attach()
		and (s.sprint_with_fast or not has_fast)
		and current_stamina > movement_exhaust
		and futil.get_horizontal_speed(player) >= (movement_speed_walk / 2)
	)

	if can_sprint then
		staminoid.sprinting_effect:add(player, "staminoid", true)
	else
		staminoid.sprinting_effect:clear(player, "staminoid")
	end
end

local function set_exhaustion(player, current_stamina)
	if current_stamina < 1 then
		std_effects.exhaustion:add(player, "staminoid", 2)
	elseif current_stamina <= s.exhaustion_stamina_level then
		std_effects.exhaustion:add(player, "staminoid", 1)
	else
		std_effects.exhaustion:clear(player, "staminoid")
	end
end

local function update(player, now)
	if is_climbing(player) then
		exhaust_climbing(player, now)
	else
		exhaust_jumping(player, now)
	end

	local movement_exhaust = exhaust_movement(player)

	-- next, update behavior based on current stamina values
	local current_stamina = staminoid.stamina_attribute:get(player)

	-- update sprinting effect
	if s.sprint_enabled then
		set_sprinting(player, current_stamina, movement_exhaust)
	end

	-- update exhaustion effect
	set_exhaustion(player, current_stamina)
end

local last_timestamp
futil.register_globalstep({
	period = s.stamina_update_tick,
	catchup = "single",
	func = function()
		local now = minetest.get_us_time()
		if last_timestamp then
			local players = minetest.get_connected_players()
			for i = 1, #players do
				update(players[i], now)
			end
		end
		last_timestamp = now
	end,
})
