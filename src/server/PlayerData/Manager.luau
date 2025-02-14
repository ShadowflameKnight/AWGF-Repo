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

return module
