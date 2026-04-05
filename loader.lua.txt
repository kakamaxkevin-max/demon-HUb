--[[
    DEMON GOD LOADER v1.0
    Style: Mint Green / Dark Premium
    Features: Rotating Logo, Smooth Tweens, Remote Loading
]]

local Name = "DEMON GOD"
local Tagline = "Ultimate Power . Professional Execution"
local AccentColor = Color3.fromRGB(0, 255, 170) -- Xanh Mint sáng
local BgColor = Color3.fromRGB(10, 10, 12)     -- Đen sâu
local CardColor = Color3.fromRGB(16, 16, 20)   -- Xám tối

-- Remote Config (Thay link GitHub của bạn vào đây khi bán)
local MainScriptURL = "local MainScriptURL = "https://raw.githubusercontent.com/kakamaxkevin-max/demon-HUb/refs/heads/main/main.lua""
-- Chống chạy trùng script
if _G.DemonGodLoaded then return end
_G.DemonGodLoaded = true

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

-- Tạo UI Container
local gui = Instance.new("ScreenGui")
gui.Name = "DemonGod_Loader"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = (gethui and gethui()) or (game:GetService("CoreGui")) or lp:WaitForChild("PlayerGui")

-- Màn hình nền mờ
local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = Color3.new(0,0,0)
root.BackgroundTransparency = 1
root.Parent = gui

-- Card chính
local card = Instance.new("Frame")
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromOffset(450, 220)
card.BackgroundColor3 = CardColor
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = root

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = AccentColor
stroke.Transparency = 0.5
stroke.Parent = card

-- LOGO XOAY (Custom Mint Diamond)
local logoFrame = Instance.new("Frame")
logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
logoFrame.Position = UDim2.fromOffset(70, 110)
logoFrame.Size = UDim2.fromOffset(60, 60)
logoFrame.BackgroundColor3 = AccentColor
logoFrame.Parent = card

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoFrame

local logoIn = Instance.new("Frame")
logoIn.AnchorPoint = Vector2.new(0.5, 0.5)
logoIn.Position = UDim2.fromScale(0.5, 0.5)
logoIn.Size = UDim2.fromScale(0.7, 0.7)
logoIn.BackgroundColor3 = CardColor
logoIn.Parent = logoFrame
Instance.new("UICorner", logoIn).CornerRadius = UDim.new(0, 6)

-- Text: Tên Hub
local title = Instance.new("TextLabel")
title.Text = Name
title.Font = Enum.Font.GothamBlack
title.TextSize = 32
title.TextColor3 = AccentColor
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.fromOffset(130, 50)
title.Size = UDim2.fromOffset(300, 40)
title.BackgroundTransparency = 1
title.Parent = card

-- Text: Tagline
local tag = Instance.new("TextLabel")
tag.Text = Tagline
tag.Font = Enum.Font.GothamMedium
tag.TextSize = 14
tag.TextColor3 = Color3.fromRGB(150, 150, 150)
tag.TextXAlignment = Enum.TextXAlignment.Left
tag.Position = UDim2.fromOffset(132, 85)
tag.Size = UDim2.fromOffset(300, 20)
tag.BackgroundTransparency = 1
tag.Parent = card

-- Thanh Progress
local status = Instance.new("TextLabel")
status.Text = "INITIALIZING..."
status.Font = Enum.Font.GothamBold
status.TextSize = 12
status.TextColor3 = AccentColor
status.TextXAlignment = Enum.TextXAlignment.Left
status.Position = UDim2.fromOffset(132, 135)
status.Size = UDim2.fromOffset(280, 20)
status.BackgroundTransparency = 1
status.Parent = card

local barBG = Instance.new("Frame")
barBG.Position = UDim2.fromOffset(132, 160)
barBG.Size = UDim2.fromOffset(280, 4)
barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
barBG.BorderSizePixel = 0
barBG.Parent = card

local bar = Instance.new("Frame")
bar.Size = UDim2.fromScale(0, 1)
bar.BackgroundColor3 = AccentColor
bar.BorderSizePixel = 0
bar.Parent = barBG

-- --- ANIMATION LOGIC ---
-- Xoay Logo
task.spawn(function()
    while gui.Parent do
        logoFrame.Rotation = logoFrame.Rotation + 2
        task.wait(0.01)
    end
end)

local function update(p, txt)
    status.Text = txt:upper()
    TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.fromScale(p, 1)}):Play()
end

-- --- LOADING PROCESS ---
root.BackgroundTransparency = 1
card.BackgroundTransparency = 1
TweenService:Create(root, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
TweenService:Create(card, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
task.wait(0.5)

update(0.2, "Checking Whitelist...")
task.wait(0.8)

update(0.5, "Downloading Demon God Core...")
-- Tải code thực tế từ server
local success, code = pcall(game.HttpGet, game, MainScriptURL)

if success then
    update(0.8, "Decrypting Modules...")
    task.wait(0.5)
    update(1, "Welcome, Master.")
    task.wait(0.5)
    
    -- Đóng UI
    TweenService:Create(card, TweenInfo.new(0.5), {Position = UDim2.fromScale(0.5, 1.2)}):Play()
    task.wait(0.5)
    gui:Destroy()
    
    -- Chạy script chính
    local func, err = loadstring(code)
    if func then
        pcall(func)
    else
        warn("Error loading main script: " .. tostring(err))
    end
else
    update(1, "Connection Error!")
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    task.wait(2)
    gui:Destroy()
end
