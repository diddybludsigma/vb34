-- DUPE QUEST - FIXED LOADING SCREEN
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- SINGLE PREMIUM KEY
local PREMIUM_KEY = "GH4555-X9K7-M4N2"
local KEY_VALIDATED = false

-- FAKE VISUAL DATA
local visualData = {
    level = 5,
    exp = 0,
    expNeeded = 100,
    money = 24713,
    statPoints = 0,
    
    DefenseStat = 10,
    DestructiveEnergyStat = 3,
    DestructivePowerStat = 4,
    PowerStat = 8,
    StrengthStat = 12,
    WeaponStat = 5
}

-- Load LevelUp VFX
local levelUpVFX = nil
pcall(function()
    levelUpVFX = require(ReplicatedStorage:WaitForChild("modules"):WaitForChild("vfx"):WaitForChild("main"):WaitForChild("LevelUp"))
end)

-- Get current level
function getCurrentLevel()
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local levelValue = slotData:FindFirstChild("Level")
            if levelValue and levelValue:IsA("IntValue") then
                visualData.level = levelValue.Value
                return visualData.level
            end
        end
    end
    return visualData.level
end

-- Update level in game
function updateLevelInGame(newLevel)
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local levelValue = slotData:FindFirstChild("Level")
            if levelValue and levelValue:IsA("IntValue") then
                levelValue.Value = newLevel
                visualData.level = newLevel
                return true
            end
        end
    end
    return false
end

-- Get money
function getMoney()
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local moneyValue = slotData:FindFirstChild("Money")
            if moneyValue and moneyValue:IsA("IntValue") then
                visualData.money = moneyValue.Value
                return visualData.money
            end
        end
    end
    return visualData.money
end

-- Update money
function updateMoneyInGame(newMoney)
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local moneyValue = slotData:FindFirstChild("Money")
            if moneyValue and moneyValue:IsA("IntValue") then
                moneyValue.Value = newMoney
                visualData.money = newMoney
                return true
            end
        end
    end
    return false
end

-- Get all stats
function getAllStats()
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local pointsValue = slotData:FindFirstChild("StatPoints")
            if pointsValue and pointsValue:IsA("IntValue") then
                visualData.statPoints = pointsValue.Value
            end
            
            local statNames = {"DefenseStat", "DestructiveEnergyStat", "DestructivePowerStat", "PowerStat", "StrengthStat", "WeaponStat"}
            for _, statName in ipairs(statNames) do
                local statValue = slotData:FindFirstChild(statName)
                if statValue and statValue:IsA("IntValue") then
                    visualData[statName] = statValue.Value
                end
            end
        end
    end
end

-- Update stat points
function updateStatPointsInGame(newPoints)
    visualData.statPoints = newPoints
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local pointsValue = slotData:FindFirstChild("StatPoints")
            if pointsValue and pointsValue:IsA("IntValue") then
                pointsValue.Value = newPoints
                return true
            end
        end
    end
    return false
end

-- Update a stat
function updateStatInGame(statName, newValue)
    visualData[statName] = newValue
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        local slotData = playerData:FindFirstChild("SlotData")
        if slotData then
            local statValue = slotData:FindFirstChild(statName)
            if statValue and statValue:IsA("IntValue") then
                statValue.Value = newValue
                return true
            end
        end
    end
    return false
end

-- Find and fill EXP bar
function findAndFillExpBar(amount)
    local mainHud = playerGui:FindFirstChild("MainHud")
    if not mainHud then return false end
    
    local holder = mainHud:FindFirstChild("holder")
    if not holder then return false end
    
    local experience = holder:FindFirstChild("experience")
    if not experience then return false end
    
    local bar = experience:FindFirstChild("Bar")
    if not bar then return false end
    
    visualData.exp = visualData.exp + amount
    
    while visualData.exp >= visualData.expNeeded do
        visualData.exp = visualData.exp - visualData.expNeeded
        visualData.level = visualData.level + 1
        visualData.expNeeded = math.floor(100 * (visualData.level ^ 1.2))
        visualData.statPoints = visualData.statPoints + 3
        
        updateLevelInGame(visualData.level)
        updateStatPointsInGame(visualData.statPoints)
        
        if levelUpVFX then
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    if rootPart then
                        levelUpVFX({Part = rootPart})
                    end
                end
            end)
        end
        
        showNotification("Leveled Up! (" .. visualData.level .. ")")
    end
    
    local fillPercent = visualData.exp / visualData.expNeeded
    local tween = TweenService:Create(bar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(fillPercent, 0, 1, 0)
    })
    tween:Play()
    
    return true
