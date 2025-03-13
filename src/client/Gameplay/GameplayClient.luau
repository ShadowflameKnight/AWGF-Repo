local replicatedStorage = game:GetService("ReplicatedStorage")
local startGameplayBindable = replicatedStorage.LobbyMenu.Remotes.StartExpeditionBindable
local lightingConfig = require(game.StarterPlayer.StarterPlayerScripts.Client.Misc.LightingConfig)

local replicatedStorage = game:GetService("ReplicatedStorage")

--The purpose of this code is to make a 2D Sidescrolling system.

local Players = game:GetService("Players")
-- obtains the service Players from the data model (the game)

local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
--Accesses Local player to access the client's camera
local mouse = player:GetMouse()


local character = player.Character



local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)
local cameraModule = require(script.Parent.CameraModule)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds

local uiButtonClickSound = menuSounds.UIButtonClick

local module = {}

function module.startGameplay(gamemode)
	print("Yep")
	lightingConfig.changeLighting(gamemode)
	local GuiService = game:GetService("GuiService") 
	GuiService.TouchControlsEnabled = false
	
	cameraModule.travelingCamera()

	local blackscreenClone = lobbyGUI:FindFirstChild("BlackScreen")
	local tweenBlackscreen = tweenService:Create(blackscreenClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0)})
	tweenBlackscreen:Play()	

	local loadingScreenWoosh = menuSounds.LoadingScreenWoosh
	loadingScreenWoosh:Play()

	local waitForWoosh 
	waitForWoosh = loadingScreenWoosh.Ended:Connect(function()
		blackscreenClone:Destroy()
		waitForWoosh:Disconnect()
	end)
end

return module