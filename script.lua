local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

-- MAIN GUI - Pindah ke tengah saat pertama kali execute (2)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HamimSfy"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local enemyFrame = Instance.new("Frame")
enemyFrame.Size = UDim2.new(0, 260, 0, 300)
enemyFrame.Position = UDim2.new(0.5, -130, 0, 20)  -- Tengah layar
enemyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
enemyFrame.BackgroundTransparency = 0.6
enemyFrame.BorderSizePixel = 0
enemyFrame.Active = true
enemyFrame.Draggable = true
enemyFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = enemyFrame

-- HEADERS & CONTROLS - Hapus teks Hamimsfy (5)
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = ""  -- Kosong
header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
header.BackgroundTransparency = 0.4
header.TextSize = 14
header.Font = Enum.Font.GothamBold
header.Parent = enemyFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- TOMBOL RANGE di kiri atas dalam GUI
local MAX_DISTANCE = 200
local rangeOptions = {100, 200, 300, 400, 500}
local currentRangeIndex = 2

local rangeButton = Instance.new("TextButton")
rangeButton.Size = UDim2.new(0, 70, 0, 25)
rangeButton.Position = UDim2.new(0, 10, 0, 5)
rangeButton.Text = MAX_DISTANCE .. "m"
rangeButton.TextSize = 11
rangeButton.Font = Enum.Font.GothamBold
rangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
rangeButton.BackgroundTransparency = 0.4
rangeButton.BorderSizePixel = 0
rangeButton.Parent = enemyFrame

local rangeCorner = Instance.new("UICorner")
rangeCorner.CornerRadius = UDim.new(0, 8)
rangeCorner.Parent = rangeButton

rangeButton.MouseButton1Click:Connect(function()
    currentRangeIndex = currentRangeIndex + 1
    if currentRangeIndex > #rangeOptions then
        currentRangeIndex = 1
    end
    MAX_DISTANCE = rangeOptions[currentRangeIndex]
    rangeButton.Text = MAX_DISTANCE .. "m"
end)

-- TOMBOL PLAYER 👤 di kanan tombol range (1)
local playerButton = Instance.new("TextButton")
playerButton.Size = UDim2.new(0, 35, 0, 25)
playerButton.Position = UDim2.new(0, 90, 0, 5)
playerButton.Text = "Player"
playerButton.Font = Enum.Font.GothamBold
playerButton.TextSize = 12
playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
playerButton.BackgroundTransparency = 0.4
playerButton.BorderSizePixel = 0
playerButton.Parent = enemyFrame

local playerCorner = Instance.new("UICorner")
playerCorner.CornerRadius = UDim.new(0, 8)
playerCorner.Parent = playerButton

-- TOMBOL CLOSE ❌ di kanan dalam GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 25)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
closeButton.BackgroundTransparency = 0.4
closeButton.BorderSizePixel = 0
closeButton.Parent = enemyFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Player button functionality (3 & 4)
playerButton.MouseButton1Click:Connect(function()
    -- Reset mobs GUI (4)
    screenGui.Enabled = false
    screenGui:Destroy()
    enemies = {}
    currentIndex = 1
    
    -- Load player radar script (3)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/freedom-gun/Radar/main/player.lua"))()
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    screenGui:Destroy()
    enemies = {}
    currentIndex = 1
end)

-- SCROLL LIST
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -50)
scrollFrame.Position = UDim2.new(0, 8, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 200)
scrollFrame.Parent = enemyFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = scrollFrame

-- OPTIMASI 2: CACHE PLAYER LIST
local playerList = Players:GetPlayers()
Players.PlayerAdded:Connect(function() playerList = Players:GetPlayers() end)
Players.PlayerRemoving:Connect(function() playerList = Players:GetPlayers() end)

-- DETECTOR
local function isEnemy(model)
    if not model or model == player.Character then return false end

    for _, p in ipairs(playerList) do
        if model == p.Character then return false end
    end

    local humanoid = model:FindFirstChild("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")

    if not (humanoid and rootPart and humanoid.Health > 0) then return false end

    if model:FindFirstChild("PlayerGui") or (model:FindFirstChild("leaderstats") and model.leaderstats:FindFirstChild("Kills")) then
        return false
    end

    local name = model.Name:lower()
    local parentName = model.Parent.Name:lower()

    local enemyKeywords = {
        "zombie","skeleton","bandit","enemy","mob","monster","goblin","orc","troll","dragon","custom","bot","combatnpc","mobs","demon",
        "boss","enemys","guard","Enemies","killer","hunter","warrior","soldier","entity","NPC",
        "civilian","undead","ghoul","wraith","specter","vampire","werewolf","spider","scorpion",
        "slime","bat","fungus","hostile","npcenemy","alive","dummy","rat","wolf","bear","shark","pirate","thief","assassin","mutant",
        "alien","robot","drone","health","turret","minion","creep","wyvern","dragon"
    }
    for _, keyword in ipairs(enemyKeywords) do
        if string.find(name, keyword) or string.find(parentName, keyword) then return true end
    end

    local enemyFolders = {"enemies","mobs","monsters","zombie","spawns","enemy"}
    for _, folder in ipairs(enemyFolders) do
        if parentName:find(folder) then return true end
    end

    return true
