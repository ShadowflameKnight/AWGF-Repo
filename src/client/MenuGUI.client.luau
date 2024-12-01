local playerGUI = game.Players.LocalPlayer.PlayerGui

local GuiService = game:GetService("GuiService") 
GuiService.TouchControlsEnabled = false
local tweenService = game:GetService("TweenService")

local menuGUI = playerGUI:WaitForChild("MenuGUI")
menuGUI.Enabled = true

local mainMenuStorage = game.ReplicatedStorage.MainMenu

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
local saveSlot = mainMenuStorage.UIElements.SaveSlot
local giveSlotsAmount = mainMenuStorage.Remotes.GiveSlotAmount

local updateSlotData = mainMenuStorage.Remotes.UpdateSlotData


giveSlotsAmount.OnClientEvent:Connect(function(slotsOwned)
	for i = 1, slotsOwned do
		local slotClone = saveSlot:Clone()
		slotClone.LayoutOrder = i
		slotClone.Name = tostring(i)
		slotClone.Parent = saveSlotScrolling
		
		local fetchSlotInformation = mainMenuStorage.Remotes.FetchSlotInformation
		local mainMenuData = fetchSlotInformation:InvokeServer(i)
		
		if not mainMenuData.isEmpty then
			slotClone.SlotName.Text = mainMenuData.saveName
			slotClone.GameplayTime.Text = "Gameplay Time: "..mainMenuData.gameplayTime
			slotClone.IsEmpty.Value = false
			
			for _, element in ipairs(slotClone:GetChildren()) do
				if element:IsA("TextLabel") or element:IsA("TextButton") then
					if element.Name == "EmptySlotTextLabel" then
						element.Visible = false
					elseif element.Name == "SlotName" then
						element.TextBox.Visible = false
						element.Visible = true
					else
						element.Visible = true
					end
				end
			end
		end
	end
	
	for i, slot in ipairs(saveSlotScrolling:GetChildren()) do
		if slot:IsA("TextButton") then
			slot.Activated:Connect(function()
				confirmSound:Play()
				if slot.IsEmpty.Value == true then
					slot.Active = false
					for index, element in ipairs(slot:GetChildren()) do
						if element:IsA("BoolValue") then
							continue
						elseif element.Name == "EmptySlotTextLabel" then
							element.Visible = false
						else
							element.Visible = true
						end	
					end 
				else
					print("Game start")
				end
			end)
			
			slot.SlotName.TextBox.FocusLost:Connect(function()
				slot.IsEmpty.Value = false
				slot.Active = true
				slot.SlotName.TextBox.Visible = false
				slot.SlotName.Text = slot.SlotName.TextBox.Text

				local successSlotUpdate = updateSlotData:InvokeServer("Name", slot.Name, slot.SlotName.Text)
			end) 
			
			slot.SlotName.Rename.Activated:Connect(function()
				slot.SlotName.TextBox.Visible = true
				slot.Active = false
				slot.SlotName.TextBox.Text = ""
				slot.SlotName.Text = ""
			end)
			
		end
	end
end)
