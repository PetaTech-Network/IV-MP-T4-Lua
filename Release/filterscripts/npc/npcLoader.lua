local lNpcs = {}

function npcLoaderUnload()
	removeCommand("/vnpc")
	removeCommand("/fnpc")
	
	for i, o in pairs(lNpcs) do
		if(o ~= -1) then 
			deleteVehicle(o)
		end
		npcDelete(i)
	end
end
registerScriptUnload("npc/npcLoader", npcLoaderUnload) --Adds an unload point

addCommand("/vnpc",
	function(playerid, text)
		if(text == nil) then
			sendPlayerMsg(playerid, "Usage: /vnpc [vehicle model] [file name]", 0xFFFF0000)
			do return end
		end
		
		text[1] = text[1]:upper()
		local modelId = getVehicleModelId(text[1])
		if(modelId == -1) then
			sendPlayerMsg(playerid, "'" .. text[1] .. "' is an invalid vehicle name", 0xFFFF0000)
			do return end
		end
		
		local x, y, z = getPlayerPos(playerid)
		local rColor = math.random(0, 170)

		local carId = createVehicle(modelId, x, y, z, 0.0, 0.0, 0.0, rColor, rColor, rColor, rColor, getPlayerWorld(playerid))
		local npc = npcCreate(text[2], 1, x, y, z, carId, text[2], getPlayerWorld(playerid), 90.0)
		setEntityStreamDistance(4, npc, 40.0)
		
		lNpcs[npc] = carId
	
		sendPlayerMsg(playerid, text[2] .. " started", 0xFFFF0000)
	end
, "ss")

addCommand("/fnpc",
	function(playerid, text)
		if(text == nil) then
			sendPlayerMsg(playerid, "Usage: /fnpc [file name]", 0xFFFF0000)
			do return end
		end
		
		local x, y, z = getPlayerPos(playerid)
		local npc = npcCreate(text[1], 1, x, y, z, -1, text[1], getPlayerWorld(playerid), 90.0)
		
		lNpcs[npc] = -1
		sendPlayerMsg(playerid, text[1] .. " started", 0xFFFF0000)
	end
, "s")


local cam = {
	spos = {x = 0, y = 0, z = 0.0},
	epos = {x = 0, y = 0, z = 0.0},
	--posError = {x = 0, y = 0, z = 0.0}
	stime = 0,
	polTime = 0,
	calpha = 0.0,
	timer = 0
}

local function clamp(minn, a, maxx)
	if(a < minn) then
			return minn

	elseif(a > maxx) then
			return maxx
	end
	return a
end

local function lerp(x, xx, progress)
	return (1-progress)*x + progress*xx
end

function polCamera(playerid)
	local cTime = os.clock() * 1000
	if cTime > cam.stime + cam.polTime then
		deleteTimer(cam.timer)
		attachCamOnPlayer(playerid, -1)
		return
	end
	
	local nprogress = (cTime - cam.stime) / cam.polTime
	local x = lerp(cam.spos.x, cam.epos.x, nprogress)
	local y = lerp(cam.spos.y, cam.epos.y, nprogress)
	local z = lerp(cam.spos.z, cam.epos.z, nprogress)
	setPlayerCamPos(playerid, x, y, z, 1)
	
	drawInfoText(playerid, string.format("Progress: %f~n~nStart: %f~n~End: %f", nprogress, cam.stime, cam.stime + cam.polTime), 3000)
end

addCommand("/nrot",
	function(playerid, arg)
		if(arg == nil) then
			sendPlayerMsg(playerid, "Usage: /nrot [rotation]", 0xFFFF0000)
			do return end
		end
		
		local x, y, z = getPlayerPos(playerid)
		local npc = npcCreate("random", 1, x, y, z, -1, "", getPlayerWorld(playerid), arg[1])
		sendPlayerMsg(playerid, "NPC: " .. npc, 0xFFFF0000)
	end
, "f")

addCommand("/nprop",
	function(playerid, arg)
		if(arg == nil) then
			sendPlayerMsg(playerid, "Usage: /nprop [npc id] [property part] [value]", 0xFFFF0000)
			do return end
		end
		npcSetProperty(arg[1], arg[2], arg[3])
	end
, "iii")

addCommand("/nclothes",
	function(playerid, arg)
		if(arg == nil) then
			sendPlayerMsg(playerid, "Usage: /nclothes [npc id] [property part] [value]", 0xFFFF0000)
			do return end
		end
		npcSetClothes(arg[1], arg[2], arg[3])
	end
, "iii")

addCommand("/mclothes",
	function(playerid, arg)
		if(arg == nil) then
			sendPlayerMsg(playerid, "Usage: /mclothes [property part] [value]", 0xFFFF0000)
			do return end
		end
		setPlayerClothes(playerid, arg[1], arg[2])
		
		local str = ""
		for key, value in pairs(getPlayerClothes(playerid)) do
			str = str .. string.format(" (%i: %i)", key, value)
		end
		sendPlayerMsg(playerid, str, 0xFFFF0000)
	end
, "ii")

addCommand("/mprops",
	function(playerid, arg)
		if(arg == nil) then
			sendPlayerMsg(playerid, "Usage: /mprops [property part] [value]", 0xFFFF0000)
			do return end
		end
		setPlayerProperty(playerid, arg[1], arg[2])
		local str = ""
		for key, value in pairs(getPlayerProperties(playerid)) do
			str = str .. string.format(" (%i: %i)", key, value)
		end
		sendPlayerMsg(playerid, str, 0xFFFF0000)		
	end
, "ii")

local npc = npcCreate("TEST", 1, 0.0, 0.0, 0.0, -1, "", 1, 90.0)
print(npcAddFootTask())
npcAddFootTask(npc, -586.64819335938, -878.20764160156, 3.8428587913513, -586.64819335938, -878.20764160156, 3.8428587913513, 88.169281005859, 2, 12, 14000)