end

-- Show notification
function showNotification(text)
    local remote = ReplicatedStorage:FindFirstChild("requests")
    if remote then
        remote = remote:FindFirstChild("general")
        if remote then
            remote = remote:FindFirstChild("notification")
            if remote then
                pcall(function()
                    remote:FireServer(text)
                end)
            end
        end
    end
end

-- MAIN QUEST FUNCTION - ONE BUTTON DOES EVERYTHING
function completeQuest()
    if not KEY_VALIDATED then
        print("[ERROR] Validate key first!")
        return false
    end
    
    showNotification("Quest Completed: <font color='#FFFF00'>(Discover 1v1s)</font>")
    wait(0.5)
    
    visualData.money = visualData.money + 12
    updateMoneyInGame(visualData.money)
    showNotification("Earned <font color='#81f19c'>($12)</font>")
    wait(0.3)
    
    showNotification("Earned <font color='#FFFF00'>(500)</font> Experience")
    findAndFillExpBar(500)
    
    -- Random stat increase
    local stats = {"DefenseStat", "PowerStat", "StrengthStat", "WeaponStat", "DestructiveEnergyStat", "DestructivePowerStat"}
    local randomStat = stats[math.random(1, #stats)]
    
    local remote = ReplicatedStorage:FindFirstChild("requests")
    if remote then
        remote = remote:FindFirstChild("character")
        if remote then
            remote = remote:FindFirstChild("increase_stat")
            if remote then
                pcall(function()
                    remote:FireServer(randomStat, 1)
                    if visualData[randomStat] then
                        visualData[randomStat] = visualData[randomStat] + 1
                    end
                end)
            end
        end
    end
    
    return true
end

-- ========== LOADING SCREEN - FIXED LAYOUT ==========
function createLoadingScreen()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.Parent = playerGui
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingGui.ResetOnSpawn = false
    loadingGui.Enabled = true
    
    -- Main frame - increased size to fit everything
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = loadingGui
    
    -- Fade in animation
    local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0})
    fadeIn:Play()
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 60, 120)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 30, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 25))
    })
    gradient.Rotation = 135
    gradient.Parent = mainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title at top
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "DUPE QUEST"
    title.TextColor3 = Color3.fromRGB(100, 180, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = mainFrame
    
    -- Loading bar in middle
    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Size = UDim2.new(0.8, 0, 0, 12)
    loadingBarBg.Position = UDim2.new(0.1, 0, 0.4, 0)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    loadingBarBg.BorderSizePixel = 0
    loadingBarBg.Parent = mainFrame
    
    local loadingBarBgCorner = Instance.new("UICorner")
    loadingBarBgCorner.CornerRadius = UDim.new(0, 6)
    loadingBarBgCorner.Parent = loadingBarBg
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingBarBg
    
    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 6)
    loadingBarCorner.Parent = loadingBar
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 20)
    loadingText.Position = UDim2.new(0, 0, 0.5, 5)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading... 0%"
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 255)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 12
    loadingText.Parent = mainFrame
    
    -- Key input section at bottom
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0.8, 0, 0, 70)
    keyFrame.Position = UDim2.new(0.1, 0, 0.6, 0)
    keyFrame.BackgroundTransparency = 1
    keyFrame.Visible = false
    keyFrame.Parent = mainFrame
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, 0, 0, 30)
    keyBox.Position = UDim2.new(0, 0, 0, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    keyBox.BorderSizePixel = 2
    keyBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
    keyBox.PlaceholderText = "Enter key"
    keyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 14
    keyBox.Parent = keyFrame
    
    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 6)
    keyBoxCorner.Parent = keyBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, 0, 0, 30)
    submitBtn.Position = UDim2.new(0, 0, 0, 35)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitBtn.Text = "ENTER"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14
    submitBtn.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitBtn
    
    -- Animate loading
    spawn(function()
        for i = 0, 100, 2 do
            loadingBar:TweenSize(UDim2.new(i/100, 0, 1, 0), "Out", "Quad", 0.05, true)
            loadingText.Text = "Loading... " .. i .. "%"
            wait(0.05)
        end
        loadingText.Text = ""
        loadingBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        keyFrame.Visible = true
    end)
    
    -- Key validation
    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == PREMIUM_KEY then
            KEY_VALIDATED = true
            -- Fade out loading screen
            local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                loadingGui:Destroy()
                createMainUI()
            end)
            print("[KEY] ✅ Valid key entered")
        else
            keyBox.Text = ""
            keyBox.PlaceholderText = "Invalid key"
            keyBox.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    return loadingGui
