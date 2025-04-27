local startExpeditionRemote = game.ReplicatedStorage.LobbyMenu.Remotes.StartExpeditionRemote
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes

local mapHandler = require(script.Parent.MapHandler)
local mapLoaded = travelingRemotes.MapLoaded

startExpeditionRemote.OnServerEvent:Connect(function(player, map) --From LobbyGUI
		--mapHandler.loadMap("Testing")
		--mapLoaded:FireClient(player)
	
		mapHandler.loadLobby("Lobby")
		mapLoaded:FireClient(player)
	
end)