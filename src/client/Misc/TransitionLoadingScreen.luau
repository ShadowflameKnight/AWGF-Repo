local tweenService = game:GetService("TweenService")

local soundService = game:GetService("SoundService")
local woosh = soundService.MenuSounds.LoadingScreenWoosh

local playerGUI = game.Players.LocalPlayer.PlayerGui

local miscUIElements = game.ReplicatedStorage.Misc.UIElements
local transitionLoadingScreen = miscUIElements.TransitionLoadingScreen

local miscGUI = playerGUI.MiscGUI

local module = {}

function module.CreateTransition()
    local transitionLoadingClone = transitionLoadingScreen:Clone()
    transitionLoadingClone.Position = UDim2.fromScale(-1, 0)
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
    local tween = tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0, 0)})
    tween:Play()
    tween.completed:Wait()
end

function module.DestroyTransition()
    local transitionLoadingClone = miscGUI:FindFirstChild("TransitionLoadingScreen")
    if transitionLoadingClone == nil then return end
    local tween = tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1, 0)})
    tween:Play()
    woosh:Play()
    tween.completed:Wait()
    transitionLoadingClone:Destroy()
end

return module