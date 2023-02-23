local RemoteTamperer = {}

local TamperedRemotes = {}
local BlacklistedRemotes = {}

-- hook game
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if checkcaller() then
        return oldNamecall(self, ...)
    end

    local args = {...}
    local method = getnamecallmethod()

    if (self.ClassName == "RemoteEvent") and (method == "FireServer") then
        if BlacklistedRemotes[self] then
            return nil
        end

        if TamperedRemotes[self] then
            for _, tamperData in ipairs(TamperedRemotes[self]) do
                local ok, err = pcall(tamperData.Func, self, args, oldNamecall)
                if not ok then warn(err) end
            end

            local fireServer = self.FireServer
            return fireServer(self, table.unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)

ODYSSEY.MetaHooks[oldNamecall] = {
    Object = game,
    Method = "__namecall"
}

-- API
function RemoteTamperer.TamperRemotes(remotes, priority, tamperFunc)
    for _, remote in ipairs(remotes) do
        local tamperData = TamperedRemotes[remote] or {}

        table.insert(tamperData, {
            Priority = priority,
            Func = tamperFunc
        })
       
        table.sort(tamperData, function(a, b)
            return a.Priority < b.Priority
        end)

        TamperedRemotes[remote] = tamperData
    end
end

function RemoteTamperer.BlacklistRemotes(remotes)
    for _, remote in ipairs(remotes) do
        BlacklistedRemotes[remote] = true
    end
end

function RemoteTamperer.UntamperRemotes(remotes)
    for _, remote in ipairs(remotes) do
        TamperedRemotes[remote] = nil
    end
end

function RemoteTamperer.UnblacklistRemotes(remotes)
    for _, remote in ipairs(remotes) do
        BlacklistedRemotes[remote] = nil
    end
end

return RemoteTamperer