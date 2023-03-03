local UILib = load("src/lib/xsxLib.lua")
UILib.title = "The Crimson Lily"

local window = UILib:Init()

ODYSSEY.Maid:GiveTask(function()
	window:Remove()
end)

load("src/ui/combat.lua")(UILib, window)
load("src/ui/teleport.lua")(UILib, window)