local StarterGui = game:GetService("StarterGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local travelingRemotes = game.ReplicatedStorage.Gameplay.Traveling.Remotes
local miscRemotes = replicatedStorage.Misc.Remotes

local workspace = game:GetService("workspace")
local mapsFolder = game.ServerStorage.Maps

local goToCharacterCreatorRemote = replicatedStorage.LobbyMenu.Remotes.GoToCharacterCreator
local teleportBackToSpawnBox = travelingRemotes.TeleportBackToSpawnBox
local changeLightingRemote = miscRemotes.ChangeLighting

local tweenService = game:GetService("TweenService")

local rooms = {}

local mapLayout = {}

local openDoorRemote = travelingRemotes.OpenDoor
local function exitPrompt(roomInstance)
    --Stores where in the room order the current room is in, so that it may open the door for the next room in the list
    local placeInMapLayout = table.find(mapLayout, roomInstance)

    local prompt = roomInstance.ExitWall.Door.ProxPart.ProximityPrompt

    prompt.Triggered:Connect(function()
        openDoorRemote:FireAllClients(mapLayout, roomInstance, placeInMapLayout)  
    end)
end

--For when the player triggers an event
local triggerEventRemote = travelingRemotes.TriggerEvent
local function travelingEvent(roomInstance)
    roomInstance.EventTrigger.Touched:Connect(function(basePart)
        local partParent = basePart.Parent
        local humanoid = partParent:FindFirstChild("Humanoid")

        if humanoid then
            roomInstance.EventTrigger:Destroy()
            -- Sent to GameplayClient
            triggerEventRemote:FireAllClients(roomInstance)
            
        end
    end)
end

--Keyword is the event name. Its number associated with it is the % chance it has of happening.
local eventList = {
    ["Encounter"] = 30,
    ["Curio"]  = 20,
    [""] = 50
}

local roomSinceLastEncounter = 0
function rooms.determineNewRoom(prevRoom, map, horizontalDirection, verticleDirection)
    --Look for the possible rooms that are in the generation pool
    local possibleRooms = mapsFolder[map].PossibleRooms:GetChildren()
	local randomRoom = possibleRooms[math.random(1,#possibleRooms)]:Clone()

    --Determine whether the room has an event in it. Then, determine the event.
    local roomEvent = ""
    if roomSinceLastEncounter < 5 then
        local randomNumber = math.random(1, 100)
        local counter = 0
        for event, weight in eventList do
            counter += weight
            if randomNumber <= counter then
                if roomSinceLastEncounter == 0 then roomSinceLastEncounter += 1 continue end --Ensures that the player doesn't do 2 encounters in a row.

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
	randomRoom.Parent = workspace

    --Return the previous room so that it may be saved
    table.insert(mapLayout, randomRoom)
    return randomRoom, horizontalDirection, verticleDirection
end

function rooms.loadMap(map)
    --Generate starting room
    local starterRoom = mapsFolder[map].StartingRoom:Clone()
    table.insert(mapLayout, starterRoom)


    starterRoom.Parent = workspace

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

function rooms.loadCrystal()
    print("Crystal")
    changeLightingRemote:FireAllClients("Crystal")
    local startingRoomClone = mapsFolder.Crystal.StartingRoom:Clone()
    startingRoomClone.Parent = workspace
    workspace:WaitForChild(startingRoomClone)

    local prompt = startingRoomClone.ProximityPart.ProximityPrompt
    prompt.Triggered:Connect(function(player)
        goToCharacterCreatorRemote:FireClient(player)
        task.wait(1) --Waiting for the loading screen to kick in
        teleportBackToSpawnBox:FireClient(player)
        startingRoomClone:Destroy()
    end)
end

function rooms.loadLobby()
    
    print("lobby")
    local startingRoomClone = mapsFolder.Lobby.StartingRoom:Clone()
    startingRoomClone.Parent = workspace
    workspace:WaitForChild(startingRoomClone)

end

return rooms