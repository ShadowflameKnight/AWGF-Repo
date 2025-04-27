local Lighting = game:GetService("Lighting")
local module = {
    ---lobby and main menu lighting
    MainMenu = {
        Lighting = {
            Ambient = Color3.fromRGB(0,0,0),
            Brightness = 0,
            ShadowSoftness = 0,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ClockTime = 0,
        },
       Atmosphere = {
            Color = Color3.fromRGB(0,0,0),
            Decay = Color3.fromRGB(0,0,0),
       },
       Blur = {
        Enabled = false
       },
    },
    Lobby = {
        Lighting = {
            Ambient = Color3.fromRGB(0,0,0),
            Brightness = 0,
            ShadowSoftness = 0,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ClockTime = 0,
        },
       Atmosphere = {
            Color = Color3.fromRGB(0,0,0),
            Decay = Color3.fromRGB(0,0,0),
       },
       Blur = {
        Enabled = false
       },
    },

    Rebirth = {
        Lighting = {
            Ambient = Color3.fromRGB(0,0,0),
            Brightness = 0,
            ShadowSoftness = 0,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ClockTime = 0,
        },
       Atmosphere = {
            Color = Color3.fromRGB(0,0,0),
            Decay = Color3.fromRGB(0,0,0),
       },
       Blur = {
        Enabled = false
       },
    },

    ---Lighting for stages and maps during gameplay
    Tutorial = {
        Lighting = {
            Ambient = Color3.fromRGB(30,30,30),
            Brightness = 3,
            ShadowSoftness = 0.2,
            OutdoorAmbient = Color3.fromRGB(30,30,30),
            ClockTime = 0,
        },
       Atmosphere = {
            Color = Color3.fromRGB(30,30,30),
            Decay = Color3.fromRGB(30,30,30),
       },
       Blur = {
        Enabled = false
       },
    },
}

function module.changeLighting(lightingLocation)
    local location = module[lightingLocation]
    print(location)
    for property, value in pairs(location.Lighting) do
        Lighting[property] = value
    end
	for lightingEffect, effectProperties in pairs(location) do
		if lightingEffect == "Lighting" then continue end
		for property, value in pairs(effectProperties) do
            Lighting:FindFirstChild(lightingEffect)[property] = value
        end
    end

    return
end 

return module