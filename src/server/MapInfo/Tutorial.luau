--A list containing all possible encounters in Tutorial
local encounters = {
    --Name of Encounter
    ["Hostile Encounter"] = {
        --Rank in which the enemy spawns
        ["Enemies"] = {
            [1] = {
                --Enemy Name (to be spawned in another script)
                ["Enemy"] = "Builder",
            },
            [2] = {
                ["Enemy"] = "Builder",
            }
        },
        ["Passable"] = true
    },
    ["Passive Encounter"] = {
        [1] = {
            ["Enemy"] = "Builder",
        },
        [2] = {
            ["Enemy"] = "Builder",
        }
    },
}

local curios = {
    [""] = 1
}

return true