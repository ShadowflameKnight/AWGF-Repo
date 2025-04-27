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

----New Slot Naming Sequence----------------------------------
local isEmpty, completedTutorial = giveLobbyDataRemote.OnClientEvent:Wait()

for i, sound in ipairs(music:GetChildren()) do
	sound:Stop()
end
local music = game.SoundService.Music
music.Volume = 1

local blur = game.Lighting.Blur
blur.Enabled = false

local lobbyInitializer = require(game.StarterPlayer.StarterPlayerScripts.Client.Lobby.LobbyInitializer)
if isEmpty then
	lobbyInitializer.newSlot()
end

local startExpeditionRemote = lobbyMenuStorage.Remotes.StartExpeditionRemote
local startExpeditionBindable = lobbyMenuStorage.Remotes.StartExpeditionBindable
----Tutorial Sequence----------------------------------

if not completedTutorial then
	print("not completed tutorial")
	--Whenever i get to making the tutorial replace that code here
	
	startExpeditionRemote:FireServer("Tutorial")
	startExpeditionBindable:Fire("Tutorial")
	local gameplayClient = require(script.Parent.Parent.Gameplay.GameplayClient)
	gameplayClient.startGameplay("tutorial")
else
	print("script start 2")
	lobbyInitializer.initalizeLobby()

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
----------
