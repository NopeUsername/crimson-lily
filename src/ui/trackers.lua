return function(UILib, window)
    ODYSSEY.Data.ShipESP = true
    ODYSSEY.Data.PlayerESP = true

    local tab = window:NewTab("Trackers")

    --
    tab:NewToggle("Track ships", ODYSSEY.Data.ShipESP, function(value)
        ODYSSEY.Data.ShipESP = value
    end)
    tab:NewToggle("Track players", ODYSSEY.Data.PlayerESP, function(value)
        ODYSSEY.Data.PlayerESP = value
    end)
end