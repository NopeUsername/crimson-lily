local Killaura = {}
ODYSSEY.Data.Killaura = Killaura

local HttpService = game:GetService("HttpService")

local remot = game:GetService("ReplicatedStorage").RS.Remotes.Combat.DealWeaponDamage

local WEAPON = HttpService:JSONEncode({
    Name = "Triasta of Bronze",
    Level = 120
})

function Killaura.KillOnce()
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local hrp = enemy:FindFirstChild("HumanoidRootPart")

        if not humanoid or not hrp then continue end
        if humanoid.Health <= 0 then continue end

        if ODYSSEY.GetLocalPlayer():DistanceFromCharacter(hrp.Position) <= ODYSSEY.Data.KillauraRadius then
            task.spawn(function()
                while humanoid.Health > 0 do
                    for _ = 1, 10 do
                        remot:FireServer(0, ODYSSEY.GetLocalCharacter(), enemy, WEAPON, "Impaling Strike", "")
                    end

                    task.wait(2)
                end
            end)           
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
