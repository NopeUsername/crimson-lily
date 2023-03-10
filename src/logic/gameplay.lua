local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Gameplay = {}
ODYSSEY.Data.Gameplay = Gameplay

function Gameplay.LoadSlot()
    TeleportService:Teleport(ODYSSEY.Data.SelectedSeaId, nil, tonumber(ODYSSEY.Data.SelectedSlot))
end

function Gameplay.ServerHop()
    local endpoint = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true",
        ODYSSEY.Data.SelectedSeaId
    )
    local resp = game:HttpGetAsync(endpoint)
    local data = HttpService:JSONDecode(resp).data

    table.sort(data, function(a, b)
        if not a.playing or not b.playing then return false end
        return a.playing > b.playing
    end)
    if not data[1] then
        ODYSSEY.SendNotification(nil, "Crimson Lily", "Couldn't find any server.", Color3.new(1, 0, 0))
        return
    end

    TeleportService:TeleportToPlaceInstance(
        ODYSSEY.Data.SelectedSeaId,
        data[1].id,
        nil,
        nil,
        tonumber(ODYSSEY.Data.SelectedSlot)
    )
end