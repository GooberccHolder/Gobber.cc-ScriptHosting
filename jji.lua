local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

local Window = Starlight:CreateWindow({
    Name = "JJI",
    Subtitle = "v1.0",
    Icon = NebulaIcons:GetIcon("view_in_ar", "Material"),
    LoadingSettings = {
        Title = "JJI",
        Subtitle = "Welcome to JJI",
    },
    FileSettings = {
        ConfigFolder = "JJIS"
    },
})

local TabSection = Window:CreateTabSection("Tab Section")

local MainTab = TabSection:CreateTab({
    Name = "Main",
    Icon = NebulaIcons:GetIcon("home_filled", "Material"),
    Columns = 2,
}, "TAB1")

local Groupbox1 = MainTab:CreateGroupbox({
    Name = "Misc",
    Column = 1,
}, "GROUP1")

local abilities = {
    "Tool Manipulation", "Construction", "Cloning Technique", "Boogie Woogie",
    "Blazing Courage", "Ratio", "Cursed Speech", "Blood Manipulation",
    "Straw Doll", "Cryokinesis", "Volcano", "Hydrokinesis", "Judgeman",
    "Puppet", "Projection", "Plant Manipulation", "Thunder God",
    "Ancient Construction", "Star Rage", "Gambler Fever", "Soul King",
    "Soul Manipulation", "Curse Queen", "Demon Vessel", "Infinity"
}

for slot = 1, 4 do
    local Label = Groupbox1:CreateLabel({
        Name = "Innate Slot " .. slot
    }, "LABEL_" .. slot)

    Label:AddDropdown({
        Options = abilities,
        Placeholder = "Select Innate",
        Callback = function(Options)
            player.ReplicatedData.innates[tostring(slot)].Value = Options[1]
        end,
    }, "DROPDOWN_" .. slot)
end

local SkillList = {}
local SkillsFolder = ReplicatedStorage:WaitForChild("Skills")

for _, folder in ipairs(SkillsFolder:GetChildren()) do
    if folder:IsA("Folder") then
        table.insert(SkillList, folder.Name)
    end
end

table.sort(SkillList)

local selectedSkill = nil

local SkillLabel = Groupbox1:CreateLabel({
    Name = "Skill Selector (some will kick you.)"
}, "SKILL_LABEL")

SkillLabel:AddDropdown({
    Options = SkillList,
    Placeholder = "Select Skill",
    Callback = function(Options)
        selectedSkill = Options[1]
    end,
}, "SKILL_DROPDOWN")

Groupbox1:CreateButton({
    Name = "Use Skill",
    Icon = NebulaIcons:GetIcon("check", "Material"),
    Callback = function()
        if not selectedSkill then return end

        ReplicatedStorage
            :WaitForChild("Remotes")
            :WaitForChild("Server")
            :WaitForChild("Combat")
            :WaitForChild("Skill")
            :FireServer(selectedSkill)
    end,
}, "USE_SKILL_BUTTON")

local Button12 = Groupbox1:CreateButton({
    Name = "Skip Spins",
    Icon = NebulaIcons:GetIcon("check", "Material"),
    Callback = function()
        local gamepasses = player.ReplicatedData:FindFirstChild("gamepasses")
        if not gamepasses then
            gamepasses = Instance.new("Folder")
            gamepasses.Name = "gamepasses"
            gamepasses.Parent = player.ReplicatedData
        end

        local boolValue = gamepasses:FindFirstChild("259500454")
        if not boolValue then
            boolValue = Instance.new("BoolValue")
            boolValue.Name = "259500454"
            boolValue.Parent = gamepasses
        end

        boolValue.Value = true
    end,
}, "INDEX3412")

local Button12 = Groupbox1:CreateButton({
    Name = "Unlock Innate Slot 3",
    Icon = NebulaIcons:GetIcon("check", "Material"),
    Callback = function()
        local gamepasses = player.ReplicatedData:FindFirstChild("gamepasses")
        if not gamepasses then
            gamepasses = Instance.new("Folder")
            gamepasses.Name = "gamepasses"
            gamepasses.Parent = player.ReplicatedData
        end

        local boolValue = gamepasses:FindFirstChild("77102481")
        if not boolValue then
            boolValue = Instance.new("BoolValue")
            boolValue.Name = "77102481"
            boolValue.Parent = gamepasses
        end

        boolValue.Value = true
    end,
}, "INDEX3412")
local Button12 = Groupbox1:CreateButton({
    Name = "Unlock Innate Slot 4",
    Icon = NebulaIcons:GetIcon("check", "Material"),
    Callback = function()
        local gamepasses = player.ReplicatedData:FindFirstChild("gamepasses")
        if not gamepasses then
            gamepasses = Instance.new("Folder")
            gamepasses.Name = "gamepasses"
            gamepasses.Parent = player.ReplicatedData
        end

        local boolValue = gamepasses:FindFirstChild("77102528")
        if not boolValue then
            boolValue = Instance.new("BoolValue")
            boolValue.Name = "77102528"
            boolValue.Parent = gamepasses
        end

        boolValue.Value = true
    end,
}, "INDEX34212")

local function createLearnedFromInnates()
    local player = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local innatesFolder = player.ReplicatedData:WaitForChild("innates")
    local learnedFolder = player.ReplicatedData:WaitForChild("learned")
    local skillsFolder = ReplicatedStorage:WaitForChild("Skills")

    for slot = 1, 4 do
        local innateObj = innatesFolder:FindFirstChild(tostring(slot))
        if innateObj and innateObj.Value ~= "" then
            local innateName = innateObj.Value

            for _, skillFolder in ipairs(skillsFolder:GetChildren()) do
                if skillFolder:IsA("Folder") then
                    -- prefix match
                    if string.sub(skillFolder.Name, 1, #innateName) == innateName then
                        -- create BoolValue if it doesn't exist
                        local bool = learnedFolder:FindFirstChild(skillFolder.Name)
                        if not bool then
                            bool = Instance.new("BoolValue")
                            bool.Name = skillFolder.Name
                            bool.Parent = learnedFolder
                        end

                        bool.Value = true
                    end
                end
            end
        end
    end
end

local nigger12 = Groupbox1:CreateButton({
    Name = "Learn all skills from your current innates",
    Icon = NebulaIcons:GetIcon("school", "Material"),
    Callback = function()
        createLearnedFromInnates()
    end,
}, "LEARN_INNATE_SKILLS")


local techniqueSlots = { "Z", "X", "C", "V", "B", "G", "T", "Y" }
local techniquesFolder = player.ReplicatedData:WaitForChild("techniques")

for _, slot in ipairs(techniqueSlots) do
    local Label = Groupbox1:CreateLabel({
        Name = "Technique Slot " .. slot
    })

    Label:AddDropdown({
        Options = SkillList,
        Placeholder = "Select Skill",
        Callback = function(Options)
            local slotValue = techniquesFolder:FindFirstChild(slot)
            if slotValue then
                slotValue.Value = Options[1]
            else
                warn("Slot not found:", slot)
            end
        end,
    })
end