-- This script focuses on initializing the game once the user has selected a save.

local replicatedStorage = game:GetService("ReplicatedStorage")
local startGameplayBindable = replicatedStorage.LobbyMenu.Remotes.StartExpeditionBindable

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()

local tweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local replicatedStorage = game.ReplicatedStorage
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local gameplayGUI = playerGUI.GameplayGUI
local travelGUI = gameplayGUI.TravelGUI
local eventGUI = gameplayGUI.EventGUI

local triggerEventModule = require(script.Parent.TriggerEvent)

local textPopUpModule = require(player.PlayerScripts.Client.Misc.PopupText)
local cameraModule = require(script.Parent.CameraModule)
local lightingConfig = require(game.StarterPlayer.StarterPlayerScripts.Client.Misc.LightingConfig)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds
local soundEffects = soundService.SoundEffects

local uiButtonClickSound = menuSounds.UIButtonClick

local goToCharacterCreator = replicatedStorage.LobbyMenu.Remotes.GoToCharacterCreator
local transitionLoadingScreenModule = require(script.Parent.Parent.Misc.TransitionLoadingScreen)
local characterCreatorModule = require(script.Parent.Parent.Lobby.CharacterCreator)

local location = ""
local locationPopupModule = require(script.Parent.Parent.Misc.LocationPopup)

-- Fired to Animate script in player scripts to toggle their respective animation.
local toggleSprint = travelingRemotes.ToggleSprint

--Sprinting and toggling movement
local canMove = character:WaitForChild("CanMove")

canMove:GetPropertyChangedSignal("Value"):Connect(function()
	if canMove.Value == false then
		character.Humanoid.WalkSpeed = 0
	else
		character.Humanoid.WalkSpeed = 16 -- or whatever the normal speed is
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if canMove.Value then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			toggleSprint:Fire(true) -- Sent to animate
			character.Humanoid.WalkSpeed = 32	
		end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if canMove.Value then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			character.Humanoid.WalkSpeed = 16
			toggleSprint:Fire(false) -- Sent to animate
		end
	end
end)

local TransitionLoadingScreen = require(game.StarterPlayer.StarterPlayerScripts.Client.Misc.TransitionLoadingScreen)
goToCharacterCreator.OnClientEvent:Connect(function()
	canMove.Value = false
	transitionLoadingScreenModule.CreateTransition()
	characterCreatorModule.goToCharacterCreator()
	task.wait(2)
	TransitionLoadingScreen.DestroyTransition()
	locationPopupModule.displayLocation(location)
end)

local module = {}

local triggerEventRemote = travelingRemotes.TriggerEvent
--When player touches an event trigger brick when traveling
triggerEventRemote.OnClientEvent:Connect(function(roomInstance)
	cameraModule.travelingEvent(roomInstance)
	canMove.Value = false
	triggerEventModule.EventTriggered()
end)

--Tweening and handling for when the player opens a door.
local openDoorRemote = travelingRemotes.OpenDoor
openDoorRemote.OnClientEvent:Connect(function(mapLayout, roomInstance, placeInMapLayout)
	local nextRoom = mapLayout[placeInMapLayout + 1]
	local nextRoomEntranceDoor = nextRoom.EntranceWall.Door
	local currentRoomExitDoor = roomInstance.ExitWall.Door

	local tweenEntranceRightDoor = tweenService:Create(nextRoomEntranceDoor.RightDoor, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = nextRoomEntranceDoor.EndpointRight.CFrame})
	tweenEntranceRightDoor:Play()
	local tweenLeftDoor = tweenService:Create(nextRoomEntranceDoor.LeftDoor, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = nextRoomEntranceDoor.EndpointLeft.CFrame})
	tweenLeftDoor:Play()

	local tweenExitRightDoor = tweenService:Create(currentRoomExitDoor.RightDoor, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = currentRoomExitDoor.EndpointRight.CFrame})
	tweenExitRightDoor:Play()
	local tweenExitLeftDoor = tweenService:Create(currentRoomExitDoor.LeftDoor, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = currentRoomExitDoor.EndpointLeft.CFrame})
	tweenExitLeftDoor:Play()

	local prompt = roomInstance.ExitWall.Door.ProxPart.ProximityPrompt
	prompt.Parent:Destroy()
	soundEffects.MetalDoorOpening:Play()
end)

local mapLoadedRemote = travelingRemotes.MapLoaded
	mapLoadedRemote.OnClientEvent:Connect(function()
		player.Character.HumanoidRootPart.CFrame = workspace:FindFirstChild("StartingRoom").SpawnBrick.CFrame
	end)
function module.startGameplay(gamemode)
	print(gamemode)

	--Change lighting to the specified things under the module script
	lightingConfig.changeLighting(gamemode)

	--Re enabling mobile controls
	local GuiService = game:GetService("GuiService") 
	GuiService.TouchControlsEnabled = true
	
	--Setting camera
	cameraModule.travelingCamera()

	gameplayGUI.Enabled = true
	travelGUI.Enabled = true

	--Cleaning up GUI from main menu
	local blackscreenClone = miscGUI:FindFirstChild("BlackScreen")
	local tweenBlackscreen = tweenService:Create(blackscreenClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(-1, 0)})
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