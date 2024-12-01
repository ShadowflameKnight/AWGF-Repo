local Players = game:GetService("Players")

local Template = {
	saveSlotsOwned = 2
	
	
}

local ProfileService = require(game.ServerScriptService.Server.PlayerData.ProfileService)
local Manager = require(script.Parent.Manager)

local ProfileStore = ProfileService.GetProfileStore("firstTesting", Template)

local function deepCopy(original) ---for deepcopying tables, mostly for saving loadout
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function loadPlayerData(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	
end

	

local function PlayerAdded(player: Player)
	if player == nil then
		player:Kick("Data Issue, womp womp")
		return
	end
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
	if profile == nil then
		player:Kick("Data Issue, womp womp")
		return
	end
	

	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil
		player:Kick("Data Issue, womp womp")
	end)

	if player:IsDescendantOf(Players) then
		Manager.Profiles[player] = profile
		loadPlayerData(player)
	else
		profile:Release()
	end
	

end

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile:Release()
end)



