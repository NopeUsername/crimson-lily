local Killaura = {}
ODYSSEY.Data.Killaura = Killaura

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local remot = game:GetService("ReplicatedStorage").RS.Remotes.Combat.DealWeaponDamage

local WEAPON = HttpService:JSONEncode({
    Name = "Triasta of Bronze",
    Level = 120
})
local KILLING = {}

function KillModel(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local hrp = model:FindFirstChild("HumanoidRootPart")

    if KILLING[model] then return end
    if not humanoid or not hrp then return end
    if humanoid.Health <= 0 then return end

    if ODYSSEY.GetLocalPlayer():DistanceFromCharacter(hrp.Position) <= ODYSSEY.Data.KillauraRadius then
        task.spawn(function()
            KILLING[model] = true

            while humanoid.Health > 0 do
                for _ = 1, 10 do
                    remot:FireServer(0, ODYSSEY.GetLocalCharacter(), model, WEAPON, "Impaling Strike", "")
                end

                task.wait(5)
            end

            KILLING[model] = nil
        end)           
    end
end

function Killaura.KillOnce()
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        KillModel(enemy)
    end

    if ODYSSEY.Data.KillPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player == ODYSSEY.GetLocalPlayer() then continue end
            KillModel(player.Character)
        end
    end
end

local cancelled = false
ODYSSEY.Maid:GiveTask(function()
    cancelled = true
end)

task.spawn(function()
    while not cancelled do
        task.wait(1)
    
        if ODYSSEY.Data.KillauraActive then
            Killaura.KillOnce()
        end
    end
end)
