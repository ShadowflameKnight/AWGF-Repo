local module = {}

local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local replicatedStorage = game.ReplicatedStorage
local lobbyMenuStorage = replicatedStorage.LobbyMenu

local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")

local giveLobbyDataRemote = replicatedStorage.LobbyMenu.Remotes.GiveLobbyData

local textPopUpModule = require(player.PlayerScripts.Client.Misc.PopupText)

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music

local lightingConfig = require(game.StarterPlayer.StarterPlayerScripts.Client.Misc.LightingConfig)

function module.newSlot()
    local uiButtonClickSound = menuSounds.UIButtonClick

    local newSlotNamer = lobbyMenuStorage.UIElements.NewSlotNamer
    local newSlotNamerClone = newSlotNamer:Clone()
    newSlotNamerClone.Parent = lobbyGUI
    
    uiButtonClickSound:Play()

	local done = false
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
			uiButtonClickSound:Play()
			newSlotNamerClone:Destroy()
			textPopUpModule.popUpText(game.Players.LocalPlayer, 'Saved slot name as "'..result..'"')
			done = true
		end
	end)
	repeat task.wait() until done == true
	return
end


return module