function onPlayerCredentials(playerid)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") credentials arrived")
	spawnPlayer(playerid, 1200, 300, 15)
end
registerEvent("onPlayerCredentials", "onPlayerCredential")

function onPlayerConnected(playerid)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") connecting")
end
registerEvent("onPlayerConnected", "onPlayerConnected")

function onPlayerLeft(playerid, reason)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") left, reason: " .. reason)
end
registerEvent("onPlayerLeft", "onPlayerLeft")

function onPlayerAfk(playerid, status)
	local str
	if(status) then
		str = "is now"
	else
		str = "is no longer"
	end
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") " .. str .. " afk")
end
registerEvent("onPlayerAfk", "onPlayerAfk")

function onPlayerEnteredVehicle(playerid, vehicleId, seatId)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") entered vehicle " .. vehicleId .. " on seat " .. seatId)
end
registerEvent("onPlayerEnteredVehicle", "onPlayerEnteredVehicle")

function onPlayerExitVehicle(playerid, vehicleId, seatId)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") exited vehicle " .. vehicleId .. " on seat " .. seatId)
end
registerEvent("onPlayerExitVehicle", "onPlayerExitVehicle")

function onPlayerRequestVehicleEntry(playerid, vehicleId, seatId, carjack)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") entering vehicle " .. vehicleId .. " on seat " .. seatId)
end
registerEvent("onPlayerRequestVehicleEntry", "onPlayerRequestVehicleEntry")

function onPlayerSwitchWeapons(playerid, weapon, ammo)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") using weapon " .. weapon .. ", " .. ammo)
end
registerEvent("onPlayerSwitchWeapons", "onPlayerSwitchWeapons")

function onPlayerWeaponsArrived(playerid)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") weapons arrived")
	local gunTable = getPlayerWeapons(playerid)
	if(gunTable == nil) then return end
	for weapon, ammo in pairs(gunTable) do
		print(weapon .. ", " .. ammo)
	end
end
registerEvent("onPlayerWeaponsArrived", "onPlayerWeaponsArrived")

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function onPlayerChat(playerid, text)
	if(string.sub(text, 1, 1) == "/") then
		local params = split(text, " ")
		
		if(params[1] == "/swat") then
			setPlayerSkin(playerid, 190)
			givePlayerWeapon(playerid, 15, 600)
			setPlayerColor(playerid, 0x00FF00FF)	
		elseif(params[1] == "/v") then
			if(#params ~= 2) then 
				sendPlayerMsg(playerid, "Usage: /v [vehicle name]", 0xFFFFFFFF)
				return 
			end

			local modelId = getVehicleModelId(string.upper(params[2]))
			if(modelId == -1) then 
				sendPlayerMsg(playerid, "Invalid vehicle name", 0xFFFFFFFF)
				return
			end
			
			local x, y, z = getPlayerPos(playerid)
			local rColor = math.random(0, 170)
			
			local carId = createVehicle(modelId, x, y, z, 0.0, 0.0, 0.0, rColor, rColor, rColor, rColor, getPlayerWorld(playerid))
			sendPlayerMsg(playerid, params[2] .. " spawned with id " .. carId .. " with color " .. rColor, 0xFFFFFFFF)	
		else
			sendPlayerMsg(playerid, "Unknown command", 0xFFFFFFFF)
		end
	else
		sendMsgToAll(getPlayerName(playerid) .. "(" .. playerid .. "): " .. text, 0xFFFFFFFF)
	end
end
registerEvent("onPlayerChat", "onPlayerChat")

function onPlayerSpawn(playerid)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") spawned")
end
registerEvent("onPlayerSpawn", "onPlayerSpawn")

function onPlayerDeath(playerid, agentType, agentId)
	print("Player " .. getPlayerName(playerid) .. "(" .. playerid .. ") died")
	if(agentType == 1) then
		if(isPlayerOnline(agentId)) then
			print(getPlayerName(agentId) .. " killed " .. getPlayerName(playerid))
		else
			--The player is no longer online
		end
	end
end
registerEvent("onPlayerDeath", "onPlayerDeath")

function onPlayerHpChange(playerid, agentType, agentId)
	--Params are the same as "onPlayerDeath" and so is its usage
end
registerEvent("onPlayerHpChange", "onPlayerHpChange")

function onPlayerArmorChange(playerid, newArmour)
	if(newArmour > getPlayerArmor(playerid)) then
		--Is the player using hax? Use your game logic to decide
	end
end
registerEvent("onPlayerArmorChange", "onPlayerArmorChange")


function onPlayerEnterCheckPoint(playerid, checkpointId)
end
registerEvent("onPlayerEnterCheckPoint", "onPlayerEnterCheckPoint")

function onPlayerExitCheckPoint(player, checkpointId)
end
registerEvent("onPlayerExitCheckPoint", "onPlayerExitCheckPoint")

