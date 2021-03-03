local rconPassword = "test"
local admins = {}

addCommand("/loadscript",
	function(playerid, text)
		if(admins[playerid] ~= nil) then
			--Already authed as admin here
			local scriptName = text[1]
			print("RCON: Loading FS: " .. scriptName)
			if(isScriptLoaded(scriptName)) then
				unloadScript(scriptName)
				sendPlayerMsg(playerid, scriptName .. " was unloaded", 0xFFFFFFFF)
			end
			if(loadScript(scriptName)) then
				sendPlayerMsg(playerid, scriptName .. " was loaded", 0xFFFFFFFF)
			end
		end
	end
, "s")

addCommand("/rconlogin",
	function(playerid, text)
		local pw = text[1]
		print(getPlayerName(playerid) .. " attempted to rconlogin with pw: " .. pw)
		if(pw == rconPassword) then
			admins[playerid] = true
			sendPlayerMsg(playerid, "Admin status activated", 0xFFFF0000)
		end
	end
, "s")

addCommand("/kick",
	function(playerid, text)
		local target = text[1]
		if(target == nil or isPlayerOnline(target) ~= true) then
			return sendPlayerMsg(playerid, "Invalid player ID", 0xFFFF0000)
		end
		sendPlayerMsg(playerid, "You kicked " .. getPlayerName(target) .. " out the server", 0xFFFF0000)
		disconnectPlayer(target)
	end
, "i")

addCommand("/cp",
	function(playerid)
		local x, y, z = getPlayerPos(playerid)
		local id = createCheckPoint(x, y, z, 0.5, 0xFF0000FF, 1, 0, 1)
		sendPlayerMsg(playerid, "Cp spawned: " .. id, 0xFFFF0000)
	end
, nil)

--[[function rconCommandEvent(playerid, text)
	if(string.sub(text, 1, 11) == "/loadscript") then
			cmd_loadScript(playerid, text)
	elseif(string.sub(text, 1, 10) == "/rconlogin") then
		cmd_rconLogin(playerid, text)
	elseif(string.sub(text, 1, 5) == "/kick") then
		cmd_rconKick(playerid, text)
	end	
end
registerEvent("rconCommandEvent", "onPlayerCommand")--]]

function rconPlayerLeft(playerid, reason)
	if(admins[playerid] ~= nil) then
		--Player was authed as admin, now we remove his status
		admins[playerid] = nil
		print(getPlayerName(playerid) .. " rcon was freed")
	end
end
registerEvent("rconPlayerLeft", "onPlayerLeft")