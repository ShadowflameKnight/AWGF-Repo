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
	
	runService:BindToRenderStep("SidescrollingCamera", Enum.RenderPriority.Camera.Value + 1, function()
		if character then
			-- Checks if the  character model exists yet so the program doesn't explode
			local character = player.Character
			if character then
				local root = character:FindFirstChild("HumanoidRootPart")
				-- finds the root part of the humanoid, which is the torso
				if root then
					local goalCFrame = character.HumanoidRootPart.CFrame + Vector3.new(-25, 30, 25)
					
					cameraPart.CFrame = CFrame.new(character.HumanoidRootPart.Position + Vector3.new(-25, 30, 25), character.HumanoidRootPart.Position)
	
	
					local maxTilt = 10
					camera.CFrame = cameraPart.CFrame * CFrame.Angles(
						math.rad((((mouse.Y - mouse.ViewSizeY / 2) / mouse.ViewSizeY)) * -maxTilt),
						math.rad((((mouse.X - mouse.ViewSizeX / 2) / mouse.ViewSizeX)) * -maxTilt),
						0
				  )
					--Using Cframe.lookAt, update the camera position
						
						
					
					
				end
			end
		end
	end)
end



return module