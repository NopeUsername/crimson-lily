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

do
	local rem = ReplicatedStorage.RS.Remotes.UI.Notification
	local upvalues = getupvalues(getconnections(rem.OnClientEvent)[1].Function)[1]
	local notifFunc = upvalues.Notification
	
	ODYSSEY.SendNotification = notifFunc
end

do
    local LoadArea
    for index, connection in next, getconnections(ReplicatedStorage.RS.Remotes:WaitForChild("Misc").OnTeleport.OnClientEvent) do
        local env = connection.Function and getfenv(connection.Function)
        if env and tostring(rawget(env, "script")) == "Unloading" then
            LoadArea = debug.getupvalue(connection.Function, 2)
            break
        end
    end

    ODYSSEY.LoadArea = LoadArea
end

-- init
ODYSSEY.RemoteTamperer = load("src/logic/remote_tamper.lua")

-- logic
if game.PlaceId ~= 3272915504 then
    load("src/logic/damage_tamper.lua")
    load("src/logic/combat_other.lua")
    load("src/logic/teleports.lua")
    load("src/logic/track.lua")
    load("src/logic/killaura.lua")
end

load("src/logic/gameplay.lua")
load("src/ui/init.lua")