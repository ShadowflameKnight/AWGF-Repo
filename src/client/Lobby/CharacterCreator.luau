local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local character = player.Character
local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local gameplayGUI = playerGUI.GameplayGUI
local travelGUI = gameplayGUI.TravelGUI
local eventGUI = gameplayGUI.EventGUI
local characterCreatorGUI = playerGUI.CharacterCreatorGUI
local createCharacterButton = characterCreatorGUI.CreateCharacter
local loadLobbyRemote = replicatedStorage.Gameplay.Traveling.Remotes.LoadLobby
local saveCharacterRemote = replicatedStorage.Misc.DataRemotes.SaveCharacter

local cameraModule = require(script.Parent.Parent.Gameplay.CameraModule)
local transitionLoadingScreenModule = require(script.Parent.Parent.Misc.TransitionLoadingScreen)

local module = {}

function module.goToCharacterCreator()
    characterCreatorGUI.Enabled = true
    cameraModule.goToCharacterCreator()
    gameplayGUI.Enabled = false
    travelGUI.Enabled = false

	local connection 
    connection = createCharacterButton.Activated:Connect(function()
        ---save character creator stuff to data profile, then change character to the character model.
        characterCreatorGUI.Enabled = false
        transitionLoadingScreenModule.CreateTransition()
        saveCharacterRemote:FireServer(workspace.CustomizeRoom.CharacterCreatorModel) --Sent to Manager
        character = workspace.CustomizeRoom.CharacterCreatorModel

        --Begin lobby sequence and stop checking for when the button is activated
        loadLobbyRemote:FireServer() --Received by GameplayServer
        task.wait(2)
        workspace:WaitForChild("StartingRoom")
        transitionLoadingScreenModule.DestroyTransition()
		connection:Disconnect()
    end)
end



return module