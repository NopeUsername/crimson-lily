local function InitDamage(tab)
	ODYSSEY.Data.DamageReflect = false
	ODYSSEY.Data.DamageNull = true
	ODYSSEY.Data.DamageAmp = false
	ODYSSEY.Data.DamageAmpValue = 5
	
	tab:NewSection("Damage tamper")
	tab:NewLabel("All the damage tampers only work against NPCs", "left")
	tab:NewToggle("Damage Nullification", ODYSSEY.Data.DamageNull, function(value)
		ODYSSEY.Data.DamageNull = value
	end)
	tab:NewToggle("Damage Reflection", ODYSSEY.Data.DamageReflect, function(value)
		ODYSSEY.Data.DamageReflect = value
	end)
	tab:NewToggle("Damage Amplification", ODYSSEY.Data.DamageAmp, function(value)
		ODYSSEY.Data.DamageAmp = value
	end)

	tab:NewSlider("Damage Amp", "", true, "/", {min = 1, max = 100, default = ODYSSEY.Data.DamageAmpValue}, function(value)
		ODYSSEY.Data.DamageAmpValue = value
	end)
end

local function InitKillaura(tab)
	ODYSSEY.Data.KillauraActive = false
	ODYSSEY.Data.KillPlayers = false
	ODYSSEY.Data.KillauraRadius = 100

	tab:NewSection("Killaura")
	tab:NewSlider("Radius", "m", true, "/", {min = 1, max = 300, default = ODYSSEY.Data.KillauraRadius}, function(value)
		ODYSSEY.Data.KillauraRadius = value
	end)
	tab:NewToggle("Killaura", ODYSSEY.Data.KillauraActive, function(value)
		ODYSSEY.Data.KillauraActive = value
	end)
	tab:NewToggle("Kill players", ODYSSEY.Data.KillPlayers, function(value)
		ODYSSEY.Data.KillPlayers = value
	end)
	tab:NewButton("Kill once", function()
		ODYSSEY.Data.Killaura.KillOnce()
	end)
end

local function InitOther(tab)
	ODYSSEY.Data.NoStamina = true
	ODYSSEY.Data.BreakAI = true

	tab:NewSection("Miscellaneous")
	tab:NewToggle("No dash stamina", ODYSSEY.Data.NoStamina, function(value)
		ODYSSEY.Data.NoStamina = value
	end)

	tab:NewToggle("Break AI targeting", ODYSSEY.Data.BreakAI, function(value)
		ODYSSEY.Data.BreakAI = value
	end)
end

return function(UILib, window)
	local tab = window:NewTab("Combat")
	
	InitDamage(tab)
	InitKillaura(tab)
	InitOther(tab)
end