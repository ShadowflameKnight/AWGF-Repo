local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local gameplayGUI = playerGUI.GameplayGUI
local travelGUI = gameplayGUI.TravelGUI
local eventGUI = gameplayGUI.EventGUI
local characterCreatorGUI = playerGUI.CharacterCreatorGUI

local cameraModule = require(script.Parent.Parent.Gameplay.CameraModule)

local module = {}

function module.goToCharacterCreator()
    characterCreatorGUI.Enabled = true
    cameraModule.goToCharacterCreator()
    gameplayGUI.Enabled = false
    travelGUI.Enabled = false
end

return module