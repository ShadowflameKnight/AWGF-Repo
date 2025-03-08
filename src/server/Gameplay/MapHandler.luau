local Workspace = game:GetService("Workspace")
local mapsFolder = game.ServerStorage.Maps

local rooms = {}

function rooms.determineNewRoom(prevRoom, map)
    --Look for the possible rooms that are in the generation pool
    local possibleRooms = mapsFolder[map].PossibleRooms:GetChildren()
	local randomRoom = possibleRooms[math.random(1,2)]:Clone()

    --Root the room onto the previous room's exit part
    randomRoom.PrimaryPart = randomRoom.Entrance
	randomRoom:PivotTo(prevRoom.Exit.CFrame)
	randomRoom.Parent = Workspace

    --Return the previous room so that it may be saved
    return randomRoom
end

function rooms.loadMap(map)
    --Generate starting room
    local starterRoom = mapsFolder[map].StartingRoom:Clone()
    starterRoom.Parent = Workspace

	---Keeping track of previous room, starting with the starter room
	local prevRoom = starterRoom
    for i = 1, 20 do
        --Changing and saving the starting room with a variable. Then, passing the starter room to the function that determines the new room
       prevRoom = rooms.determineNewRoom(prevRoom, map)
    end
        

end

return rooms