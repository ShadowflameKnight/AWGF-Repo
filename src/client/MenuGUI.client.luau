local playerGUI = game.Players.LocalPlayer.PlayerGui

local GuiService = game:GetService("GuiService") 
GuiService.TouchControlsEnabled = false
local tweenService = game:GetService("TweenService")

local menuGUI = playerGUI:WaitForChild("MenuGUI")
menuGUI.Enabled = true

local mainMenuStorage = game.ReplicatedStorage.MainMenu

local miscStorage = game.ReplicatedStorage.Misc
local miniLoadingScreen = miscStorage.UIElements.MiniLoadingScreenGUI

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

local miscGUI = playerGUI.MiscGUI
local blackscreen = game.ReplicatedStorage.Misc.UIElements.BlackScreen


local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)

local function gameStart(slotNumber)
	confirmSound:Play()
	
	local blackscreenClone = blackscreen:Clone()
	blackscreenClone.Transparency = 1
	blackscreenClone.Parent = miscGUI
	local tweenBlackscreen = tweenService:Create(blackscreenClone, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Transparency = 0})
	tweenBlackscreen:Play()	
	
	local tweenMusic = tweenService:Create(game.SoundService.Music, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Volume = 0})
	tweenMusic:Play()
	
	textPopUpModule.popUpText(game.Players.LocalPlayer, "Game Start")
	
	local gameStartRemote = mainMenuStorage.Remotes.GameStart
	gameStartRemote:InvokeServer(slotNumber)

	local menuGUI = playerGUI:FindFirstChild("MenuGUI")
	if not menuGUI then
		local player = game.Players.LocalPlayer
		player:Kick("Failed to initialize your save slot, please try again.")
	else
		menuGUI:Destroy()		
	end
end

giveSlotsAmount.OnClientEvent:Connect(function(slotsOwned)
	for i = 1, slotsOwned do
		local slotClone = saveSlot:Clone()
		slotClone.LayoutOrder = i
		slotClone.Name = tostring(i)
		slotClone.Parent = saveSlotScrolling
		
		local fetchSlotInformation = mainMenuStorage.Remotes.FetchSlotInformation
		local mainMenuData = fetchSlotInformation:InvokeServer(i)
		
		--If there is data on this slot number's profile, display all relevant information on the slot
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
	
	--adds functionality to every slot
	for i, slot in ipairs(saveSlotScrolling:GetChildren()) do
		if slot:IsA("TextButton") then
			--if clicked
			slot.Activated:Connect(function()
				--[[

				--if empty
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
					]]
				gameStart(slot.Name)
			end)
			
			slot.SlotName.TextBox.FocusLost:Connect(function()		
				local miniLoadingClone = miniLoadingScreen:Clone()
				miniLoadingClone.Parent = menuGUI
				
				local checkSlotName = mainMenuStorage.Remotes.CheckSlotName
				--Prematurly end the renaming process if the name is blank
				local errorMessage = checkSlotName:InvokeServer(slot.SlotName.TextBox.Text, slot.Name) 
				if errorMessage then
					task.spawn(function()
						textPopUpModule.popUpText(game.Players.LocalPlayer, errorMessage)
					end)
				else
					slot.IsEmpty.Value = false
					slot.Active = true
					slot.SlotName.TextBox.Visible = false
					slot.SlotName.Text = slot.SlotName.TextBox.Text

					local successSlotUpdate = updateSlotData:InvokeServer("Name", slot.Name, slot.SlotName.Text)
				end
				miniLoadingClone:Destroy()
				confirmSound:Play()
			end) 
			
			slot.SlotName.Rename.Activated:Connect(function()
				slot.SlotName.TextBox.Visible = true
				slot.Active = false
				slot.SlotName.TextBox.Text = ""
				slot.SlotName.Text = ""
			end)
			
			slot.DeleteButton.Activated:Connect(function()
				confirmSound:Play()
				local deleteSlotPrompt = mainMenuStorage.UIElements.DeleteSlotPromptGUI
				local deletePromptClone = deleteSlotPrompt:Clone()
				deletePromptClone.Frame.Description.Text = "Deleting a save slot is permanent and cannot be recovered. Are you absolutely sure that you want to delete this slot?<br /><br />Currently deleting: "..slot.SlotName.Text.."<br />Gameplay Time: 0:0:0" 
				deletePromptClone.Parent = menuGUI	
				deletePromptClone.Frame.CloseButton.Activated:Connect(function()
					deletePromptClone:Destroy()
				end)
				deletePromptClone.Frame.ConfirmButton.Activated:Connect(function()
					deletePromptClone:Destroy()
					local miniLoadingClone = miniLoadingScreen:Clone()
					miniLoadingClone.Parent = menuGUI
					local successSlotUpdate = updateSlotData:InvokeServer("Delete", slot.Name)
					
					
					if successSlotUpdate then 
						slot.SlotName.Text = ""
						slot.GameplayTime.Text = "Gameplay Time: 0:0:0"
						slot.IsEmpty.Value = true
						slot.Active = true
						for _, element in ipairs(slot:GetChildren()) do
							if element:IsA("TextLabel") or element:IsA("TextButton") then
								if element.Name == "EmptySlotTextLabel" then
									element.Visible = true
								elseif element.Name == "SlotName" then
									element.TextBox.Visible = true
									element.Visible = false
								else
									element.Visible = false
								end
							end
						end
						miniLoadingClone:Destroy()						
					end
				end)
			end)
			
		end
	end
end)
