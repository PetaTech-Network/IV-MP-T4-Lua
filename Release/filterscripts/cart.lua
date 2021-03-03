local spawnedCars = {}
local carStat = {}
local timerId = -1

function carSpawningUnload()
	print("Unloading cart")
	removeCommand("/v")
	unregisterEvent("carSpawningPlayerLeft")
	deleteTimer(timerId)
	
	for spawnerId, carId in pairs(spawnedCars) do
		if(isVehicle(carId)) then
			deleteVehicle(carId)
		end
	end
end
registerScriptUnload("cart", carSpawningUnload) --Adds an unload point

local function deletePlayerVehicles(playerid)
	if(spawnedCars[playerid] ~= nil) then
		local carId = spawnedCars[playerid]
		if(isVehicle(carId)) then
			deleteVehicle(carId)
		end
	end 
end

local sMem = {
	players, vehicleId, velocityX, velocityY, velocityZ, rotX, rotY, rotZ, speed, lateralSpeed,
	driftSin, drifCos, drifEnd, str
}

function speedometer()
	sMem.players = getPlayers()
	for i, id in ipairs(sMem.players) do
		sMem.vehicleId = isPlayerInAnyVehicle(id)
		if(sMem.vehicleId ~= 0 and isVehicle(sMem.vehicleId) and carStat[sMem.vehicleId] ~= nil ) then
		
			sMem.velocityX, sMem.velocityY, sMem.velocityZ = getVehicleVelocity(sMem.vehicleId)
			sMem.speed = math.sqrt(sMem.velocityX^2 + sMem.velocityY^2 + sMem.velocityZ^2);
			
			if(sMem.speed < 1) then goto continue end	
			--meter per second (1000/timerPulse = 0.15)
			carStat[sMem.vehicleId].tireHp = carStat[sMem.vehicleId].tireHp - sMem.speed * 0.15 * 0.01
			carStat[sMem.vehicleId].tireMileage = carStat[sMem.vehicleId].tireMileage + sMem.speed * 0.15
			
				sMem.str = "~b~Speed:~w~ " .. math.ceil(sMem.speed * 3.7) .. " kmh~n~Mileage: " ..
					(carStat[sMem.vehicleId].tireMileage * 0.00015)
			
			if(sMem.speed > 8) then
				sMem.rotX, sMem.rotY, sMem.rotZ = getVehicleRotation(sMem.vehicleId)
				sMem.driftSin, sMem.driftCos = -math.sin(math.rad(sMem.rotZ)), math.cos(math.rad(sMem.rotZ))
				
				sMem.lateralSpeed = math.sqrt(sMem.velocityX^2 + sMem.velocityY^2)
				if(sMem.lateralSpeed < 1) then goto continue end --Division by 0 protection
				
				sMem.drifEnd = (sMem.driftSin*sMem.velocityX + sMem.driftCos*sMem.velocityY) / sMem.lateralSpeed					
				--if drifEnd < 0.966 and drifEnd > 0 then
					sMem.str = sMem.str .. "~n~Tire: " .. carStat[sMem.vehicleId].tireHp--math.deg(math.acos(sMem.drifEnd)) *0.5
				--end
				
			end	

			drawInfoText(id, sMem.str, 600)
			::continue::
		end
	end
end
timerId = setTimer("speedometer", 100, 0)

addCommand("/v",
	function(playerid, param)
		if(param == nil) then
			sendPlayerMsg(playerid, "Usage: /v [vehicle name]" , 0xFFFF0000)
			do return end
		end
		param[1] = param[1]:upper()
		local modelId = getVehicleModelId(param[1])
		if(modelId == -1) then
			sendPlayerMsg(playerid, "'" .. param[1] .. "' is an invalid vehicle name", 0xFFFF0000)
			do return end
		end
		local x, y, z = getPlayerPos(playerid)
		local rColor = math.random(0, 170)
		deletePlayerVehicles(playerid)
		local carId = createVehicle(modelId, x, y, z, 0.0, 0.0, 0.0, rColor, rColor, rColor, rColor, getPlayerWorld(playerid))
		spawnedCars[playerid] = carId
		carStat[carId] = {tireMaxHp = 1000, tireHp = 1000, tireMileage = 0}
		--setVehicleHood(carId, true)
		sendPlayerMsg(playerid, param[1] .. " spawned with id " .. carId .. " with color " .. rColor, 0xFFFFFFFF)
	end
, "s")


function carSpawningPlayerLeft(playerid, reason)
	if(spawnedCars[playerid] ~= nil and isVehicle(spawnedCars[playerid])) then
		deleteVehicle(spawnedCars[playerid])
		spawnedCars[playerid] = nil
	end
end
registerEvent("carSpawningPlayerLeft", "onPlayerLeft")