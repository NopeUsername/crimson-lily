local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UnloadedBoats = ReplicatedStorage.RS.UnloadBoats

--
local ESP = load("src/lib/ESP.lua")
ESP.Enabled = true

ODYSSEY.Maid:GiveTask(function()
    for _, object in pairs(ESP.Objects) do
        object:Remove()
    end
end)

ESP.Overrides.UpdateAllow = function(self)
    if self.Player then
        return ODYSSEY.Data.PlayerESP
    end

    if self.Object.Parent == UnloadedBoats or self.Object.Parent == workspace.Boats then
        return ODYSSEY.Data.ShipESP
    end

    return true
end

--
local function TrackBoat(boat)
    if ESP:GetBox(boat) then return end
    ESP:Add(boat, {
        Color = Color3.fromRGB(66, 147, 245)
    })
end

ODYSSEY.Maid:GiveTask(workspace.Boats.ChildAdded:Connect(TrackBoat))
ODYSSEY.Maid:GiveTask(UnloadedBoats.ChildAdded:Connect(TrackBoat))

for _, c in ipairs(workspace.Boats:GetChildren()) do
    TrackBoat(c)
end
for _, c in ipairs(UnloadedBoats:GetChildren()) do
    TrackBoat(c)
end