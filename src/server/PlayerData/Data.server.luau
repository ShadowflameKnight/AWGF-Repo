local Players = game:GetService("Players")

local slotsOwned = 2

local Template = require(script.Parent.Template)

local ProfileService = require(game.ServerScriptService.Server.PlayerData.ProfileService)
local Manager = require(script.Parent.Manager)

local ProfileStore = ProfileService.GetProfileStore("secondTesting", Template)

local mainMenuFolder = game.ReplicatedStorage.MainMenu

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

local function loadProfile(player, slotNumber)
	local profile = ProfileStore:LoadProfileAsync("Player_"..slotNumber.."_"..player.UserId)
	if profile == nil then
		player:Kick("Roblox datastores farted.")
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil
	end)

	if player:IsDescendantOf(Players) then
		Manager.Profiles[player] = profile
	else
		profile:Release()
		player:Kick("Player not found.")
	end
	return profile
end

local fetchSlotInformation = mainMenuFolder.Remotes.FetchSlotInformation
fetchSlotInformation.OnServerInvoke = function(player, slotNumber)
	local profile = loadProfile(player, slotNumber)

	local mainMenuData = profile.Data.mainMenuData
	profile:Release()
	return mainMenuData
end

local updateSlotData = mainMenuFolder.Remotes.UpdateSlotData
---The first parameter of this event is the instruction. The next is the slot number. Every parameter afterwards is whatever input.

---Enter "Name" as first parameter to update slot data
---Enter "Delete" to delete
updateSlotData.OnServerInvoke = function(player, instruction, slotNumber, data1, data2, data3)
	if instruction == "Delete" then
		ProfileStore:WipeProfileAsync("Player_"..slotNumber.."_"..player.UserId)
		return true
	end
	local profile = loadProfile(player, slotNumber)
	local mainMenuData = profile.Data.mainMenuData
	if instruction == "Name" then
		local result = Manager.newSlotName(player, data1)
		profile:Release()
		return result
	end

	profile:Release()
	return false --Indicates the process has been successful
end

local giveSlotAmount = mainMenuFolder.Remotes.GiveSlotAmount
local function PlayerAdded(player: Player)
	if player == nil then
		player:Kick("Player not found. Data cannot be gathered.")
		return
	end
	giveSlotAmount:FireClient(player, slotsOwned)
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

local checkSlotName = game.ReplicatedStorage.MainMenu.Remotes.CheckSlotName
checkSlotName.OnServerInvoke = function(player, slotText, slotNumber)
	if slotText == "" then 
		return "Name cannot be blank"
	end
end

-------Everything after this is after the player starts a game--------------------
local gameStartRemote = game.ReplicatedStorage.MainMenu.Remotes.GameStart
local giveLobbyData = game.ReplicatedStorage.LobbyMenu.Remotes.GiveLobbyData
gameStartRemote.OnServerInvoke = function(player, slotNumber)
	local profile = loadProfile(player, slotNumber)
	local isEmpty = profile.Data.mainMenuData.isEmpty
	local completedTutorial = profile.Data.achievements.completedTutorial
	giveLobbyData:FireClient(player, isEmpty, completedTutorial)
	print(profile.Data.mainMenuData.saveName)
end


local newSlotNameRemote = game.ReplicatedStorage.LobbyMenu.Remotes.NewSlotName
newSlotNameRemote.OnServerInvoke = function(player, slotName)
	local result = Manager.newSlotName(player, slotName)
	return result
end