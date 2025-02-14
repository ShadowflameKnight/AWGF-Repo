local module = {}

local TextService = game:GetService("TextService")

function module.filterText(player, slotName)
	local success, result = pcall(function()
		local filteredInstance = TextService:FilterStringAsync(slotName, player.UserId, Enum.TextFilterContext.PublicChat)
		local filteredString = filteredInstance:GetNonChatStringForBroadcastAsync()
		return filteredString
	end)
	local function isFiltered(inputText, filteredText)
		return inputText ~= filteredText
	end
    return isFiltered(slotName, result), result
    
end

return module