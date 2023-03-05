local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Locations = require(ReplicatedStorage.RS.Modules.Locations)

local UnloadedIslands = ReplicatedStorage.RS.UnloadIslands

local Teleports = {}
ODYSSEY.Data.Teleports = Teleports

function Teleports.GetRegions()
	local regions = {}

	--
	for regionName, regionData in pairs(Locations.Regions) do
		local copy = table.clone(regionData)
		local areas = {}
		copy.Name = regionName

		--
		local regionModel = workspace.Map:FindFirstChild(regionName)
		local unloadedModel = UnloadedIslands:FindFirstChild(regionName)

		local regionDescs = regionModel:GetDescendants()

		if unloadedModel then
			for _, v in ipairs(unloadedModel:GetDescendants()) do
				table.insert(regionDescs, v)
			end
		end
		--

		-- areas
		if regionData.Areas then
			for areaName, areaData in pairs(regionData.Areas) do
				local areaCopy = table.clone(areaData)
				areaCopy.Name = areaName
				areaCopy.Region = copy
	
				if not areaData.Center then
					-- area has no Center, but detected through raycast
					for _, v in ipairs(regionDescs) do
						if v:IsA("StringValue") and v.Name == "DisplayName" and v.Value == areaName then
							local possiblePart1 = regionModel:FindFirstChildWhichIsA("BasePart", true)
							local possiblePart2 = possiblePart1

							if unloadedModel then
								possiblePart2 = unloadedModel:FindFirstChildWhichIsA("BasePart", true)
							end
							
							areaCopy.Center = (possiblePart1 and possiblePart1.Position) or (possiblePart2 and possiblePart2.Position)
							areaCopy.Model = v.Parent
							break
						end
					end
				end

				-- gah
				if not areaCopy.Center then
					areaCopy.Center = copy.Center
					areaCopy.Model = regionModel
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

	character:SetPrimaryPartCFrame(CFrame.new(place.Center))
	task.wait(0.15)

	character.HumanoidRootPart.Anchored = true
	ODYSSEY.SendNotification(nil, "Crimson Lily", "The destination may take a while to load, please wait.", Color3.new(1, 1, 1))

	while not regionModel:FindFirstChild("Fragmentable") do
		regionModel.ChildAdded:Wait()
	end

	

	--------------------------------------------------------
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = {regionModel}
	params.FilterType = Enum.RaycastFilterType.Include

	local searchSize = Vector3.new(500, 800, 500)
	if place.Model then
		-- an Area
		_, searchSize = place.Model:GetBoundingBox()
		searchSize -= Vector3.new(15, 15, 15)

		params.FilterDescendantsInstances = {place.Model}
	end

	local parts = workspace:GetPartBoundsInBox(
		CFrame.new(place.Center),
		searchSize,
		params
	)
	local hit, highestY = nil, -9e9

	for _, candidate in ipairs(parts) do
		if candidate.CanCollide == false then continue end
		if candidate.Position.Y > highestY then
			highestY = candidate.Position.Y
			hit = candidate
		end
	end

	if not hit then
		ODYSSEY.SendNotification(nil, "Crimson Lily", "Failed to find an appropriate teleport destination.", Color3.new(1, 0, 0))
		character.HumanoidRootPart.Anchored = false

		return
	end

	character:SetPrimaryPartCFrame(hit.CFrame)
	character.HumanoidRootPart.Anchored = false
end