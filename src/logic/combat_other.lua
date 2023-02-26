local RemoteTamperer = ODYSSEY.RemoteTamperer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage.RS.Remotes.Combat.StaminaCost

RemoteTamperer.TamperRemotes({remote}, 1, function(remote, args, oldNamecall)
	if ODYSSEY.Data.NoStamina then
		args[1] = 0
	end
end)