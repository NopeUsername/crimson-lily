local Teleports = ODYSSEY.Teleports

local function InitPlaces(tab)
	local regions = Teleports.Regions

	for _, placeData in ipairs(regions) do
		tab:NewSection(placeData.Name)
		tab:NewButton(placeData.Name, function()
			Teleports.TeleportToRegion(placeData)
		end)

		if placeData.Areas then
			for _, areaData in pairs(placeData.Areas) do
				tab:NewButton(areaData.Name, function()
					Teleports.TeleportToRegion(areaData)
				end)
			end
		end
	end
end

return function(UILib, window)
	local tab = window:NewTab("Teleport")
	tab:NewLabel('<b>DO NOT TELEPORT WHILE HOLDING BRONZE SEALED CHESTS. DO NOT TELEPORT WHILE HOLDING BRONZE SEALED CHESTS</b>')
	
	InitPlaces(tab)
end