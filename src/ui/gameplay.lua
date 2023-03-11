local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Basic = require(ReplicatedStorage.RS.Modules.Basic)

local bin = ODYSSEY.GetLocalPlayer():WaitForChild("bin")

--
local seaNames = {}
local seaNameToIds = {}

for seaId, seaName in pairs(Basic.MainUniverse) do
    table.insert(seaNames, seaName)
    seaNameToIds[seaName] = seaId
end

ODYSSEY.InitData("SelectedSeaId", seaNameToIds["The Bronze Sea"])
ODYSSEY.InitData("SelectedSlot", bin:WaitForChild("File").Value)
ODYSSEY.InitData("ForceLoad", true)

return function(UILib, window)
    local tab = window:NewTab("Gameplay")

    tab:NewSection("Region")
    tab:NewToggle("Force load around yourself", ODYSSEY.Data.ForceLoad, function(value)
        ODYSSEY.Data.ForceLoad = value
    end)

    tab:NewSection("Load slots (also unban)")
    tab:NewSelector("Sea", Basic.MainUniverse[ODYSSEY.Data.SelectedSeaId], seaNames, function(value)
        ODYSSEY.Data.SelectedSeaId = seaNameToIds[value]
    end)

    tab:NewSelector("Slot", ODYSSEY.Data.SelectedSlot, {"1", "2", "3", "4", "5", "6"}, function(value)
        ODYSSEY.Data.SelectedSlot = value
    end)
    
    tab:NewButton("Join random server", function()
        ODYSSEY.Gameplay.LoadSlot()
    end)
    tab:NewButton("Join empty server", function()
        ODYSSEY.Gameplay.ServerHop()
    end)
    tab:NewButton("Rejoin", function()
        ODYSSEY.Gameplay.Rejoin()
    end)
end