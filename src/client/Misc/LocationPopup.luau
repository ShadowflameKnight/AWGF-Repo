local tweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local playerGUI = player.PlayerGui
local miscGUI = playerGUI.MiscGUI

local replicatedStorage = game:GetService("ReplicatedStorage")
local locationFrame = replicatedStorage.Misc.UIElements.LocationFrame

local locations = 
{
    ["The Crystal"] ={
        ["Description"] = "..."
    }
}

function locations.displayLocation(location)
    --Destroy the previous location frame if present. Ensures theres no overlap.
    for i, previousLocationFrame in ipairs(miscGUI:GetChildren()) do
        if previousLocationFrame.Name == "LocationFrame" then
            previousLocationFrame:Destroy()
        end
    end

    local locationFrameClone = locationFrame:Clone()
    local frameBar = locationFrameClone.Frame
    local locationName = locationFrameClone.Location
    local locationDescription = locationFrameClone.Description
    local loadingSpinner = locationFrameClone.LoadingSpinner
    local background = locationFrameClone.background

    local spinnerSpinning = coroutine.create(function()
        while true do
            loadingSpinner.Rotation += 1
            task.wait()
        end 
    end)
    coroutine.resume(spinnerSpinning)

    frameBar.Size = UDim2.new(0,0,0,1)
    locationName.Position = UDim2.fromScale(0.5, 1)
    locationDescription.Position = UDim2.fromScale(0.5, 1)
    background.Transparency = 1

    locationFrameClone.Parent = playerGUI.MiscGUI
    
    --Tween in
    local barSizeTween = tweenService:Create(frameBar, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 1)})
    barSizeTween:Play()
    local backgroundTween = tweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Transparency = 0})
    backgroundTween:Play()
    backgroundTween.Completed:Wait()
    local locationNameTween = tweenService:Create(locationName, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,0,0,0)})
    locationNameTween:Play()
    locationNameTween.Completed:Wait()
    local locationDescriptionTween = tweenService:Create(locationDescription, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,0,0.4,0)})
    locationDescriptionTween:Play()
    locationDescriptionTween.Completed:Wait()
    task.wait(5)

    --Tween out
    local locationNameTween = tweenService:Create(locationName, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1})
    locationNameTween:Play()
    local locationDescriptionTween = tweenService:Create(locationDescription, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1})
    locationDescriptionTween:Play()
    local barSizeTween = tweenService:Create(frameBar, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 1)})
    barSizeTween:Play()
    barSizeTween.Completed:Wait()
    local backgroundTween = tweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Transparency = 1})
    backgroundTween:Play()
    backgroundTween.Completed:Wait()
    local loadingSpinnerTween = tweenService:Create(loadingSpinner, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {ImageTransparency = 1})
    loadingSpinnerTween:Play()
    loadingSpinnerTween.Completed:Wait()
   
    locationFrameClone:Destroy()
end

return locations