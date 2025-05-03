local module = {}

module.Profiles = {}

local TextService = game:GetService("TextService")

local filterModule = require(game.ServerScriptService.Server.Misc.FilterText)

function module.newSlotName(player, slotName)
	
	local isFiltered, result = filterModule.filterText(player, slotName)
	
	if isFiltered then return result end
	

	if result == "" then result = "The Facility" end
	
	local profile = module.Profiles[player]
	if not profile then return end
	
	profile.Data.mainMenuData.saveName = result
	profile.Data.mainMenuData.isEmpty = false
	
	return result	
end

function module.getIsDead(player)
	local profile = module.Profiles[player]
	if not profile then return end
	return profile.Data.isDead
end

--Used to get profile from a server script. Used in GameplayServer. Highly inadvised to return this result to client via remote.
function module.getProfile(player) 
	local profile = module.Profiles[player]
	if not profile then return end
	return profile
end

return module

