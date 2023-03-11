local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Gameplay = {}
ODYSSEY.Data.Gameplay = Gameplay

function GetServers(placeId, limit)
    local servers = {}
    local cursor = nil

    ODYSSEY.SendNotification(nil, "Crimson Lily", string.format("Fetching %d servers, please wait.", limit), Color3.new(1, 1, 1))
    repeat
        local endpoint = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true",
            placeId
        )
        if cursor then
            endpoint ..= "&cursor=".. cursor
        end

        local resp = HttpService:JSONDecode(game:HttpGetAsync(endpoint))
        cursor = resp.nextPageCursor

        for _, server in ipairs(resp.data) do
            if not server.playing then continue end
            table.insert(servers, server)
        end

        if #servers >= limit then
            -- dont fetch more its gonna take forever lmao
            break
        end
    until cursor == nil

    return servers
end

function Gameplay.LoadSlot()
    local servers = GetServers(ODYSSEY.Data.SelectedSeaId, 200)
    local server = servers[math.random(1, #servers)]

    TeleportService:TeleportToPlaceInstance(
        ODYSSEY.Data.SelectedSeaId,
        server.id,
        nil,
        nil,
        tonumber(ODYSSEY.Data.SelectedSlot)
    )
end

function Gameplay.ServerHop()
    local data = GetServers(ODYSSEY.Data.SelectedSeaId, 200)
    table.sort(data, function(a, b)
        return a.playing < b.playing
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