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

local function InitOther(tab)
	ODYSSEY.Data.NoStamina = true

	tab:NewSection("Miscellaneous")
	tab:NewToggle("No dash stamina", ODYSSEY.Data.NoStamina, function()
		ODYSSEY.Data.NoStamina = value
	end)
end

return function(UILib, window)
	local tab = window:NewTab("Combat")
	
	InitDamage(tab)
	InitOther(tab)
end