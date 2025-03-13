local startExpeditionRemote = game.ReplicatedStorage.LobbyMenu.Remotes.StartExpeditionRemote
local mapHandler = require(script.Parent.MapHandler)
local mapLoaded = game.ReplicatedStorage.Gameplay.Traveling.MapLoaded

startExpeditionRemote.OnServerEvent:Connect(function(player)
	mapHandler.loadMap("Testing")
	mapLoaded:FireClient(player)
end)