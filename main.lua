-- Demon God Hub v1.0 - Main Script
-- Author: You (thay tên nếu muốn)
-- Load Kavo UI Library (ổn định 2026, hỗ trợ hầu hết executor)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DEMON GOD", "DarkTheme")

-- Sections (tabs trong menu)
local Tab1 = Window:NewTab("Player Mods")
local Tab2 = Window:NewTab("Visuals")
local Tab3 = Window:NewTab("Teleport")
local Tab4 = Window:NewTab("Misc")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- Variables
local InfiniteJumpEnabled = false
local SpeedEnabled = false
local FlyEnabled = false
local NoclipEnabled = false
local ESPEnabled = false

-- Functions
local function getCharacter()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char:WaitForChild("Humanoid")
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

-- TAB 1: Player Mods
local Section1 = Tab1:NewSection("Movement Hacks")
SpeedEnabled = Tab1:NewToggle("Super Speed", "Tăng tốc độ chạy", function(state)
    SpeedEnabled = state
    local hum = getHumanoid()
    if state then
        hum.WalkSpeed = 100
    else
        hum.WalkSpeed = 16
    end
end)

local SpeedSlider = Tab1:NewSlider("Speed Value", "Điều chỉnh tốc độ", 100, 16, function(s)
    if SpeedEnabled then
        local hum = getHumanoid()
        hum.WalkSpeed = s
    end
end)

FlyEnabled = Tab1:NewToggle("Fly", "Bay lượn tự do", function(state)
    FlyEnabled = state
    local char = getCharacter()
    local hrp = getHRP()
    local bg = Instance.new("BodyVelocity")
    bg.MaxForce = Vector3.new(4000, 4000, 4000)
    bg.Velocity = Vector3.new(0,0,0)
    bg.Parent = hrp

    if state then
        local speed = 50
        RunService.Heartbeat:Connect(function()
            if FlyEnabled and hrp.Parent then
                local cam = workspace.CurrentCamera
                local vel = bg
                vel.Velocity = (cam.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and speed or 0)) +
                               (cam.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.S) and -speed or 0)) +
                               (cam.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and speed or 0)) +
                               (cam.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.A) and -speed or 0)) +
                               (Vector3.new(0,1,0) * (UserInputService:IsKeyDown(Enum.KeyCode.Space) and speed or 0)) +
                               (Vector3.new(0,-1,0) * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and speed or 0))
            else
                bg:Destroy()
            end
        end)
    end
end)

InfiniteJumpEnabled = Tab1:NewToggle("Infinite Jump", "Nhảy không giới hạn", function(state)
    InfiniteJumpEnabled = state
    UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            local hum = getHumanoid()
            if hum then hum:ChangeState(3) end
        end
    end)
end)

NoclipEnabled = Tab1:NewToggle("Noclip", "Xuyên tường", function(state)
    NoclipEnabled = state
    task.spawn(function()
        while NoclipEnabled do
            local char = getCharacter()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            task.wait()
        end
    end)
end)

-- TAB 2: Visuals
local Section2 = Tab2:NewSection("ESP")
ESPEnabled = Tab2:NewToggle("Player ESP", "Highlight tất cả player", function(state)
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
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Auto ESP cho player mới
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(0, 255, 170)
            highlight.Parent = player.Character
        end
    end)
end)

-- TAB 3: Teleport
local Section3 = Tab3:NewSection("Quick TP")
Tab3:NewButton("TP to Spawn", "Teleport về spawn", function()
    local hrp = getHRP()
    hrp.CFrame = CFrame.new(0, 50, 0)
end)

Tab3:NewButton("TP to Random Player", "TP ngẫu nhiên", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local target = players[math.random(2, #players)]
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = getHRP()
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- TAB 4: Misc
local Section4 = Tab4:NewSection("Settings")
Tab4:NewButton("Rejoin Server", "Vào lại server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)

Tab4:NewButton("Server Hop", "Nhảy server khác", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/serverhop"))()
end)

Tab4:NewKeybind("Menu Key", "Mở/đóng menu", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

-- Notification khi load xong
Library:Notify("Demon God Loaded!", "Hub sẵn sàng sử dụng. RightShift để mở menu.", 5)
print("[Demon God] Hub loaded successfully!")
