local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UnloadedBoats = ReplicatedStorage.RS.UnloadBoats
local UnloadedBoats2 = ReplicatedStorage.RS.UnloadNPCShips

local BoatsModule = require(ReplicatedStorage.RS.Modules.Boats)

local Track = {}
ODYSSEY.Track = Track

--
local ESP = load("src/lib/ESP.lua")
ESP.Enabled = true

ODYSSEY.Maid:GiveTask(function()
    for _, object in pairs(ESP.Objects) do
        object:Remove()
    end
    ESP.Objects = {}
end)

ESP.Overrides.UpdateAllow = function(self)
    -- players
    if self.Player then
        return ODYSSEY.Data.PlayerESP
    end

    -- boats
    if self.Object:FindFirstChild("BoatHandler") then
        if not ODYSSEY.Data.UnloadedShipESP then
            if self.Object.Parent ~= workspace.Boats then
                return false
            end
        end

        return ODYSSEY.Data.ShipESP
    end
   
    -- regions
    if self.RegionName then
        return ODYSSEY.Data[string.format("Region%sESP", self.RegionName)]
    end

    return true
end

--
local function TrackCharacter(character)
    if ESP:GetBox(character) then return end
    ESP:Add(character, {
        Player = Players:GetPlayerFromCharacter(character),
        RenderInNil = true
    })
end

local function TrackBoat(boat)
    if ESP:GetBox(boat) then return end

    local isNPC = boat:FindFirstChild("NPCShip") ~= nil
    local type = boat.Type.Value
    local equips = boat.Equips.Value

    local title, titleColor = BoatsModule.GetBoatTitle(type, equips)
    local data = title

    if title == "" then
        title = type
    end
    if isNPC then
        local faction = boat.NPCShip.Value
        data = string.format("%s %s", faction, title)
    else
        data = title
    end

    ESP:Add(boat, {
        Color = titleColor,
        Size = boat:GetExtentsSize(),
        Data = data,
        RenderInNil = true
    })
end

--
function Track.UpdateIslandsESP(region)
    local model = workspace.Map:FindFirstChild(region.Name)
    local box = ESP:GetBox(model)

    if not box then
        box = ESP:Add(model.Center, {
            Color = Color3.fromRGB(76, 42, 135),
            RenderInNil = true,
            Name = "",
            Size = Vector3.new(1, 1, 1),
            Data = region.Name
        })
        box.RegionName = region.Name
    end
end

--
ODYSSEY.Timer(1, function()
    -- players
    for _, player in ipairs(Players:GetPlayers()) do
        if not player.Character then continue end
        if player == ODYSSEY.GetLocalPlayer() then continue end

        TrackCharacter(player.Character)
    end

    -- botes
    for _, boat in ipairs(workspace.Boats:GetChildren()) do
        TrackBoat(boat)
    end

    for _, boat in ipairs(UnloadedBoats:GetChildren()) do
        TrackBoat(boat)
    end

    for _, boat in ipairs(UnloadedBoats2:GetChildren()) do
        TrackBoat(boat)
    end
end)