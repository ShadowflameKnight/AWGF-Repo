local startExpeditionRemote = game.ReplicatedStorage.LobbyMenu.Remotes.StartExpeditionRemote
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes

local mapHandler = require(script.Parent.MapHandler)
local mapLoaded = travelingRemotes.MapLoaded

local dataManager = require(script.Parent.Parent.PlayerData.Manager)

startExpeditionRemote.OnServerEvent:Connect(function(player, map) --From LobbyGUI
		--mapHandler.loadMap("Testing")
		--mapLoaded:FireClient(player)
		local profile = dataManager.getProfile(player)
		local isDead = profile.Data.isDead
		print(isDead)
		if isDead then
			mapHandler.loadLobby("Lobby")
			mapLoaded:FireAllClients()
		end

		
		
	
end)