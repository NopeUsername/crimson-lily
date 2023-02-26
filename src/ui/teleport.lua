local function InitPlaces(tab)
	-- scrape places
	local places = {}
	for _, place in workspace.Map:GetChildren() do
		if not place:FindFirstChild("Center") then continue end
		places[place.Name] = place
	end
	
	--
	local box = tab:AddLeftTabbox("Places")
	local pageCount = 19
	local counter = 0
	
	local currentPage = 1
	local currentTab = box:AddTab("Page ".. currentPage)
	
	for placeName, place in places do
		counter += 1
		if counter > pageCount then
			counter = 1
			
			currentPage += 1
			currentTab = box:AddTab("Page".. currentPage)
		end
		
		currentTab:AddButton({
			Text = placeName,
			Func = function()
				local character = ODYSSEY.GetLocalCharacter()
				local center = place.Center
				
				if not character then return end
				
				character:SetPrimaryPartCFrame(center.CFrame)
				task.wait(0.3)
				character.PrimaryPart.Anchored = true
				
				if not place:FindFirstChild("AboveWater") then
					ODYSSEY.SendNotification(nil, "Tragic Odyssey", "The destination may take a while to load, please wait.", Color3.new(1, 1, 1))
					
					while not place:FindFirstChild("Fragmentable") do
						place.ChildAdded:Wait()
					end
				end
				
				-- get an appropriate point to tp to
				local highestY = -9e9
				
				for _, child in place:GetChildren() do
					if not child:IsA("Model") then continue end
					local _, size = child:GetBoundingBox()
					if size.Y/2 > highestY then
						highestY = size.Y/2
					end
				end
				
				character:SetPrimaryPartCFrame(center.CFrame * CFrame.new(0, highestY, 0))
				character.PrimaryPart.Anchored = false
			end,
			
			DoubleClick = false,
			Tooltip = "Teleport to ".. placeName
		})
	end
end

return function(UILib, window)
	local tab = window:AddTab("Teleport")
	
	InitPlaces(tab)
end