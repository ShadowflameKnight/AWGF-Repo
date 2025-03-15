local replicatedStorage = game:GetService("ReplicatedStorage")
local startGameplayBindable = replicatedStorage.LobbyMenu.Remotes.StartExpeditionBindable

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()

local camera = workspace.CurrentCamera

local tweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
local soundEffects = soundService.SoundEffects

local uiButtonClickSound = menuSounds.UIButtonClick

local module = {}

function module.startGameplay(gamemode)

	local mapLoadedRemote = replicatedStorage.Gameplay.Traveling.MapLoaded
	mapLoadedRemote.OnClientEvent:Connect(function()
		player.Character.HumanoidRootPart.CFrame = workspace:FindFirstChild("StartingRoom").SpawnBrick.CFrame
	end)

	--Change lighting to the specified things under the module script
	lightingConfig.changeLighting(gamemode)

	--Re enabling mobile controls
	local GuiService = game:GetService("GuiService") 
	GuiService.TouchControlsEnabled = true
	
	--Setting camera
	cameraModule.travelingCamera()

	--Sprinting
	local canMove = true
	UserInputService.InputBegan:Connect(function(input)
		if canMove then
			if input.KeyCode == Enum.KeyCode.LeftShift then
				character.Humanoid.WalkSpeed = 32	
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if canMove then
			if input.KeyCode == Enum.KeyCode.LeftShift then
				character.Humanoid.WalkSpeed = 16
			end
		end
	end)

	--When player touches an event trigger brick when traveling
	local triggerEventRemote = replicatedStorage.Gameplay.Traveling.TriggerEvent
	triggerEventRemote.OnClientEvent:Connect(function(roomInstance)
		cameraModule.travelingEvent(roomInstance)
		canMove = false
		character.Humanoid.WalkSpeed = 0
	end)


	--Tweening and handling for when the player opens a door.
	local openDoorRemote = game.ReplicatedStorage.Gameplay.Traveling.OpenDoor
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

	local blackscreenClone = miscGUI:FindFirstChild("BlackScreen")
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