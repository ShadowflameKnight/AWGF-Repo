local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local characterCreatorGUI = playerGUI:WaitForChild("CharacterCreatorGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(player.PlayerScripts.Client.Misc.PopupText)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds

local uiButtonClickSound = menuSounds.UIButtonClick

-- Setting GUI's
miscGUI.Enabled = true
characterCreatorGUI.Enabled = false

----New Slot Naming Sequence----------------------------------
local isEmpty, completedTutorial = giveLobbyDataRemote.OnClientEvent:Wait()

for i, sound in ipairs(music:GetChildren()) do
	sound:Stop()
end

local blur = game.Lighting.Blur
blur.Enabled = false

local lobbyInitializer = require(game.StarterPlayer.StarterPlayerScripts.Client.Lobby.LobbyInitializer)
if isEmpty then
	lobbyInitializer.newSlot()
end

local startExpeditionRemote = lobbyMenuStorage.Remotes.StartExpeditionRemote
local startExpeditionBindable = lobbyMenuStorage.Remotes.StartExpeditionBindable
----Tutorial Sequence----------------------------------
--[[
if not completedTutorial then
	print("not completed tutorial")
	--Whenever i get to making the tutorial replace that code here
	
	startExpeditionRemote:FireServer("Tutorial") -- Sent to GameplayServer
	startExpeditionBindable:Fire("Tutorial")
	local gameplayClient = require(script.Parent.Parent.Gameplay.GameplayClient)
	gameplayClient.startGameplay("tutorial")
else
	startExpeditionRemote:FireServer("Lobby") -- Sent to GameplayServer
	startExpeditionBindable:Fire("Lobby")
	local gameplayClient = require(script.Parent.Parent.Gameplay.GameplayClient)
	gameplayClient.startGameplay("Lobby")

end
]]----------
startExpeditionRemote:FireServer() -- Sent to GameplayServer
startExpeditionBindable:Fire()
local gameplayClient = require(script.Parent.Parent.Gameplay.GameplayClient)
gameplayClient.startGameplay()

