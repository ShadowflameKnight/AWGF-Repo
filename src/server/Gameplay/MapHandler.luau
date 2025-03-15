local replicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local mapsFolder = game.ServerStorage.Maps

local tweenService = game:GetService("TweenService")

local rooms = {}

local mapLayout = {}

local openDoorRemote = game.ReplicatedStorage.Gameplay.Traveling.OpenDoor
local function exitPrompt(roomInstance)
    --Stores where in the room order the current room is in, so that it may open the door for the next room in the list
    local placeInMapLayout = table.find(mapLayout, roomInstance)

    local prompt = roomInstance.ExitWall.Door.ProxPart.ProximityPrompt

    prompt.Triggered:Connect(function()
        openDoorRemote:FireAllClients(mapLayout, roomInstance, placeInMapLayout)  
    end)
end

local triggerEventRemote = replicatedStorage.Gameplay.Traveling.TriggerEvent
local function travelingEvent(roomInstance)
    roomInstance.EventTrigger.Touched:Connect(function(basePart)
        local partParent = basePart.Parent
        local humanoid = partParent:FindFirstChild("Humanoid")

        if humanoid then
            triggerEventRemote:FireAllClients(roomInstance)
        end
    end)
end

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
    table.insert(mapLayout, starterRoom)


    starterRoom.Parent = Workspace

	---Keeping track of previous room, starting with the starter room
	local prevRoom = starterRoom
    local horizontalDirection = 0
    local verticleDirection = 0
    for i = 1, 20 do
        --Changing and saving the starting room with a variable. Then, passing the starter room to the function that determines the new room
       prevRoom, horizontalDirection, verticleDirection = rooms.determineNewRoom(prevRoom, map, horizontalDirection, verticleDirection)
    end
    for i, roomInstance in mapLayout do
        exitPrompt(roomInstance)
        if roomInstance:FindFirstChild("EventTrigger") then
            travelingEvent(roomInstance)
        end
        
    end
end

return rooms