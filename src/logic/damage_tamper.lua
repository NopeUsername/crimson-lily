local RemoteTamperer = ODYSSEY.RemoteTamperer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local toBlacklist = {}
local toIntercept = {}

for _, remote in ipairs(ReplicatedStorage.RS.Remotes:GetDescendants()) do
	local name = remote.Name
	
	if string.match(name, "Take") and string.match(name, "Damage") then
		table.insert(toBlacklist, remote)
	end
	if string.match(name, "Deal") and string.match(name, "Damage") then
		table.insert(toIntercept, remote)
	end
	
	if name == "TouchDamage" then
		table.insert(toBlacklist, remote)
	end
end


RemoteTamperer.TamperRemotes(toBlacklist, 99, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageReflect then
		return false
	end
end)

RemoteTamperer.TamperRemotes(toIntercept, 1, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageReflect then
		-- idk why vetex loves putting random ass vars in remotes
		local modelTypes = {}
		for idx, arg in pairs(args) do
			if typeof(arg) == "Instance" and arg:IsA("Model") then
				table.insert(modelTypes, {Index = idx, Value = arg})
			end
		end
		
		local dealer, receiver = modelTypes[1], modelTypes[2]
		
		if receiver.Value == ODYSSEY.GetLocalCharacter() then
			args[dealer.Index] = receiver.Value
			args[receiver.Index] = dealer.Value
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