end

-- OPTIMASI 1: COLLECTION SERVICE
local enemies = {}
local currentIndex = 1

local function updateEnemies()
    enemies = {}
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local charRoot = player.Character.HumanoidRootPart.Position

    local taggedEnemies = CollectionService:GetTagged("Enemy")
    if #taggedEnemies > 0 then
        for _, model in ipairs(taggedEnemies) do
            if isEnemy(model) then
                local humanoid = model:FindFirstChild("Humanoid")
                local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
                if rootPart then
                    local dist = (rootPart.Position - charRoot).Magnitude
                    if dist <= MAX_DISTANCE then
                        table.insert(enemies, {model=model, name=model.Name, distance=dist, rootPart=rootPart})
                    end
                end
            end
        end
    else
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and isEnemy(obj) then
                local humanoid = obj:FindFirstChild("Humanoid")
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("UpperTorso")
                if humanoid and rootPart then
                    local dist = (rootPart.Position - charRoot).Magnitude
                    if dist <= MAX_DISTANCE then
                        table.insert(enemies, {model=obj, name=obj.Name, distance=dist, rootPart=rootPart})
                    end
                end
            end
        end
    end

    table.sort(enemies, function(a, b) return a.distance < b.distance end)
end

local function populateList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end

    if #enemies == 0 then
        local noEnemy = Instance.new("TextLabel")
        noEnemy.Size = UDim2.new(1, 0, 0, 45)
        noEnemy.Text = "No mobs/NPCs nearby"
        noEnemy.TextColor3 = Color3.fromRGB(100, 255, 100)
        noEnemy.TextSize = 12
        noEnemy.BackgroundTransparency = 1
        noEnemy.Font = Enum.Font.Gotham
        noEnemy.TextWrapped = true
        noEnemy.Parent = scrollFrame
    else
        for _, enemy in ipairs(enemies) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = string.format("%s %.0fm", enemy.name, enemy.distance)
            btn.TextColor3 = Color3.fromRGB(255, 220, 100)
            btn.TextSize = 11
            btn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamSemibold
            btn.TextWrapped = true
            btn.Parent = scrollFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if enemy.rootPart and player.Character then
                    player.Character.HumanoidRootPart.CFrame = enemy.rootPart.CFrame + enemy.rootPart.CFrame.LookVector * 4
                end
            end)
        end
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate > 1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        lastUpdate = tick()
        updateEnemies()
        populateList()
        currentIndex = math.min(currentIndex, #enemies)
        if #enemies == 0 then currentIndex = 1 end
    end
end)

-- Toggle button - Ubah nama Mini dan ukuran sedang (5)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 35)  -- Ukuran sedang
toggleBtn.Position = UDim2.new(1, -70, 0, 25)
toggleBtn.Text = "Mini"  -- Ubah dari RADAR
toggleBtn.TextSize = 11
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    enemyFrame.Visible = visible
    toggleBtn.Text = visible and "Mini" or "Hamimsfy"  -- OFF jadi Hamimsfy
end)

-- NEXT button
local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 80, 0, 30)
nextBtn.Position = UDim2.new(1, -145, 0, 25)
nextBtn.Text = "NEXT"
nextBtn.TextSize = 12
nextBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nextBtn.BackgroundTransparency = 0.3
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Font = Enum.Font.GothamBold
nextBtn.Active = true
nextBtn.Draggable = true
nextBtn.Parent = screenGui

local nextCorner = Instance.new("UICorner")
nextCorner.CornerRadius = UDim.new(0, 8)
nextCorner.Parent = nextBtn

nextBtn.MouseButton1Click:Connect(function()
    if #enemies == 0 then return end
    if currentIndex > #enemies then currentIndex = 1 end
    local target = enemies[currentIndex]
    if target.rootPart and player.Character then
        player.Character.HumanoidRootPart.CFrame = target.rootPart.CFrame + target.rootPart.CFrame.LookVector * 4
    end
    currentIndex = currentIndex + 1
    if currentIndex > #enemies then currentIndex = 1 end
end)
