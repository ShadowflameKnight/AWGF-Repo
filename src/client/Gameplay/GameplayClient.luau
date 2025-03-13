local replicatedStorage = game:GetService("ReplicatedStorage")
local startGameplayBindable = replicatedStorage.LobbyMenu.Remotes.StartExpeditionBindable

local replicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character

local tweenService = game:GetService("TweenService")

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")

local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)
local cameraModule = require(script.Parent.CameraModule)
local lightingConfig = require(game.StarterPlayer.StarterPlayerScripts.Client.Misc.LightingConfig)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds

local uiButtonClickSound = menuSounds.UIButtonClick

local module = {}

function module.startGameplay(gamemode)
	local mapLoadedRemote = replicatedStorage.Gameplay.Traveling.MapLoaded
	mapLoadedRemote.OnClientEvent:Connect(function()
		player.Character.HumanoidRootPart.CFrame = workspace:FindFirstChild("StartingRoom").SpawnBrick.CFrame
	end)

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