-- =============================================
-- DEMON GOD HUB v1.0 - MAIN SCRIPT
-- =============================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DEMON GOD", "DarkTheme")

-- Tabs
local Tab1 = Window:NewTab("Player Mods")
local Tab2 = Window:NewTab("Visuals")
local Tab3 = Window:NewTab("Teleport")
local Tab4 = Window:NewTab("Misc")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Variables
local SpeedEnabled = false
local FlyEnabled = false
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local ESPEnabled = false

-- Cache functions
local function getChar()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function getHum()
    return getChar():WaitForChild("Humanoid")
end

local function getHRP()
    return getChar():WaitForChild("HumanoidRootPart")
end

-- =============================================
-- TAB 1: PLAYER MODS
-- =============================================
Tab1:NewSection("Movement")

-- Super Speed
local speedToggle = Tab1:NewToggle("Super Speed", "Tăng tốc độ chạy", function(state)
    SpeedEnabled = state
    getHum().WalkSpeed = state and 100 or 16
end)

Tab1:NewSlider("Speed Value", "Điều chỉnh tốc độ", 200, 16, function(value)
    if SpeedEnabled then
        getHum().WalkSpeed = value
    end
end)

-- Fly (Đã fix leak)
local flyBody = nil
local flyConnection = nil

Tab1:NewToggle("Fly", "Bay lượn (WASD + Space/Shift)", function(state)
    FlyEnabled = state
    local hrp = getHRP()

    if state then
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(4000, 4000, 4000)
        flyBody.Velocity = Vector3.new(0,0,0)
        flyBody.Parent = hrp

        flyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not hrp.Parent then return end
            
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0,0,0)
            local speed = 50

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, speed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, speed, 0) end

            flyBody.Velocity = move
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if flyBody then flyBody:Destroy() end
        flyConnection = nil
        flyBody = nil
    end
end)

-- Infinite Jump (Đã fix)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local hum = getHum()
        if hum then hum:ChangeState(3) end
    end
end)

Tab1:NewToggle("Infinite Jump", "Nhảy không giới hạn", function(state)
    InfiniteJumpEnabled = state
end)

-- Noclip
Tab1:NewToggle("Noclip", "Xuyên tường", function(state)
    NoclipEnabled = state
    task.spawn(function()
        while NoclipEnabled do
            local char = getChar()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            task.wait()
        end
    end)
end)

-- =============================================
-- TAB 2: VISUALS
-- =============================================
Tab2:NewSection("ESP")

Tab2:NewToggle("Player ESP", "Highlight người chơi", function(state)
    ESPEnabled = state
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if state then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 170)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- =============================================
-- TAB 3: TELEPORT
-- =============================================
Tab3:NewSection("Quick Teleport")

Tab3:NewButton("TP to Spawn", "Về spawn point", function()
    getHRP().CFrame = CFrame.new(0, 50, 0)
end)

Tab3:NewButton("TP to Random Player", "TP người chơi ngẫu nhiên", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local target = players[math.random(2, #players)]
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            getHRP().CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- =============================================
-- TAB 4: MISC
-- =============================================
Tab4:NewSection("Utilities")

Tab4:NewButton("Rejoin Server", "Vào lại server hiện tại", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)

Tab4:NewButton("Server Hop", "Nhảy sang server khác", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/serverhop"))()
end)

Tab4:NewKeybind("Toggle Menu", "Mở / Đóng menu", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

-- =============================================
-- NOTIFICATION
-- =============================================
Library:Notify("Demon God", "Hub đã load thành công!\nNhấn RightShift để mở menu.", 6)
print("✅ [Demon God] Hub loaded successfully!")
