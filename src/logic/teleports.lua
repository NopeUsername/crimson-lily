local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Locations = require(ReplicatedStorage.RS.Modules.Locations)

local UnloadedIslands = ReplicatedStorage.RS.UnloadIslands

local Teleports = {}
ODYSSEY.Data.Teleports = Teleports

function FindHighestPart(parts)
	local highest = -9e9
	local point = Vector3.new()

	for _, v in ipairs(parts) do
		if not v:IsA("BasePart") then continue end
		if v.Position.Y > highest then
			highest = v.Position.Y
			point = v.Position
		end
	end

	return point
end

function GetRegionDescendants(regionName, overrideModel, overrideUnload)
	local children = {}
	local regionModel = workspace.Map:FindFirstChild(regionName)
	local unloadedModel = UnloadedIslands:FindFirstChild(regionName)

	if overrideModel then
		regionModel = overrideModel
		unloadedModel = overrideUnload
	end

	for _, v in ipairs(regionModel:GetDescendants()) do
		table.insert(children, v)
	end

	if unloadedModel then
		for _, v in ipairs(unloadedModel:GetDescendants()) do
			if table.find(children, v) then continue end
			table.insert(children, v)
		end
	end

	return children
end

function Teleports.GetRegions()
	local regions = {}

	--
	for regionName, regionData in pairs(Locations.Regions) do
		local regionDescs = GetRegionDescendants(regionName)
		local copy = table.clone(regionData)
		local areas = {}

		copy.HighestPoint = FindHighestPart(regionDescs)
		copy.Name = regionName

		-- areas
		if regionData.Areas then
			for areaName, areaData in pairs(regionData.Areas) do
				local areaCopy = table.clone(areaData)
				areaCopy.Name = areaName
				areaCopy.Region = copy
	
				if areaData.Center then
					-- 1: areas with a defined Center
					areaCopy.HighestPoint = areaData.Center + Vector3.new(0, 50, 0)
				else
					-- 2: areas with no Center, but detected through Raycast
					for _, v in ipairs(regionDescs) do
						if v:IsA("StringValue") and v.Name == "DisplayName" and v.Value == areaName then
							areaCopy.HighestPoint = FindHighestPart(v.Parent:GetDescendants())
							break
						end
					end
				end

				if not areaCopy.HighestPoint then
					-- failsafe
					areaCopy.HighestPoint = copy.HighestPoint
				end

				table.insert(areas, areaCopy)
			end
		end

		copy.Areas = areas
		table.insert(regions, copy)
	end

	table.sort(regions, function(a, b)
		return a.Name < b.Name
	end)
	--

	return regions
end

function Teleports.TeleportToRegion(place)
	local character = ODYSSEY.GetLocalCharacter()
	if not character then return end

	local region = (place.Region and place.Region.Name) or place.Name
	local regionModel = workspace.Map:FindFirstChild(region)

	character:SetPrimaryPartCFrame(CFrame.new(place.HighestPoint))
	task.wait(0.15)
	character.HumanoidRootPart.Anchored = true

	ODYSSEY.SendNotification(nil, "Tragic Odyssey", "The destination may take a while to load, please wait.", Color3.new(1, 1, 1))
	while not regionModel:FindFirstChild("Fragmentable") do
		regionModel.ChildAdded:Wait()
	end

	character.HumanoidRootPart.Anchored = false
end

return function() end