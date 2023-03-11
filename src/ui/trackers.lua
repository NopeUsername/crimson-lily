return function(UILib, window)
    ODYSSEY.InitData("ShipESP", true)
    ODYSSEY.InitData("UnloadedShipESP", false)
    ODYSSEY.InitData("PlayerESP", true)
    
    local tab = window:NewTab("Trackers")

    -- ship esp
    tab:NewSection("Ship ESP")
    tab:NewToggle("Track ships", ODYSSEY.Data.ShipESP, function(value)
        ODYSSEY.Data.ShipESP = value
    end)
    tab:NewToggle("Track unloaded ships", ODYSSEY.Data.UnloadedShipESP, function(value)
        ODYSSEY.Data.UnloadedShipESP = value
    end)

    -- player esp
    tab:NewSection("Player ESP")
    tab:NewToggle("Track players", ODYSSEY.Data.PlayerESP, function(value)
        ODYSSEY.Data.PlayerESP = value
    end)

    -- island esp
    tab:NewSection("Islands ESP")
    for _, region in ipairs(ODYSSEY.Teleports.Regions) do
        local configName = string.format("Region%sESP", region.Name)

        ODYSSEY.InitData(configName, false)
        ODYSSEY.Track.UpdateIslandsESP(region)

        tab:NewToggle(region.Name, ODYSSEY.Data[configName], function(value)
            ODYSSEY.Data[configName] = value
        end)
    end
end