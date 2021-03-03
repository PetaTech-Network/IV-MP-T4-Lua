function onCustomChatCommand(playerid, text)
	if(string.sub(text, 1, 7) == "/cClear") then
		local id = tonumber(string.sub(text, 9))
		if id == nil then
			sendPlayerMsg(playerid, "Not a number", 0xFFFF0000)
			return
		end
		sendChatOptions(playerid, id, 3)

	elseif(string.sub(text, 1, 8) == "/cSwitch") then
		local id = tonumber(string.sub(text, 10))
		if id == nil then
			sendPlayerMsg(playerid, "Not a number", 0xFFFF0000)
			return
		end
		sendChatOptions(playerid, id, 4)
	elseif(string.sub(text, 1, 5) == "/cDel") then
		local id = tonumber(string.sub(text, 7))
		if id == nil then
			sendPlayerMsg(playerid, "Not a number", 0xFFFF0000)
			return
		end
		sendChatOptions(playerid, id, 2)	
	elseif(string.sub(text, 1, 5) == "/cNew") then
		local id = tonumber(string.sub(text, 7))
		if id == nil then
			sendPlayerMsg(playerid, "Not a number", 0xFFFF0000)
			return
		end
		sendChatOptions(playerid, id, 1)
	elseif(string.sub(text, 1, 5) == "/cTxt") then
		local id = tonumber(string.sub(text, 7))
		if id == nil then
			sendPlayerMsg(playerid, "Not a number", 0xFFFF0000)
			return
		end	
		sendCustomMsg(playerid, "UEUEUEUEUE: " .. id, 0xFF0000FF, id)
	end
end
registerEvent("onCustomChatCommand", "onPlayerCommand")

local playerChatMode = {}

function customChat_onPlayerChat(playerid, text)
	if playerChatMode[playerid] == nil then return true end
	
	return false
end
registerEvent(customChat_onPlayerChat, "onPlayerChat")

function customChat_playerLeft(playerid, reason)
	if(admins[playerid] ~= nil) then
		--Player was authed as admin, now we remove his status
		admins[playerid] = nil
		print(getPlayerName(playerid) .. " rcon was freed")
	end
end
registerEvent("customChat_playerLeft(", "onPlayerLeft")

function customChat_keyPress(playerId, virtualKey, isKeyUp)
end
registerEvent("customChat_keyPress", "onPlayerKeyPress")

function customChat_onChatUpdate(playerid, chatId, chatOperation)
	sendPlayerMsg(playerid, "ChatResponse: " .. chatId .. ", " .. chatOperation, 0xFFFF0000)
end
registerEvent("customChat_onChatUpdate", "onPlayerChatUpdate")

function customChat_pCredentials(playerid)
	setPlayerKeyHook(playerid, 0x43, true) --C key
	setPlayerKeyHook(playerid, 0x25, true) -- < or ,
	setPlayerKeyHook(playerid, 0x27, true) -- < or ,
end
registerEvent(customChat_pCredentials, "onPlayerCredential")