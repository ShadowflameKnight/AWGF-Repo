local startExpeditionRemote = game.ReplicatedStorage.LobbyMenu.Remotes.StartExpeditionRemote
local mapHandler = require(script.Parent.MapHandler)


startExpeditionRemote.OnServerEvent:Connect(function(player)
	mapHandler.loadMap("Testing")
end)