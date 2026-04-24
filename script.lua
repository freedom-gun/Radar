local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

-- MAIN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HamimSfy"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local enemyFrame = Instance.new("Frame")
enemyFrame.Size = UDim2.new(0, 260, 0, 300)
enemyFrame.Position = UDim2.new(0.5, -130, 0, 20)
enemyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
enemyFrame.BackgroundTransparency = 0.6
enemyFrame.BorderSizePixel = 0
enemyFrame.Active = true
enemyFrame.Draggable = true
enemyFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = enemyFrame

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = ""
header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
header.BackgroundTransparency = 0.4
header.TextSize = 14
header.Font = Enum.Font.GothamBold
header.Parent = enemyFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- RANGE BUTTON
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

-- PLAYER BUTTON
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

-- CLOSE BUTTON
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

-- Player button functionality
playerButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    screenGui:Destroy()
    enemies = {}
    currentIndex = 1
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

-- CACHE PLAYER LIST
local playerList = Players:GetPlayers()
Players.PlayerAdded:Connect(function() playerList = Players:GetPlayers() end)
Players.PlayerRemoving:Connect(function() playerList = Players:GetPlayers() end)

-- PREPARE ENEMY KEYWORDS HASH (for faster checking)
local enemyKeywords = {
    zombie = true, skeleton = true, bandit = true, enemy = true, mob = true, monster = true,
    goblin = true, orc = true, troll = true, dragon = true, custom = true, bot = true,
    combatnpc = true, mobs = true, demon = true, boss = true, enemys = true, guard = true,
    enemies = true, killer = true, hunter = true, warrior = true, soldier = true, entity = true,
    npc = true, civilian = true, undead = true, ghoul = true, wraith = true, specter = true,
    vampire = true, werewolf = true, spider = true, scorpion = true, slime = true, bat = true,
    fungus = true, hostile = true, npcenemy = true, alive = true, dummy = true, rat = true,
    wolf = true, bear = true, shark = true, pirate = true, thief = true, assassin = true,
    mutant = true, alien = true, robot = true, drone = true, health = true, turret = true,
    minion = true, creep = true, wyvern = true
}

local enemyFolders = {
    enemies = true, mobs = true, monsters = true, zombie = true, spawns = true, enemy = true
}

