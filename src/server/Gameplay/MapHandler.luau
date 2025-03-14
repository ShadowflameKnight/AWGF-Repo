local Workspace = game:GetService("Workspace")
local mapsFolder = game.ServerStorage.Maps

local rooms = {}

local mapLayout = {}

function rooms.determineNewRoom(prevRoom, map, horizontalDirection, verticleDirection)
    --Look for the possible rooms that are in the generation pool
    local possibleRooms = mapsFolder[map].PossibleRooms:GetChildren()
	local randomRoom = possibleRooms[math.random(1,#possibleRooms)]:Clone()

    --Ensure the rooms aren't generating in such a way where it could potentially be pointing backwards
    repeat 
        randomRoom = possibleRooms[math.random(1,#possibleRooms)]:Clone() 
    until 
        --1 value = 90 degrees in the main direction. Main direction for horizontal is right, and up for verticle.
        randomRoom.HorizontalDirection.Value + horizontalDirection <= 1 and randomRoom.HorizontalDirection.Value + horizontalDirection >= -1 and randomRoom.VerticleDirection.Value + verticleDirection <= 1 and randomRoom.VerticleDirection.Value + verticleDirection >= -1

    horizontalDirection += randomRoom.HorizontalDirection.Value
    verticleDirection += randomRoom.VerticleDirection.Value

    --Root the room onto the previous room's exit part
    randomRoom.PrimaryPart = randomRoom.Entrance
	randomRoom:PivotTo(prevRoom.Exit.CFrame)
	randomRoom.Parent = Workspace

    --Return the previous room so that it may be saved
    table.insert(mapLayout, randomRoom)
    return randomRoom, horizontalDirection, verticleDirection
end

function rooms.loadMap(map)
    --Generate starting room
    local starterRoom = mapsFolder[map].StartingRoom:Clone()
    starterRoom.Parent = Workspace

	---Keeping track of previous room, starting with the starter room
	local prevRoom = starterRoom
    local horizontalDirection = 0
    local verticleDirection = 0
    for i = 1, 20 do
        --Changing and saving the starting room with a variable. Then, passing the starter room to the function that determines the new room
       prevRoom, horizontalDirection, verticleDirection = rooms.determineNewRoom(prevRoom, map, horizontalDirection, verticleDirection)
    end
end

return rooms