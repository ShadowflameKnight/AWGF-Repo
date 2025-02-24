local module = {}

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


function module.initalizeLobby()
	----Lobby button Initalization----------------------------------
	local playButton = lobbyMenuStorage.UIElements.Play
	local loadoutButton = lobbyMenuStorage.UIElements.Loadout
	local settingsButton = lobbyMenuStorage.UIElements.Settings

	local playButtonClone = playButton:Clone()
	playButtonClone.Parent = lobbyGUI

	local loadoutButtonClone = loadoutButton:Clone()
	loadoutButton.Parent = lobbyGUI

	local settingsButtonClone = settingsButton:Clone()
	settingsButton.Parent = lobbyGUI

	
	----Lobby Visuals after initialization completed----------------------------------

	lightingConfig.changeLighting("lobby")
	local blackscreenClone = lobbyGUI:FindFirstChild("BlackScreen")
	local tweenBlackscreen = tweenService:Create(blackscreenClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0)})
	tweenBlackscreen:Play()	

	local loadingScreenWoosh = menuSounds.LoadingScreenWoosh
	loadingScreenWoosh:Play()

	local waitForWoosh 
	waitForWoosh = loadingScreenWoosh.Ended:Connect(function()
		music.LobbyMusic:Play()
		blackscreenClone:Destroy()
		waitForWoosh:Disconnect()
	end)
end

function module.closeLobby()
	lobbyGUI.Enabled = false
end


return module