-- DETECTOR (FIXED: now returns true by default unless we can prove it's NOT an enemy)
local function isEnemy(model)
    if not model or model == player.Character then return false end

    -- Exclude other players
    for _, p in ipairs(playerList) do
        if model == p.Character then
            return false
        end
    end

    -- Exclude models that clearly belong to players (has PlayerGui or leaderstats with Kills)
    if model:FindFirstChild("PlayerGui") then
        return false
    end
    local leaderstats = model:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Kills") then
        return false
    end

    -- Require basic NPC components
    local humanoid = model:FindFirstChild("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("UpperTorso")
    if not (humanoid and rootPart and humanoid.Health > 0) then
        return false
    end

    -- Optional: if it matches known enemy keywords/folders, we are confident
    local nameLower = string.lower(model.Name)
    local parentNameLower = model.Parent and string.lower(model.Parent.Name) or ""

    for word in string.gmatch(nameLower, "[%a%d]+") do
        if enemyKeywords[word] then
            return true
        end
    end
    for word in string.gmatch(parentNameLower, "[%a%d]+") do
        if enemyKeywords[word] then
            return true
        end
        if enemyFolders[word] then
            return true
        end
    end

    -- If we reach here, it's not a player and has basic NPC parts → treat as enemy
    return true
end

-- ENEMY DATA
local enemies = {}
local currentIndex = 1

-- Button pool to avoid constant destroy/create
local enemyButtonsPool = {}
local noEnemyLabel

local function clearEnemyButtons()
    for _, btn in ipairs(enemyButtonsPool) do
        btn.Visible = false
    end
    if noEnemyLabel then
        noEnemyLabel.Visible = false
    end
end

local function getEnemyButton(index)
    local btn = enemyButtonsPool[index]
    if not btn then
        btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
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

        enemyButtonsPool[index] = btn
    end
    btn.Visible = true
    return btn
end

local function showNoEnemyLabel()
    if not noEnemyLabel then
        noEnemyLabel = Instance.new("TextLabel")
        noEnemyLabel.Size = UDim2.new(1, 0, 0, 45)
        noEnemyLabel.Text = "No mobs/NPCs nearby"
        noEnemyLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        noEnemyLabel.TextSize = 12
        noEnemyLabel.BackgroundTransparency = 1
        noEnemyLabel.Font = Enum.Font.Gotham
        noEnemyLabel.TextWrapped = true
        noEnemyLabel.Parent = scrollFrame
    end
    noEnemyLabel.Visible = true
end

-- UPDATE ENEMIES (limited frequency & scan radius)
local function updateEnemies()
    enemies = {}
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local charRootPos = root.Position
    local maxScanDist = MAX_DISTANCE + 50  -- slightly larger than MAX_DISTANCE for early rejection

    local taggedEnemies = CollectionService:GetTagged("Enemy")
    if #taggedEnemies > 0 then
        for _, model in ipairs(taggedEnemies) do
            if isEnemy(model) then
                local humanoid = model:FindFirstChild("Humanoid")
                local rootPart = model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChild("Torso")
                    or model:FindFirstChild("UpperTorso")
                if humanoid and rootPart then
                    local dist = (rootPart.Position - charRootPos).Magnitude
                    if dist <= MAX_DISTANCE then
                        table.insert(enemies, {
                            model = model,
                            name = model.Name,
                            distance = dist,
                            rootPart = rootPart
                        })
                    end
                end
            end
        end
    else
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local rootPart = obj:FindFirstChild("HumanoidRootPart")
                    or obj:FindFirstChild("Torso")
                    or obj:FindFirstChild("UpperTorso")
                if rootPart then
                    local dist = (rootPart.Position - charRootPos).Magnitude
                    if dist <= maxScanDist and isEnemy(obj) and dist <= MAX_DISTANCE then
                        table.insert(enemies, {
                            model = obj,
                            name = obj.Name,
                            distance = dist,
                            rootPart = rootPart
                        })
                    end
                end
            end
        end
    end

    table.sort(enemies, function(a, b) return a.distance < b.distance end)
end

local function populateList()
    clearEnemyButtons()

    if #enemies == 0 then
        showNoEnemyLabel()
    else
        for i, enemy in ipairs(enemies) do
            local btn = getEnemyButton(i)
            btn.Text = string.format("%s %.0fm", enemy.name, enemy.distance)

            if not btn:GetAttribute("Connected") then
                btn.MouseButton1Click:Connect(function()
                    local currentEnemy = enemies[i]
                    if currentEnemy and currentEnemy.rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame =
                            currentEnemy.rootPart.CFrame + currentEnemy.rootPart.CFrame.LookVector * 4
                    end
                end)
                btn:SetAttribute("Connected", true)
            end
        end
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

-- UPDATE LOOP (slightly reduced frequency for performance)
local lastUpdate = 0
local UPDATE_INTERVAL = 1.5  -- was 1.0; a bit slower but still responsive

RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate > UPDATE_INTERVAL then
        lastUpdate = tick()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            updateEnemies()
            populateList()
            currentIndex = math.min(currentIndex, #enemies)
            if #enemies == 0 then currentIndex = 1 end
        end
    end
end)

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 35)
toggleBtn.Position = UDim2.new(1, -70, 0, 25)
toggleBtn.Text = "Mini"
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
    toggleBtn.Text = visible and "Mini" or "Hamimsfy"
end)

-- NEXT BUTTON
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
    if target.rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame =
            target.rootPart.CFrame + target.rootPart.CFrame.LookVector * 4
    end
    currentIndex = currentIndex + 1
    if currentIndex > #enemies then currentIndex = 1 end
end)
