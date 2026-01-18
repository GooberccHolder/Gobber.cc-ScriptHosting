local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local speaker = Players.LocalPlayer

GuiService.AutoSelectGuiEnabled = true

local Window = Rayfield:CreateWindow({
    Name = "ABA",
    Icon = 0,
    LoadingTitle = "ABA-Autofarm",
    LoadingSubtitle = ">>ABAFARM<<",
    ShowText = "ABA",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = true,
    KeySystem = false,
})

local MainTab = Window:CreateTab("Farming", "gavel")
MainTab:CreateSection("Farmas")

Rayfield:Notify({
    Title = "Notification",
    Content = "working",
    Duration = 6.5,
    Image = "gamepad-2",
})

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local uiEnabled = false
local uiConn
local used = {}

local function clickButton(button)
    pcall(function()
        for _, connection in pairs(getconnections(button.Activated)) do
            connection:Fire()
        end
    end)
    
    pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
    end)
    
    pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
    end)
    
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    end)
end

local resetLoop1 = false  -- For principal
local resetLoop2 = false  -- For secondary
local uiEnabled1 = false
local uiEnabled2 = false
local uiConn1
local uiConn2
local used1 = {}
local used2 = {}

local function trySelect1(inst)
    if not uiEnabled1 then return end
    if not inst:IsA("GuiButton") then return end
    if not inst.Visible then return end
    if used1[inst] then return end
    if inst.Name ~= "Pass Ban" and inst.Name ~= "Map1" then return end
    
    used1[inst] = true
    task.wait(0.1)
    clickButton(inst)
    task.wait(0.1)
    clickButton(inst)
    task.wait(0.1)
    clickButton(inst)
end

local function trySelect2(inst)
    if not uiEnabled2 then return end
    if not inst:IsA("GuiButton") then return end
    if not inst.Visible then return end
    if used2[inst] then return end
    if inst.Name ~= "Pass Ban" and inst.Name ~= "Map2" then return end
    
    used2[inst] = true
    task.wait(0.1)
    clickButton(inst)
    task.wait(0.1)
    clickButton(inst)
    task.wait(0.1)
    clickButton(inst)
end

local function startUI1()
    if uiConn1 then return end
    uiEnabled1 = true
    used1 = {}
    
    for _, v in ipairs(pg:GetDescendants()) do
        trySelect1(v)
    end
    
    uiConn1 = pg.DescendantAdded:Connect(function(inst)
        task.wait(0.05)
        trySelect1(inst)
    end)
end

local function stopUI1()
    uiEnabled1 = false
    used1 = {}
    if uiConn1 then
        uiConn1:Disconnect()
        uiConn1 = nil
    end
end

local function startUI2()
    if uiConn2 then return end
    uiEnabled2 = true
    used2 = {}
    
    for _, v in ipairs(pg:GetDescendants()) do
        trySelect2(v)
    end
    
    uiConn2 = pg.DescendantAdded:Connect(function(inst)
        task.wait(0.05)
        trySelect2(inst)
    end)
end

local function stopUI2()
    uiEnabled2 = false
    used2 = {}
    if uiConn2 then
        uiConn2:Disconnect()
        uiConn2 = nil
    end
end

MainTab:CreateToggle({
    Name = "ative na continha principal",
    CurrentValue = false,
    Flag = "MA1",
    Callback = function(v)
        resetLoop1 = v
        if v then
            startUI1()
        else
            stopUI1()
            return
        end
        
        task.spawn(function()
            while resetLoop1 do
                game:GetService("ReplicatedStorage"):WaitForChild("RematchVote"):FireServer()
                task.wait(1)
            end
        end)
    end,
})

MainTab:CreateToggle({
    Name = "ative na outra continha",
    CurrentValue = false,
    Flag = "SA1",
    Callback = function(v)
        resetLoop2 = v
        if v then
            startUI2()
        else
            stopUI2()
            return
        end
        
        task.spawn(function()
            while resetLoop2 do
                local hud = pg:FindFirstChild("HUD")
                local stockCount = hud and hud:FindFirstChild("StockCount")
                
                if stockCount and stockCount.Visible then
                    local char = speaker.Character or speaker.CharacterAdded:Wait()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = 0
                    else
                        char:BreakJoints()
                    end
                end
                
                game:GetService("ReplicatedStorage"):WaitForChild("RematchVote"):FireServer()
                task.wait(1)
            end
        end)
    end,
})