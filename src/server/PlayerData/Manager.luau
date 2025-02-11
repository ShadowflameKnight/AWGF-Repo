local module = {}

module.Profiles = {}

local TextService = game:GetService("TextService")

function module.newSlotName(player, slotName)
	local success, result = pcall(function()
		local filteredInstance = TextService:FilterStringAsync(slotName, player.UserId, Enum.TextFilterContext.PublicChat)
		local filteredString = filteredInstance:GetNonChatStringForBroadcastAsync()
		return filteredString
	end)
	local function isFiltered(inputText, filteredText)
		return inputText ~= filteredText
	end
	print("Module")
	print(result)
	print(isFiltered(slotName, result))
	if isFiltered(slotName, result) then return result end
	

	if result == "" then result = "The Facility" end
	
	local profile = module.Profiles[player]
	if not profile then return end
	
	profile.Data.mainMenuData.saveName = result
	profile.Data.mainMenuData.isEmpty = false
	
	return result	
end

return module
