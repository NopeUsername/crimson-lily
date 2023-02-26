local UILib = load("src/lib/LinoriaLib.lua")

local window = UILib:CreateWindow({
	Title = "Tragic Odyssey",
	Center = true,
	AutoShow = true
})
ODYSSEY.UI = window
ODYSSEY.Maid:GiveTask(function()
	UILib:Unload()
end)

load("src/ui/combat.lua")(UILib, window)
load("src/ui/teleport.lua")(UILib, window)