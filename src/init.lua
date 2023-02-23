local env = assert(getgenv, "Unsupported exploit")()

if env.ODYSSEY then
    env.ODYSSEY.Maid:Destroy()
    env.ODYSSEY = nil
end

-- services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local Maid = load("src/lib/Maid.lua")

local ODYSSEY = {
    Hooks = {},
    MetaHooks = {},

    Maid = Maid.new(),
    UI = nil,
}
env.ODYSSEY = ODYSSEY

-- overall cleanup task
ODYSSEY.Maid:GiveTask(function()
    for original, hook in pairs(ODYSSEY.Hooks) do
        hookfunction(hook, original)
    end

    for original, hookData in pairs(ODYSSEY.MetaHooks) do
        hookmetamethod(hookData.Object, hookData.Method, original)
    end

    table.clear(ODYSSEY)
end)

-- init
ODYSSEY.RemoteTamperer = load("src/logic/RemoteTamperer.lua")
-- load("src/ui/init.lua")


-- test
local rng = Random.new()
local gameSkillTypes = require(ReplicatedStorage.RS.Modules.Magic.SkillTypes)

local skillTypes = {"Blast Attack", "Explosion", "Beam Attack"}
local magics = {}

do
	local types = require(ReplicatedStorage.RS.Modules.Magic).Types
	for name, magic in types do
		table.insert(magics, name)
	end
end

local function GenerateMagicOptions()
	local randomMagic = magics[rng:NextInteger(1, #magics)]
	local randomSkillType = skillTypes[rng:NextInteger(1, #skillTypes)]

	local skillTypeData = gameSkillTypes.Types[randomSkillType]
	local options = {}
	local serializedOptions = {}

	for _, optionData in skillTypeData.Options do
		local option = {
			Order = optionData.Order,
			Value = ""
		}
		
		if optionData.Type == "Animation" then
			option.Value = optionData.Default
		elseif optionData.Type == "Bool" then
			option.Value = rng:NextInteger(1, 2) == 1 and true or false
		elseif optionData.Type == "Int" then
			option.Value = rng:NextInteger(optionData.MinValue, optionData.MaxValue)
		elseif optionData.Type == "String" then
			option.Value = optionData.Options[rng:NextInteger(1, #optionData.Options)]
		elseif optionData.Type == "Percent" then
			option.Value = rng:NextInteger(optionData.MinValue, optionData.MaxValue)
		end
		
		table.insert(options, option)
	end

	table.sort(options, function(a, b)
		return a.Order < b.Order
	end)

	for _, option in options do
		table.insert(serializedOptions, option.Value)
	end

	table.insert(serializedOptions, 1, randomSkillType)
	table.insert(serializedOptions, HttpService:GenerateGUID())
	table.insert(serializedOptions, HttpService:GenerateGUID())
    
	return randomMagic, HttpService:JSONEncode(serializedOptions)
end


local char = game:GetService("Players").LocalPlayer.Character

for _, remote in ipairs(ReplicatedStorage.RS.Remotes:GetDescendants()) do
    local name = remote.name

    if string.match(name, "Take") and string.match(name, "Damage") then
        ODYSSEY.RemoteTamperer.BlacklistRemotes({remote})
    end

    if string.match(name, "Deal") and string.match(name, "Damage") then
        ODYSSEY.RemoteTamperer.TamperRemotes({remote}, 1, function(remote, args)
            local dealer, receiver = args[1], args[2]

            if receiver == char then
                args[1] = receiver
                args[2] = dealer
            end
        end)

        ODYSSEY.RemoteTamperer.TamperRemotes({remote}, 2, function(remote, args)
            local amount = 15 -- or (damage amp amount here)
            local fireServer = remote.FireServer

            for _ = 1, amount do
                -- when Elementalist is enabled
                if remote.Name == "DealAttackDamage" then
                    local magic, options = GenerateMagicOptions()

                    args[3] = magic
                    args[4] = "1"
                    args[5] = options
                end

                fireServer(remote, table.unpack(args))
            end
        end)
    end
end