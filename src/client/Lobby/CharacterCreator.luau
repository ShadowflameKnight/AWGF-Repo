local replicatedStorage = game:GetService("ReplicatedStorage")
local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local gameplayGUI = playerGUI.GameplayGUI
local travelGUI = gameplayGUI.TravelGUI
local eventGUI = gameplayGUI.EventGUI
local characterCreatorGUI = playerGUI.CharacterCreatorGUI
local createCharacterButton = characterCreatorGUI.CreateCharacter
local loadLobbyRemote = replicatedStorage.Gameplay.Traveling.Remotes.LoadLobby

local cameraModule = require(script.Parent.Parent.Gameplay.CameraModule)

local module = {}

function module.goToCharacterCreator()
    characterCreatorGUI.Enabled = true
    cameraModule.goToCharacterCreator()
    gameplayGUI.Enabled = false
    travelGUI.Enabled = false

	local connection 
    connection = createCharacterButton.Activated:Connect(function()
        ---save character creator stuff to data profile
        --put stuff here later
        --put stuff here later

        loadLobbyRemote:FireServer() --Received by GameplayServer
		connection:Disconnect()
    end)
end



return module