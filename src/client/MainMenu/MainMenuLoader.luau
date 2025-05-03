local replicatedStorage = game.ReplicatedStorage
local tweenService = game:GetService("TweenService")


local module = {}

local mainMenuRoom
local mainMenuRoomClone

function module.loadLobby()
    mainMenuRoom = replicatedStorage.MainMenuRoom
    mainMenuRoomClone = mainMenuRoom:Clone()
    mainMenuRoomClone.Parent = game.workspace

    local root = workspace.MainMenuRoom.Base.Crystal.Root

    local tweenInfo = TweenInfo.new(
        4, 
        Enum.EasingStyle.Sine, 
        Enum.EasingDirection.InOut,
        -1,
        true)
        local tweenPosition = {
        CFrame = root.CFrame + Vector3.new(0, 3, 0)
    }

    tweenService:Create(root, tweenInfo, tweenPosition):Play()
end

function module.closeMainMenu()
    mainMenuRoomClone:Destroy()
end

return module