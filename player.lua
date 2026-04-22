local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- HEADER
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = ""
header.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    if currentRangeIndex > #rangeOptions then currentRangeIndex = 1 end
    MAX_DISTANCE = rangeOptions[currentRangeIndex]
    rangeButton.Text = MAX_DISTANCE .. "m"
end)

-- NPC BUTTON (FIX)
local npcButton = Instance.new("TextButton")
npcButton.Size = UDim2.new(0, 70, 0, 25)
npcButton.Position = UDim2.new(0, 85, 0, 5)
npcButton.Text = " Npc "
npcButton.TextSize = 11
npcButton.Font = Enum.Font.GothamBold
npcButton.TextColor3 = Color3.fromRGB(255, 255, 255)
npcButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
npcButton.BackgroundTransparency = 0.4
npcButton.BorderSizePixel = 0
npcButton.Parent = enemyFrame

local npcCorner = Instance.new("UICorner")
npcCorner.CornerRadius = UDim.new(0, 8)
npcCorner.Parent = npcButton

npcButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/freedom-gun/Radar/main/script.lua"))()
end)

-- CLOSE BUTTON
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
    screenGui:Destroy()
end)

-- SCROLLFRAME (SIMPLE & STABLE)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -55)
scrollFrame.Position = UDim2.new(0, 10, 0, 42)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 200)
scrollFrame.Parent = enemyFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- VARIABLES
local players = {}
local currentIndex = 1
local lastUpdate = 0

-- FUNCTIONS
local function isTargetPlayer(plr)
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

    for _, plr in ipairs(Players:GetPlayers()) do
        if isTargetPlayer(plr) then
            local rootPart = plr.Character.HumanoidRootPart
            local dist = (rootPart.Position - charRoot).Magnitude
            if dist <= MAX_DISTANCE then
                table.insert(players, {
                    player = plr,
                    name = plr.Name,
                    distance = dist,
                    rootPart = rootPart
                })
            end
        end
    end

    table.sort(players, function(a, b) 
        return a.distance < b.distance 
    end)
end

local function clearList()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function populateList()
    clearList()

    if #players == 0 then
        local noPlayer = Instance.new("TextLabel")
        noPlayer.Size = UDim2.new(1, 0, 0, 40)
        noPlayer.BackgroundTransparency = 1
        noPlayer.Text = "No players nearby"
        noPlayer.TextColor3 = Color3.fromRGB(100, 255, 100)
        noPlayer.TextSize = 12
        noPlayer.Font = Enum.Font.Gotham
        noPlayer.TextWrapped = true
        noPlayer.Parent = scrollFrame
    else
        for _, target in ipairs(players) do
            -- ROW FRAME
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundTransparency = 1
            row.Parent = scrollFrame

            -- HEAD IMAGE (TIDAK DIUBAH)
            local headImg = Instance.new("ImageLabel")
            headImg.Name = "Head"
            headImg.Size = UDim2.new(0, 26, 0, 26)
            headImg.Position = UDim2.new(0, 2, 0.5, -13)
            headImg.BackgroundTransparency = 1
            headImg.Parent = row
            
            pcall(function()
                headImg.Image = Players:GetUserThumbnailAsync(target.player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)

            local headCorner = Instance.new("UICorner")
            headCorner.CornerRadius = UDim.new(1, 13)
            headCorner.Parent = headImg

            -- NAME BUTTON (POSISI KEKANAN + SEPARATOR)
            local btn = Instance.new("TextButton")
            btn.Name = "PlayerBtn"
            btn.Size = UDim2.new(1, -35, 1, 0)
            btn.Position = UDim2.new(0, 42, 0, 0) -- DIPINDAH KEKANAN (dari 32 ke 42)
            btn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Text = target.name .. "  |  " .. math.floor(target.distance) .. "m" -- TAMBAH SEPARATOR "|"
            btn.TextColor3 = Color3.fromRGB(255, 220, 100)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamSemibold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = row

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if target.rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = target.rootPart.CFrame * CFrame.new(0, 0, -4)
                end
            end)
        end
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- MAIN LOOP (STABLE 1.5s)
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate > 1.5 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        lastUpdate = tick()
        updatePlayers()
        populateList()
    end
end)

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 70, 0, 25)
toggleBtn.Position = UDim2.new(1, -90, 0, 25)
toggleBtn.Text = "Hamimsfy"
toggleBtn.TextSize = 11
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local isVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    enemyFrame.Visible = isVisible
    toggleBtn.Text = isVisible and "Hamimsfy" or "Mini"
end)

-- NEXT BUTTON (Draggable FIXED)
local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 80, 0, 30)
nextBtn.Position = UDim2.new(1, -180, 0, 20)
nextBtn.Text = "NEXT"
nextBtn.TextSize = 12
nextBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nextBtn.BackgroundTransparency = 0.3
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Font = Enum.Font.GothamBold
nextBtn.Active = true
nextBtn.Draggable = true  -- FIXED
nextBtn.Parent = screenGui

local nextCorner = Instance.new("UICorner")
nextCorner.CornerRadius = UDim.new(0, 8)
nextCorner.Parent = nextBtn

nextBtn.MouseButton1Click:Connect(function()
    if #players == 0 then return end
    currentIndex = currentIndex + 1
    if currentIndex > #players then currentIndex = 1 end
    local target = players[currentIndex]
    if target and target.rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.rootPart.CFrame * CFrame.new(0, 0, -4)
    end
end)
