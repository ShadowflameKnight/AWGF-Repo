local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music

local uiButtonClickSound = menuSounds.UIButtonClick

----New Slot Naming Sequence----------------------------------
local isEmpty, completedTutorial = giveLobbyDataRemote.OnClientEvent:Wait()

local isEmptyHandler = player.PlayerScripts.Client.Lobby.IsEmptyHandler
if isEmpty then
	require(isEmptyHandler)
else
	isEmptyHandler:Destroy()
end

isEmptyHandler.Destroying:Wait() ---The script self destructs once this sequence completes.
----Tutorial Sequence----------------------------------
if not completedTutorial then
	print("not completed tutorial")
end

