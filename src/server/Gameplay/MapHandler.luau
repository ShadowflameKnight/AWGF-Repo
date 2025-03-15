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
            roomInstance.EventTrigger:Destroy()
        end
    end)
end

local roomSinceLastEncounter = 0

--Keyword is the event name. Its number associated with it is the % chance it has of happening.
local eventList = {
    ["Encounter"] = 50,
    ["Curio"]  = 30,
    [""] = 0
}
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

    --Determine whether the room has an event in it. Then, determine the event.
    local roomEvent = ""
    print(roomSinceLastEncounter <= 2)
    if roomSinceLastEncounter <= 2 then
        local randomNumber = math.random(1,100)
        local counter = 0
        for event, weight in eventList do
            counter += weight
            if randomNumber <= counter then
                roomEvent = event
                randomRoom.Event.Value = roomEvent
                
                if roomEvent ~= "Encounter" then
                    roomSinceLastEncounter += 1
                else
                    roomSinceLastEncounter = 0
                end

                break
            end
        end
    else 
        roomEvent = "Encounter"
        roomSinceLastEncounter = 0
    end

    
    if roomEvent == "" then
        randomRoom.EventTrigger:Destroy()
    end

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
    print(mapLayout)
    --Apply functionality to rooms after they have loaded
    for i, roomInstance in mapLayout do
        exitPrompt(roomInstance)
        if roomInstance:FindFirstChild("EventTrigger") then
            travelingEvent(roomInstance)
        end
        
    end
end

return rooms