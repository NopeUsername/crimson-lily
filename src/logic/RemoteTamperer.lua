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
			local shouldFire = true
			
			-- if any tamper funcs return false then it won't
			-- do a default FireServer
            for _, tamperData in ipairs(TamperedRemotes[self]) do
                local ok, data = pcall(tamperData.Func, self, args, oldNamecall)
                if not ok then warn(data) end
				
				if data == false then
					shouldFire = false
				end
            end
			
			if shouldFire then
				local fireServer = self.FireServer
				return fireServer(self, table.unpack(args))
			else
				return nil
			end
        end
    end

    return oldNamecall(self, ...)
end)

ODYSSEY.MetaHooks[oldNamecall] = {
    Object = game,
    Method = "__namecall"
}
ODYSSEY.Maid:GiveTask(function()
	table.clear(TamperedRemotes)
	table.clear(BlacklistedRemotes)
end)

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