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

local HEIGHT_OFFSET = 1
--offset of the height for the camera. The actual humanoid root part is 2 studs below the head, hence, the offset.

local CAMERA_DEPTH = 15
--the z axis and how far relative to the player the camera is 

local LENGTH_OFFSET = 0

local camera = workspace.CurrentCamera
camera.CameraType = "Custom"
--a variable that represents the location of the camera

camera.FieldOfView = 70
--Setting Camera FOV


local character = player.Character

local cameraPart = Instance.new("Part")
cameraPart.Name = "CameraPart"
cameraPart.Parent = workspace
cameraPart.Anchored = true
cameraPart.CanCollide = false
--cameraPart.Transparency = 1

RunService.RenderStepped:Connect(function(deltaTime)
	
end)


local function updateCamera()
	--This holds the logic needed to get and set a new position for the camera.
	-- Accesses the player's character so that the camera may be centered on it
	if character then
		-- Checks if the  character model exists yet so the program doesn't explode
		local character = player.Character
		if character then
			local root = character:FindFirstChild("HumanoidRootPart")
			-- finds the root part of the humanoid, which is the torso
			if root then
				local goalCFrame = character.HumanoidRootPart.CFrame + Vector3.new(-25, 10, 0)
				cameraPart.CFrame = cameraPart.CFrame:Lerp(goalCFrame, 0.1)
					--print("forward")
					--print(forwardRaycastResult.Instance)
					--print("backwards")
					--print(backwardsRaycastResult.Instance)
				
				
				--if not forwardRaycastResult --[[and not backwardsRaycastResult]] then
					-- checks if it finds the root successfully, deters if the root either didn't load or it isn't the root we're looking for.
				local rootPosition = root.Position + Vector3.new(cameraPart.Position.X + 5, cameraPart.Position.Y, cameraPart.Position.Z)
				-- the base position of camera. The vector is basically just the coordinates.
				local cameraPosition = Vector3.new(cameraPart.Position.X, cameraPart.Position.Y, cameraPart.Position.Z)
				-- Sets the camera position. Includes camera depth, which is how far the camera is away in terms of the z axis
				--Also includes a constantly updating position for the x and y axis
				camera.CFrame = CFrame.new(cameraPosition, character.HumanoidRootPart.Position)
				--Using Cframe.lookAt, update the camera position
					
					
				--end	
			end
		end
	end
	

	
	

end

local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds

local uiButtonClickSound = menuSounds.UIButtonClick

local module = {}

function module.startGameplay(gamemode)
	print("Yep")
	lightingConfig.changeLighting(gamemode)
	RunService:BindToRenderStep("SidescrollingCamera", Enum.RenderPriority.Camera.Value + 1, updateCamera)
	--BindToRenderStep means that this functino is constantly running every frame
	--Enum.RenderPriority.Camera.Value means that this process is first priority among other every-frame process, besides gate setup (hence, the + 1).
	--updateCamera is the function called every frame.
	camera.CameraType = Enum.CameraType.Custom

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