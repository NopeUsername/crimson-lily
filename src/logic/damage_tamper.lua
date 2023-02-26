local RemoteTamperer = ODYSSEY.RemoteTamperer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local toBlacklist = {}
local toIntercept = {}

for _, remote in ipairs(ReplicatedStorage.Remotes:GetDescendants()) do
	local name = remote.Name
	
	if string.match(name, "Take") and string.match(name, "Damage") then
		table.insert(toBlacklist, remote)
	end
	if string.match(name, "Deal") and string.match(name, "Damage") then
		table.insert(toIntercept, remote)
	end
end


RemoteTamperer.TamperRemotes(toBlacklist, 99, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageReflect then
		return false
	end
end)

RemoteTamperer.TamperRemotes(toIntercept, 1, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageReflect then
		local dealer, receiver = args[1], args[2]
		
		if receiver == ODYSSEY.GetLocalCharacter() then
			args[1] = receiver
			args[2] = dealer
		end
	end
end)

RemoteTamperer.TamperRemotes(toIntercept, 2, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageAmp then
		local amount = ODYSSEY.Data.DamageAmpValue
		local fireServer = remote.FireServer
		
		for _ = 1, amount do
			-- TODO: Elementalist
		
			fireServer(remote, table.unpack(args))
		end
		
		return false
	end
end)