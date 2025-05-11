-- Script does the UI animations and functions in the event trigger menu, which appears when the player touches an event brick.

local tweenService = game:GetService("TweenService")

local replicatedStorage = game.ReplicatedStorage
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes

local soundService = game.SoundService
local menuSounds = soundService.MenuSounds
local music = soundService.Music
local menusSounds = soundService.MenuSounds
local soundEffects = soundService.SoundEffects


local playerGUI = game.Players.LocalPlayer.PlayerGui
local lobbyGUI = playerGUI:WaitForChild("LobbyGUI")
local miscGUI = playerGUI:WaitForChild("MiscGUI")
local gameplayGUI = playerGUI.GameplayGUI
local travelGUI = gameplayGUI.TravelGUI
local eventGUI = gameplayGUI.EventGUI

local triggerEventRemote = travelingRemotes.TriggerEvent
local eventSound = soundEffects.EventSound
local sprawlBattle = soundService.Music.SprawlBattle
local musicTween = tweenService:Create(sprawlBattle, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Volume = 0.5})
local backgroundFade = eventGUI.BackgroundFade
local effectDisplay = eventGUI.EffectDisplay
local backgroundFadeTween = tweenService:Create(backgroundFade, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3})
local effectDisplayTween = tweenService:Create(effectDisplay, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.8)})

local module = {}

function module.EventTriggered()
    print("event triggered")
    backgroundFade.BackgroundTransparency = 1
    effectDisplay.Position = UDim2.fromScale(0.5, 1)
    
    sprawlBattle.Volume = 0.25
    sprawlBattle:Play()

    eventSound:Play()
    
    -- Doing GUI stuff
    task.wait(2)

    for i, viewport in eventGUI:GetChildren() do
        if viewport:IsA("ViewportFrame") then
            viewport.ImageColor3 = Color3.fromRGB(0, 0, 0)
            viewport.Position = viewport.Position - UDim2.fromScale(0.2, 0)
            print(viewport.Position)
        end
    end
    travelGUI.Enabled = false
    eventGUI.Enabled = true

    musicTween:Play()
    backgroundFadeTween:Play()
    effectDisplayTween:Play()
    
    for i, viewport in eventGUI:GetChildren() do
        if viewport:IsA("ViewportFrame") then
            local tweenPosition = tweenService:Create(viewport, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = viewport.Position + UDim2.fromScale(0.2, 0)})
            tweenPosition:Play()
        end
    end

    task.wait(0.5)

    for i, viewport in eventGUI:GetChildren() do
        if viewport:IsA("ViewportFrame") then
            local tweenColor = tweenService:Create(viewport, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            tweenColor:Play()
        end
    end
end

return module