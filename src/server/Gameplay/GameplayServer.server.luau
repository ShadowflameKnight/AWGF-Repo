local replicatedStorage = game:GetService("ReplicatedStorage")
local startExpeditionRemote = game.ReplicatedStorage.LobbyMenu.Remotes.StartExpeditionRemote
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes
local loadLobbyRemote = replicatedStorage.Gameplay.Traveling.Remotes.LoadLobby

local mapHandler = require(script.Parent.MapHandler)
local mapLoaded = travelingRemotes.MapLoaded

local dataManager = require(script.Parent.Parent.PlayerData.Manager)

startExpeditionRemote.OnServerEvent:Connect(function(player) --From LobbyGUI. Activated only once ever, despite the remote's name
	--mapHandler.loadMap("Testing")
	--mapLoaded:FireClient(player)
	local profile = dataManager.getProfile(player)
	local isDead = profile.Data.isDead
	print(isDead)
	if isDead then
		mapHandler.loadCrystal()
		game.workspace:WaitForChild("StartingRoom")
		mapLoaded:FireAllClients("Crystal")
	end

	loadLobbyRemote.OnServerEvent:Connect(function() -- From CharacterCreator
		mapHandler.loadLobby()
		mapLoaded:FireClient(player, "Lobby")
	end)
end)