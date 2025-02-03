local module = {}

module.Profiles = {}

return module

--[[
function module.saveTorsoColor(player: Players, color)
	local profile = module.Profiles[player]
	if not profile then return end
	profile.Data.torsoColors = {color.R, color.G, color.B}
	print("Saved "..profile.Data.torsoColors[1], profile.Data.torsoColors[2], profile.Data.torsoColors[3])
end

function module.saveSetting(player: Player, setting, value)
	local profile = module.Profiles[player]
	if not profile then return end
	profile.Data.gameSettings[setting] = value
end

function module.fillInMissingData(player: Player, data, value)
	local profile = module.Profiles[player]
	if not profile then return end
	--If the data doesn't exist, fill it in
	if profile.Data[data] == nil then
		profile.Data[data] = value
	end
end
]]