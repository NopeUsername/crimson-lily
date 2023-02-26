local function InitDamage(tab)
	local box = tab:AddLeftGroupbox("Damage tamper")
	
	ODYSSEY.Data.DamageReflect = false
	ODYSSEY.Data.DamageAmp = false
	ODYSSEY.Data.DamageAmpValue = 5
	
	box:AddToggle("DamageReflect", {
		Text = "Damage reflection",
		Default = ODYSSEY.Data.DamageReflect,
		Tooltip = "ONLY WORKS AGAINST NPCs",
		Callback = function(value)
			ODYSSEY.Data.DamageReflect = value
		end
	})
	box:AddToggle("DamageAmp", {
		Text = "Damage amplification",
		Default = ODYSSEY.Data.DamageAmp,
		Tooltip = "Amplifies all your damage",
		Callback = function(value)
			ODYSSEY.Data.DamageAmp = value
		end
	})
	box:AddSlider("DamageAmpValue", {
		Compact = false,
		Text = "I don't recommend going over 20",
		Default = ODYSSEY.Data.DamageAmpValue,
		Min = 1,
		Max = 100,
		Rounding = 0,
		Callback = function(value)
			ODYSSEY.Data.DamageAmpValue = value
		end
	})
end

local function InitOther(tab)
	local box = tab:AddRightGroupbox("Other")
	
	ODYSSEY.Data.NoStamina = false
	
	box:AddToggle("NoStamina", {
		Text = "No dash stamina",
		Default = ODYSSEY.Data.NoStamina,
		Tooltip = "Dash no longer consumes stamina",
		Callback = function(value)
			ODYSSEY.Data.NoStamina = value
		end
	})
end

return function(UILib, window)
	local tab = window:AddTab("Combat")
	
	InitDamage(tab)
	InitOther(tab)
end