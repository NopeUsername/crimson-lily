local RemoteTamperer = ODYSSEY.RemoteTamperer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local staminaRemote = ReplicatedStorage.RS.Remotes.Combat.StaminaCost
local setTarget = ReplicatedStorage.RS.Remotes:FindFirstChild("SetTarget", true)

RemoteTamperer.TamperRemotes({staminaRemote}, function(remote, args, oldNamecall)
	if ODYSSEY.Data.NoStamina then
		args[1] = 0
	end
end)

RemoteTamperer.TamperRemotes({setTarget}, function(remote, args, oldNamecall)
	if ODYSSEY.Data.BreakAI then
		return false
	end
end)