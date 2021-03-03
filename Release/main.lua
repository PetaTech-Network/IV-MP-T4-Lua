print("Lua " .. _VERSION)

require("/filterscripts/utility/utilis")
require("/filterscripts/utility/scriptLoader")
require("/filterscripts/utility/commandsHandler")

--I load the following scripts like this so I can reload them whenever using the rcon script
loadScript("rcon")
loadScript("playerSpawn")
loadScript("cart")
loadScript("weapons")
loadScript("skins")
loadScript("TeamSpeak")
loadScript("npc/npcRecorder")
loadScript("npc/npcLoader")
loadScript("entities")
--loadScript("customChat")

local currentWeather = 0
setWorldMinuteDuration(1, 0)


print(sha2("test"))
print(sha2("test2"))