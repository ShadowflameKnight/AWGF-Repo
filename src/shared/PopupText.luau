local tweenService = game:GetService("TweenService")

local module = {}

--textType refers to whether it is a warning, neutral, etc
function module.popUpText(player, text, textType)
	local textPopupGUI = game.ReplicatedStorage.Misc.UIElements.TextPopupGUI
	local textPopupGUIClone = textPopupGUI:Clone()
	local textPopupFrame = textPopupGUIClone.TextPopupFrame
	
	local textPopupBackground = textPopupFrame.Background
	local textPopupText = textPopupFrame.TextLabel
	textPopupText.Text = text

	textPopupGUIClone.Parent = player.PlayerGui

	local tweenUp = tweenService:Create(textPopupFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0,0.9, 0)})
	tweenUp:Play()	
	local fadeInText = tweenService:Create(textPopupText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
	fadeInText:Play()	
	task.wait(3)

	local fadeOutText = tweenService:Create(textPopupText, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = 1})
	fadeOutText:Play()
	fadeOutText.Completed:Connect(function()
		textPopupGUIClone:Destroy()
	end)
end

return module