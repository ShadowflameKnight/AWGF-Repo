local runService = game:GetService("RunService")

local character = game.Players.LocalPlayer.Character
local camera = workspace.CurrentCamera

local player = game.Players.LocalPlayer
--Accesses Local player to access the client's camera
local mouse = player:GetMouse()

local module = {}

local cameraPart = Instance.new("Part")
cameraPart.Name = "CameraPart"
cameraPart.Parent = workspace
cameraPart.Anchored = true
cameraPart.CanCollide = false
cameraPart.Transparency = 1

function module.travelingCamera()
	repeat
		task.wait()
		camera.CameraType = Enum.CameraType.Scriptable
	until
		camera.CameraType == Enum.CameraType.Scriptable
	
	local root = character:WaitForChild("HumanoidRootPart")
	
	local cameraDistanceFactor = 0
	mouse.WheelForward:Connect(function()
		if cameraDistanceFactor >= -5 then
			cameraDistanceFactor -= 2
		end
	end)

	mouse.WheelBackward:Connect(function()
		if cameraDistanceFactor <= 10 then
			cameraDistanceFactor += 2
		end
	end)

	runService:BindToRenderStep("SidescrollingCamera", Enum.RenderPriority.Camera.Value + 1, function()
		if character then
			local character = player.Character
			if character then
				local root = character:FindFirstChild("HumanoidRootPart")
				-- finds the root part of the humanoid, which is the torso
				if root then			
					--Adjust constant numbers manually to change the camera position in third person mode. 
					cameraPart.CFrame = CFrame.new(character.HumanoidRootPart.Position + Vector3.new(-15 - cameraDistanceFactor, 25 + cameraDistanceFactor, 15 + cameraDistanceFactor), character.HumanoidRootPart.Position)
	
					-- Adjust maxTilt to change how much the camera will tilt by (Default: 10)
					local maxTilt = 10
					camera.CFrame = cameraPart.CFrame * CFrame.Angles(
						math.rad((((mouse.Y - mouse.ViewSizeY / 2) / mouse.ViewSizeY)) * -maxTilt),
						math.rad((((mouse.X - mouse.ViewSizeX / 2) / mouse.ViewSizeX)) * -maxTilt),
						0
				  )			
				end
			end
		end
	end)
end



return module