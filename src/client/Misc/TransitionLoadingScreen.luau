local tweenService = game:GetService("TweenService")

local playerGUI = game.Players.LocalPlayer.PlayerGui

local miscUIElements = game.ReplicatedStorage.Misc.UIElements
local transitionLoadingScreen = miscUIElements.TransitionLoadingScreen

local module = {}

local transitionLoadingClone

function module.CreateTransition()
    transitionLoadingClone = transitionLoadingScreen:Clone()
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
    tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0, 0)}):Play()
    
end

function module.DestroyTransition()
    local tween = tweenService:Create(transitionLoadingClone, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1, 0)}):Play()
    tween.completed:Wait()
    transitionLoadingClone:Destroy()
end

return module