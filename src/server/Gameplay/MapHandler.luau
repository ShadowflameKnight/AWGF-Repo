local Workspace = game:GetService("Workspace")
local mapsFolder = game.ServerStorage.Maps

local module = {}

function module.loadMap(map)
    --Generate starting room
    local starterRoom = mapsFolder[map].StartingRoom:Clone()
    starterRoom.Parent = Workspace

    --Generate first room and first room only
    local room1 = mapsFolder[map].StraightPath:Clone()
    room1.PrimaryPart = room1.Entrance
    room1:PivotTo(starterRoom.Exit.CFrame)
    room1.Parent = Workspace
end

return module