local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RS = ReplicatedStorage:WaitForChild("RS")

local function InitNavyInfluence(tab)
    local navyInfluence = RS.NavyInfluence
    local maxNavyInfluence = 1000000
    local inf = tab:NewLabel()
   
    local function update()
        local percentage = navyInfluence.Value / maxNavyInfluence
        inf:Text(string.format("Grand Navy influence: %.2f", percentage * 100).. "%")
    end

    update()
    navyInfluence.Changed:Connect(update)
end

return function(UILib, window)
	local tab = window:NewTab("Info")

	InitNavyInfluence(tab)
end