--[[
local crystal = workspace.Base.Crystal
local root = crystal.Root

for i, part in pairs(crystal:GetChildren()) do
	if part:IsA("BasePart") and (part ~= root) then
		local weld = Instance.new("WeldConstraint", part)
		weld.Part0 = part
		weld.Part1 = root
	end
end
]]
local tweenService = game:GetService("TweenService")
local root = workspace.MainMenuRoom.Base.Crystal.Root

tweenInfo = TweenInfo.new(
	4, 
	Enum.EasingStyle.Sine, 
	Enum.EasingDirection.InOut,
	-1,
	true)
tweenPosition = {
	CFrame = root.CFrame + Vector3.new(0, 3, 0)}

tweenService:Create(root, tweenInfo, tweenPosition):Play()
