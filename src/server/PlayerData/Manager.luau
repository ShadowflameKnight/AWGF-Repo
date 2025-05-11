local TextService = game:GetService("TextService")
local filterModule = require(game.ServerScriptService.Server.Misc.FilterText)
local replicatedStorage = game.ReplicatedStorage
local module = {}

module.Profiles = {}

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

--Used to get profile from a server script. Used in GameplayServer. Highly inadvised to return this result to client via remote.
function module.getProfile(player) 
	local profile = module.Profiles[player]
	if not profile then return end
	print(profile.Data.characterCreatorSettings.character)
	print(profile.Data.character)
	return profile
end

local saveCharacterRemote = replicatedStorage.Misc.DataRemotes.SaveCharacter
saveCharacterRemote.OnServerEvent:Connect(function(player, character)
	local profile = module.Profiles[player]
	if not profile then return end
	--save  character traits with saveCharacterRemote
end)

return module

