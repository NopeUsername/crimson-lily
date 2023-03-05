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
		table.insert(toIntercept, remote)
	end
end


RemoteTamperer.TamperRemotes(toBlacklist, 99, function(remote, args, oldNamecall)
	if ODYSSEY.Data.DamageReflect or ODYSSEY.Data.DamageNull then
		return false
	end
end)

RemoteTamperer.TamperRemotes(toIntercept, 1, function(remote, args, oldNamecall)
	-- idk why vetex loves putting random ass vars in remotes
	local modelTypes = {}
	for idx, arg in pairs(args) do
		if typeof(arg) == "Instance" and arg:IsA("Model") then
			table.insert(modelTypes, {Index = idx, Value = arg})
		end
	end

	local dealer, receiver = modelTypes[1], modelTypes[2]

	-- damage reflect
	if ODYSSEY.Data.DamageReflect then
		if receiver.Value == ODYSSEY.GetLocalCharacter() then
			args[dealer.Index] = receiver.Value
			args[receiver.Index] = dealer.Value
		end
	else
		-- only nullify if we are being attacked
		if ODYSSEY.Data.DamageNull and args[dealer.Index] ~= ODYSSEY.GetLocalCharacter() then
			return false
		end
	end

	-- damage amp
	if ODYSSEY.Data.DamageAmp then
		local amount = ODYSSEY.Data.DamageAmpValue
		local fireServer = remote.FireServer

		if args[dealer.Index] ~= ODYSSEY.GetLocalCharacter() then
			amount = 1 -- don't amp if we are being attacked
		end
		
		for _ = 1, amount do
			-- TODO: Elementalist
			fireServer(remote, table.unpack(args))
		end
		
		return false
	end
end)