end

-- ========== MAIN UI - CLEAN, JUST ONE BUTTON ==========
function createMainUI()
    if playerGui:FindFirstChild("DupeQuest") then
        playerGui.DupeQuest:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DupeQuest"
    screenGui.Parent = playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Main frame with fade in
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    -- Fade in animation
    local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0})
    fadeIn:Play()
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 60, 120)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 30, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 25))
    })
    gradient.Rotation = 135
    gradient.Parent = mainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Header (draggable)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 160)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 40, 100))
    })
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    headerCorner.Parent = header
    
    -- Drag handle
    local dragHandle = Instance.new("TextButton")
    dragHandle.Size = UDim2.new(1, 0, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.ZIndex = 10
    dragHandle.Parent = header
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            header.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            header.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "DUPE QUEST"
    title.TextColor3 = Color3.fromRGB(150, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- CLOSE BUTTON with X symbol
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0.5, -10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    -- DISCORD BUTTON (circle)
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 25, 0, 25)
    discordBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "D"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 14
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = header
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(1, 0)
    discordCorner.Parent = discordBtn
    
    discordBtn.MouseEnter:Connect(function()
        discordBtn.BackgroundColor3 = Color3.fromRGB(108, 121, 252)
    end)
    
    discordBtn.MouseLeave:Connect(function()
        discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)
    
    
    -- BIG QUEST BUTTON
    local questBtn = Instance.new("TextButton")
    questBtn.Size = UDim2.new(0.8, 0, 0, 40)
    questBtn.Position = UDim2.new(0.1, 0, 0.5, -20)
    questBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    questBtn.Text = "COMPLETE QUEST"
    questBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    questBtn.Font = Enum.Font.GothamBold
    questBtn.TextSize = 12
    questBtn.Parent = mainFrame
    
    local questCorner = Instance.new("UICorner")
    questCorner.CornerRadius = UDim.new(0, 8)
    questCorner.Parent = questBtn
    
    questBtn.MouseEnter:Connect(function()
        questBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 230)
    end)
    
    questBtn.MouseLeave:Connect(function()
        questBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end)
    
    questBtn.MouseButton1Click:Connect(function()
        completeQuest()
        questBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        wait(0.1)
        questBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end)
    
    return screenGui
end

-- ========== INIT ==========
print("\n" .. string.rep("=", 40))
print("DUPE QUEST - FINAL CLEAN VERSION")
print(string.rep("=", 40))
print("\n🔑 KEY:", PREMIUM_KEY)
print("\n✨ One button does everything")

-- Get current values
getCurrentLevel()
getMoney()
getAllStats()

-- Start loading screen
createLoadingScreen()

-- Export command
_G.DupeQuest = {
    key = PREMIUM_KEY,
    complete = completeQuest
}

print("\n📋 Command: _G.DupeQuest.complete()")
print("\n🔑 KEY:", PREMIUM_KEY)
