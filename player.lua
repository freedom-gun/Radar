local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

-- MAIN GUI (SAMA PERSIS)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HamimSfy"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local enemyFrame = Instance.new("Frame")
enemyFrame.Size = UDim2.new(0, 260, 0, 300)
enemyFrame.Position = UDim2.new(1, -280, 0, 20)
enemyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
enemyFrame.BackgroundTransparency = 0.6
enemyFrame.BorderSizePixel = 0
enemyFrame.Active = true
enemyFrame.Draggable = true
enemyFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = enemyFrame

-- HEADERS & CONTROLS (SAMA PERSIS)
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = "HAMIMSFY"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
header.BackgroundTransparency = 0.4
header.TextSize = 14
header.Font = Enum.Font.GothamBold
header.Parent = enemyFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- TOMBOL RANGE (SAMA PERSIS)
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

-- TOMBOL CLOSE (SAMA PERSIS)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 25)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.Text = "❌"
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

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    screenGui:Destroy()
    players = {}
    currentIndex = 1
end)

-- SCROLL LIST (SAMA PERSIS)
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

-- **UBAHAN 1: DETECTOR PLAYER (BUANG MOB LOGIC)**
local players = {}
local currentIndex = 1

local function isTargetPlayer(plr)
    -- KECUALI PLAYER SENDIRI
    if plr == player then return false end
    if not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
    return humanoid and rootPart and humanoid.Health > 0
end

local function updatePlayers()
    players = {}
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local charRoot = player.Character.HumanoidRootPart.Position

    -- SCAN SEMUA PLAYER KECUALI DIRI SENDIRI
    for _, plr in ipairs(Players:GetPlayers()) do
        if isTargetPlayer(plr) then
            local rootPart = plr.Character.HumanoidRootPart
            local dist = (rootPart.Position - charRoot).Magnitude
            if dist <= MAX_DISTANCE then
                table.insert(players, {
                    player=plr, 
                    name=plr.Name, 
                    distance=dist, 
                    rootPart=rootPart
                })
            end
        end
    end

    table.sort(players, function(a, b) return a.distance < b.distance end)
end

-- Populate list (SAMA PERSIS, TAPI GUNAKAN players)
local function populateList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end

    if #players == 0 then
        local noPlayer = Instance.new("TextLabel")
        noPlayer.Size = UDim2.new(1, 0, 0, 45)
        noPlayer.Text = "No players nearby"
        noPlayer.TextColor3 = Color3.fromRGB(100, 255, 100)
        noPlayer.TextSize = 12
        noPlayer.BackgroundTransparency = 1
        noPlayer.Font = Enum.Font.Gotham
        noPlayer.TextWrapped = true
        noPlayer.Parent = scrollFrame
    else
        for _, target in ipairs(players) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = string.format("%s %.0fm", target.name, target.distance)
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
                if target.rootPart and player.Character then
                    player.Character.HumanoidRootPart.CFrame = target.rootPart.CFrame + target.rootPart.CFrame.LookVector * 4
                end
            end)
        end
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

-- Update loop (SAMA PERSIS, TAPI GUNAKAN updatePlayers)
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate > 1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        lastUpdate = tick()
        updatePlayers()
        populateList()
        currentIndex = math.min(currentIndex, #players)
        if #players == 0 then currentIndex = 1 end
    end
end)

-- Toggle button (SAMA PERSIS)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 25)
toggleBtn.Position = UDim2.new(1, -55, 0, 25)
toggleBtn.Text = "RADAR"
toggleBtn.TextSize = 10
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
    toggleBtn.Text = visible and "RADAR" or "OFF"
end)

-- NEXT button (SAMA PERSIS, TAPI GUNAKAN players)
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
    if #players == 0 then return end
    if currentIndex > #players then currentIndex = 1 end
    local target = players[currentIndex]
    if target.rootPart and player.Character then
        player.Character.HumanoidRootPart.CFrame = target.rootPart.CFrame + target.rootPart.CFrame.LookVector * 4
    end
    currentIndex = currentIndex + 1
    if currentIndex > #players then currentIndex = 1 end
end)
