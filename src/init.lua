local env = assert(getgenv, "Unsupported exploit")()

if env.ODYSSEY then
    env.ODYSSEY.Maid:Destroy()
    env.ODYSSEY = nil
end

-- services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- modules
local Maid = load("src/lib/Maid.lua")

local ODYSSEY = {
    Hooks = {},
    MetaHooks = {},
	
	Data = {},

    Maid = Maid.new(),
    UI = nil,
}
env.ODYSSEY = ODYSSEY

-- overall cleanup task
ODYSSEY.Maid:GiveTask(function()
    for original, hook in pairs(ODYSSEY.Hooks) do
        hookfunction(hook, original)
    end

    for original, hookData in pairs(ODYSSEY.MetaHooks) do
        hookmetamethod(hookData.Object, hookData.Method, original)
    end

    table.clear(ODYSSEY)
end)

-- helpers

function ODYSSEY.GetLocalPlayer()
	return Players.LocalPlayer
end

function ODYSSEY.GetLocalCharacter()
	return ODYSSEY.GetLocalPlayer().Character
end

function ODYSSEY.SendNotification(config)
	config.Title = "Tragic Odyssey - Notification"
	game:GetService("StarterGui"):SetCore("SendNotification", config)
end

do
	local rem = ReplicatedStorage.RS.Remotes.UI.Notification
	local upvalues = getupvalues(getconnections(rem.OnClientEvent)[1].Function)[1]
	local notifFunc = upvalues.Notification
	
	ODYSSEY.SendNotification = notifFunc
end

-- init
ODYSSEY.RemoteTamperer = load("src/logic/RemoteTamperer.lua")
load("src/ui/init.lua")

-- logic
load("src/logic/damage_tamper.lua")
load("src/logic/combat_other.lua")