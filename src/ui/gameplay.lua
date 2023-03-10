local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Basic = require(ReplicatedStorage.RS.Modules.Basic)

--
local seaNames = {}
local seaNameToIds = {}

for seaId, seaName in pairs(Basic.MainUniverse) do
    table.insert(seaNames, seaName)
    seaNameToIds[seaName] = seaId
end

ODYSSEY.Data.SelectedSeaId = seaNameToIds["The Bronze Sea"]
ODYSSEY.Data.SelectedSlot = "1"
--

return function(UILib, window)
    local tab = window:NewTab("Gameplay")
    tab:NewSection("Load slots (also unban)")
    tab:NewSelector("Sea", "The Bronze Sea", seaNames, function(value)
        ODYSSEY.Data.SelectedSeaId = seaNameToIds[value]
    end)

    tab:NewSelector("Slot", ODYSSEY.Data.SelectedSlot, {"1", "2", "3", "4", "5", "6"}, function(value)
        ODYSSEY.Data.SelectedSlot = value
    end)
    
    tab:NewButton("Teleport", function()
        ODYSSEY.Data.Gameplay.LoadSlot()
    end)
    tab:NewButton("Server hop", function()
        ODYSSEY.Data.Gameplay.ServerHop()
    end)
end