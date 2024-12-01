local playerGUI = game.Players.LocalPlayer.PlayerGui

local GuiService = game:GetService("GuiService") 
GuiService.TouchControlsEnabled = false
local tweenService = game:GetService("TweenService")

local menuGUI = playerGUI:WaitForChild("MenuGUI")
menuGUI.Enabled = true

local cam = workspace.CurrentCamera
cam.CameraType = "Scriptable"


local cameraPoints = {
	mainMenuPos = game.Workspace.MainMenuRoom.CameraPart.Position,
}

local basePos = game.Workspace.MainMenuRoom.Base.Glass.Position

local pos = cameraPoints.mainMenuPos
local cameraCFrame = CFrame.new(pos, Vector3.new(basePos.X, basePos.Y, basePos.Z ))
cam.FieldOfView = 70
cam.CFrame = cameraCFrame

-----Sound Stuff---------------
local soundService = game:WaitForChild("SoundService")
local menuSounds = soundService.MenuSounds
local confirmSound = menuSounds.ConfirmSound
--------------------------------


---"Click anywhere to continue"--------------------------------------------------------
local gameTitle = menuGUI.GameTitle
gameTitle.Visible = true

local continueText = menuGUI.ContinueText
continueText.Visible = true
local tweenContinueText = tweenService:Create(continueText, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true, 1), {TextTransparency = 1})
tweenContinueText:Play()

local blur = game.Lighting.Blur
local anywhere = menuGUI.Anywhere
local saveSlotScrolling = menuGUI.SaveSlotScrolling
anywhere.Activated:Connect(function()
	blur.Enabled = true
	blur.Size = 0
	local tweenBlur = tweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = 24})
	tweenBlur:Play()
	continueText.Visible = false
	anywhere.Visible = false
	confirmSound:Play()
	
	saveSlotScrolling.Visible = true
end)

---SaveSlotScrolling-----------------
for i, slot in ipairs(saveSlotScrolling:GetChildren()) do
	if slot.Name == "SaveSlot" then
		slot.Activated:Connect(function()
			
			confirmSound:Play()
			for index, element in ipairs(slot:GetChildren()) do
				if element:IsA("TextLabel") then
					element.Visible = true
					if element.Name == "EmptySlotTextLabel" then
						element.Visible = false
					end
				end
			end


		end)
	end
end