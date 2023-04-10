local S = staminoid.S
local s = staminoid.settings

local sprint_start_by_player_name = {}

staminoid.sprinting_effect = status_effects.register_effect("sprinting", {
	description = S("sprinting"),
	fold = function(self, values_by_key)
		return status_effects.fold.not_blocked(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		local player_name = player:get_player_name()
		if value == true then
			local now = minetest.get_us_time() / 1e6
			local start = sprint_start_by_player_name[player_name]
			if not start then
				sprint_start_by_player_name[player_name] = now
				start = now
			end
			local sprint_scale = math.tanh((now - start) * staminoid.settings.sprint_acceleration)

			player_monoids.speed:add_change(player, 1 + (sprint_scale * (s.sprint_speed - 1)), "staminoid:sprinting")
			player_monoids.jump:add_change(player, s.sprint_jump, "staminoid:sprinting")
		elseif old_value == true and value ~= true then
			sprint_start_by_player_name[player_name] = nil
			player_monoids.speed:del_change(player, "staminoid:sprinting")
			player_monoids.jump:del_change(player, "staminoid:sprinting")
		end
	end,
})
