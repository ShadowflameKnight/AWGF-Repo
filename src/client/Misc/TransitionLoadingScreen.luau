local tweenService = game:GetService("TweenService")

local soundService = game:GetService("SoundService")
local woosh = soundService.MenuSounds.LoadingScreenWoosh

local playerGUI = game.Players.LocalPlayer.PlayerGui
local camera = game.Workspace.Camera

local miscUIElements = game.ReplicatedStorage.Misc.UIElements
local transitionLoadingScreen = miscUIElements.TransitionLoadingScreen

local miscGUI = playerGUI.MiscGUI

local module = {}

function module.CreateTransition()
    local transitionLoadingClone = transitionLoadingScreen:Clone()
    transitionLoadingClone.Transparency = 1
    local loadingSpinner = transitionLoadingClone.LoadingSpinner
    local loadingtext = transitionLoadingClone.LoadingText

    local spinnerSpinning = coroutine.create(function()
        while true do
            loadingSpinner.Rotation += 1
            task.wait()
        end 
    end)
    coroutine.resume(spinnerSpinning)

    local loadingDotDotDot = coroutine.create(function()
        while true do
            loadingtext.Text = "Loading..."
            task.wait(1)
            loadingtext.Text = "Loading."
            task.wait(1)
            loadingtext.Text = "Loading.."
            task.wait(1)
        end 
    end)
    coroutine.resume(loadingDotDotDot)

    transitionLoadingClone.Parent = playerGUI.MiscGUI
    local fovTween = tweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {FieldOfView = 30})
    fovTween:Play()
    local transparencyTween = tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0})
    transparencyTween:Play()
    transparencyTween.completed:Wait()
end

function module.DestroyTransition()
    local transitionLoadingClone = miscGUI:FindFirstChild("TransitionLoadingScreen")
    if transitionLoadingClone == nil then return end
    for i, v in ipairs(transitionLoadingClone:GetChildren()) do
        v:Destroy()
    end

    local fovTween = tweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {FieldOfView = 70})
    fovTween:Play()
    local transparencyTween = tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 1})
    transparencyTween:Play()
    woosh:Play()
    transparencyTween.completed:Wait()
    transitionLoadingClone:Destroy()
end

return module