local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Flying = false
local FlySpeed = 50
local BodyVelocity
local FlyConnection

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyToggleButton"
FlyButton.Size = UDim2.new(0, 100, 0, 50)
FlyButton.Position = UDim2.new(0.5, -50, 0.9, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyButton.BorderSizePixel = 2
FlyButton.BorderColor3 = Color3.fromRGB(0, 120, 255)
FlyButton.Text = "FLY: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 16
FlyButton.ZIndex = 10
FlyButton.Parent = ScreenGui

local MoveButtons = {}
local moveKeys = {
    W = {Text = "W", Key = Enum.KeyCode.W, Pos = UDim2.new(0.4, 0, 0.7, 0)},
    A = {Text = "A", Key = Enum.KeyCode.A, Pos = UDim2.new(0.3, 0, 0.8, 0)},
    S = {Text = "S", Key = Enum.KeyCode.S, Pos = UDim2.new(0.4, 0, 0.8, 0)},
    D = {Text = "D", Key = Enum.KeyCode.D, Pos = UDim2.new(0.5, 0, 0.8, 0)},
    Space = {Text = "⬆", Key = Enum.KeyCode.Space, Pos = UDim2.new(0.6, 0, 0.75, 0)},
    Shift = {Text = "⬇", Key = Enum.KeyCode.LeftShift, Pos = UDim2.new(0.7, 0, 0.75, 0)}
}

for name, data in pairs(moveKeys) do
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.Position = data.Pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = data.Text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Visible = false
    btn.ZIndex = 9
    btn.Parent = ScreenGui
    MoveButtons[name] = {Button = btn, Key = data.Key, Active = false}
end

local function UpdateButtonColors()
    if Flying then
        FlyButton.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
        FlyButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
        FlyButton.Text = "FLY: ON"
        FlyButton.TextColor3 = Color3.fromRGB(200, 255, 200)
        
        for _, btnData in pairs(MoveButtons) do
            btnData.Button.Visible = true
        end
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        FlyButton.BorderColor3 = Color3.fromRGB(0, 120, 255)
        FlyButton.Text = "FLY: OFF"
        FlyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        for _, btnData in pairs(MoveButtons) do
            btnData.Button.Visible = false
        end
    end
end

local function ToggleFly()
    Flying = not Flying
    
    if Flying then
        Humanoid.PlatformStand = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.P = 10000
        BodyVelocity.Parent = Torso
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not Flying or not BodyVelocity or not BodyVelocity.Parent then return end
            
            local Camera = workspace.CurrentCamera
            if not Camera then return end
            
            local LookVector = Camera.CFrame.LookVector
            local RightVector = Camera.CFrame.RightVector
            
            local Forward = 0
            local Backward = 0
            local Left = 0
            local Right = 0
            local Up = 0
            local Down = 0
            
            for _, btnData in pairs(MoveButtons) do
                if btnData.Active then
                    if btnData.Key == Enum.KeyCode.W then Forward = 1 end
                    if btnData.Key == Enum.KeyCode.S then Backward = 1 end
                    if btnData.Key == Enum.KeyCode.A then Left = 1 end
                    if btnData.Key == Enum.KeyCode.D then Right = 1 end
                    if btnData.Key == Enum.KeyCode.Space then Up = 1 end
                    if btnData.Key == Enum.KeyCode.LeftShift then Down = 1 end
                end
            end
            
            local Direction = (LookVector * (Forward - Backward)) + 
                             (RightVector * (Right - Left)) + 
                             (Vector3.new(0, 1, 0) * (Up - Down))
            
            if Direction.Magnitude > 0 then
                Direction = Direction.Unit
            end
            
            BodyVelocity.Velocity = Direction * FlySpeed
        end)
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "FLY ON",
            Text = "Use buttons to move",
            Duration = 3
        })
    else
        Humanoid.PlatformStand = false
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        
        for _, btnData in pairs(MoveButtons) do
            btnData.Active = false
            btnData.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "FLY OFF",
            Text = "Tap button to fly again",
            Duration = 3
        })
    end
    
    UpdateButtonColors()
end

FlyButton.MouseButton1Click:Connect(ToggleFly)

for _, btnData in pairs(MoveButtons) do
    local btn = btnData.Button
    btn.MouseButton1Down:Connect(function()
        btnData.Active = true
        btn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    end)
    
    btn.MouseButton1Up:Connect(function()
        btnData.Active = false
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    
    btn.MouseLeave:Connect(function()
        btnData.Active = false
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
end

local KeyConnection
KeyConnection = UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        ToggleFly()
    end
end)

Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    Torso = Character:WaitForChild("HumanoidRootPart")
    Flying = false
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    UpdateButtonColors()
end)

UpdateButtonColors()
