local tweenService = game:GetService("TweenService")

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(game.ReplicatedStorage.Shared.PopupText)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music

local uiButtonClickSound = menuSounds.UIButtonClick

local newSlotNamer = lobbyMenuStorage.UIElements.NewSlotNamer
local newSlotNamerClone = newSlotNamer:Clone()
newSlotNamerClone.Parent = lobbyGUI

uiButtonClickSound:Play()

newSlotNamerClone.TextBox.FocusLost:Connect(function() 
	local slotName = newSlotNamerClone.TextBox.Text
	local newSlotNameRemote = lobbyMenuStorage.Remotes.NewSlotName
	local result = newSlotNameRemote:InvokeServer(slotName)
	local function isFiltered(inputText, filteredText)
		return inputText ~= filteredText
	end
	if isFiltered(slotName, result) and result ~= "The Facility" then
		newSlotNamerClone.TextBox.Text = result
		task.spawn(function()
			textPopUpModule.popUpText(game.Players.LocalPlayer, "Name was filtered")
		end)
	else
		task.spawn(function()
			textPopUpModule.popUpText(game.Players.LocalPlayer, 'Saved slot name as "'..result..'"')
		end)
		uiButtonClickSound:Play()
		newSlotNamerClone:Destroy()
		script:Destroy()
	end
end)

local module = {}

return module