local f = string.format

local function stamina_key(player)
	return f("staminoid:stamina:%s", player:get_player_name())
end

local function stamina_max_key(player)
	return f("staminoid:stamina_max:%s", player:get_player_name())
end

local function stamina_regen_key(player)
	return f("staminoid:stamina_regen:%s", player:get_player_name())
end

function staminoid.get_stamina(player)
	local meta = player:get_meta()
	local key = stamina_key(player)
	return meta:get_float(key)
end

staminoid.registered_on_stamina_changes = {}
function staminoid.register_on_stamina_change(callback)
	table.insert(staminoid.registered_on_stamina_changes, callback)
end

function staminoid.set_stamina(player, stamina, reason)
	stamina = math.max(0, math.min(stamina, staminoid.get_stamina_max(player)))
	local key = stamina_key(player)
	local meta = player:get_meta()
	local previous_stamina = meta:get_float(key)
	if stamina ~= previous_stamina then
		meta:set_float(key, stamina)
		for _, callback in ipairs(staminoid.registered_on_stamina_changes) do
			callback(player, stamina, previous_stamina, reason)
		end
	end
	return stamina
end

staminoid.last_exhaust_timestamp_by_player_name = {}

function staminoid.exhaust(player, amount, reason)
	if amount > 0 then
		staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] = minetest.get_us_time()
	end
	return staminoid.set_stamina(player, staminoid.get_stamina(player) - amount, reason)
end

function staminoid.get_last_exhaust_timestamp(player)
	return staminoid.last_exhaust_timestamp_by_player_name[player:get_player_name()] or 0
end

function staminoid.regen_stamina(player)
	return staminoid.set_stamina(player, staminoid.get_stamina(player) + staminoid.get_stamina_regen(player), "regen")
end

staminoid.registered_on_stamina_max_changes = {}
function staminoid.register_on_stamina_max_change(callback)
	table.insert(staminoid.registered_on_stamina_max_changes, callback)
end

function staminoid.get_stamina_max(player)
	local meta = player:get_meta()
	local key = stamina_max_key(player)
	return meta:get_float(key)
end

function staminoid.set_stamina_max(player, stamina_max)
	stamina_max = math.max(0, stamina_max)
	local meta = player:get_meta()
	local key = stamina_max_key(player)
	local previous_stamina_max = meta:get_float(key)
	if stamina_max ~= previous_stamina_max then
		if staminoid.get_stamina(player) > stamina_max then
			staminoid.set_stamina(player, stamina_max)
		end
		meta:set_float(key, stamina_max)
		for _, callback in ipairs(staminoid.registered_on_stamina_max_changes) do
			callback(player, stamina_max, previous_stamina_max)
		end
	end
	return stamina_max
end

function staminoid.get_stamina_regen(player)
	local meta = player:get_meta()
	local key = stamina_regen_key(player)
	return meta:get_float(key)
end

function staminoid.set_stamina_regen(player, stamina_regen)
	stamina_regen = math.max(0, stamina_regen)
	local meta = player:get_meta()
	local key = stamina_regen_key(player)
	meta:set_float(key, stamina_regen)
	return stamina_regen
end
