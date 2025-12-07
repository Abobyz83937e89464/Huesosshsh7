-- erafox_cheat_menu.lua
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- Удаляем старые GUI
if CoreGui:FindFirstChild("ERAFOX_MENU") then
    CoreGui.ERAFOX_MENU:Destroy()
end

-- ============== ОСНОВНОЕ МЕНЮ ==============
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "ERAFOX_MENU"
MenuGui.Parent = CoreGui
MenuGui.ResetOnSpawn = false
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм (можно перетаскивать)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Тень
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DropShadow.Size = UDim2.new(1, 24, 1, 24)
DropShadow.Position = UDim2.new(0, -12, 0, -12)
DropShadow.BackgroundTransparency = 1
DropShadow.Parent = MainFrame

MainFrame.Parent = MenuGui

-- Верхняя панель (для перетаскивания)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "ERAFOX CHEATS"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopBar

TopBar.Parent = MainFrame

-- Контейнер для кнопок
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "Content"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollingFrame.Parent = MainFrame

-- ============== ФУНКЦИИ МЕНЮ ==============

-- 1. FLY функция (использует игровой джойстик)
local FlyActive = false
local FlySpeed = 30
local FlyBodyVelocity
local FlyConnection

local function ToggleFly(state)
    FlyActive = state
    
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local Torso = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not Torso then return end
    
    if FlyActive then
        -- Активация полета
        Humanoid.PlatformStand = true
        
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        FlyBodyVelocity.P = 10000
        FlyBodyVelocity.Parent = Torso
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyActive or not FlyBodyVelocity or not FlyBodyVelocity.Parent then return end
            
            -- Получаем направление от виртуального джойстика
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Используем Touchpad для мобильных
            if UserInputService.TouchEnabled then
                -- Для мобильных: используем MoveDirection из Humanoid
                moveDirection = Humanoid.MoveDirection
            else
                -- Для ПК: используем клавиши WASD
                local forward = 0
                local backward = 0
                local left = 0
                local right = 0
                local up = 0
                local down = 0
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then forward = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then backward = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then left = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then right = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then up = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then down = 1 end
                
                local Camera = workspace.CurrentCamera
                if Camera then
                    local lookVector = Camera.CFrame.LookVector
                    local rightVector = Camera.CFrame.RightVector
                    
                    moveDirection = (lookVector * (forward - backward)) + 
                                   (rightVector * (right - left)) + 
                                   (Vector3.new(0, 1, 0) * (up - down))
                end
            end
            
            -- Если есть направление движения от джойстика/клавиш
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
                FlyBodyVelocity.Velocity = moveDirection * FlySpeed
            else
                FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        
        print("[ERAFOX] Fly: ON")
    else
        -- Деактивация полета
        Humanoid.PlatformStand = false
        
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        
        print("[ERAFOX] Fly: OFF")
    end
end

-- 2. ESP функция
local ESPActive = false
local ESPFolder

local function ToggleESP(state)
    ESPActive = state
    
    if ESPActive then
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "ESP"
        ESPFolder.Parent = game.CoreGui
        
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        
        local function CreateESP(player)
            if player == LocalPlayer then return end
            
            local character = player.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Бокс
            local Box = Instance.new("BoxHandleAdornment")
            Box.Name = player.Name .. "_ESP"
            Box.Adornee = humanoidRootPart
            Box.AlwaysOnTop = true
            Box.ZIndex = 5
            Box.Size = Vector3.new(4, 6, 4)
            Box.Color3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
            Box.Transparency = 0.6
            Box.Parent = ESPFolder
            
            -- Имя
            local NameTag = Instance.new("BillboardGui")
            NameTag.Name = player.Name .. "_Name"
            NameTag.Adornee = humanoidRootPart
            NameTag.Size = UDim2.new(0, 200, 0, 50)
            NameTag.StudsOffset = Vector3.new(0, 4, 0)
            NameTag.AlwaysOnTop = true
            NameTag.Parent = ESPFolder
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = player.Name .. " (" .. math.floor((humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. ")"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 14
            TextLabel.Parent = NameTag
            
            -- Обновление позиции
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not character or not humanoidRootPart or not humanoidRootPart.Parent then
                    connection:Disconnect()
                    Box:Destroy()
                    NameTag:Destroy()
                    return
                end
                
                if TextLabel then
                    TextLabel.Text = player.Name .. " (" .. math.floor((humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. ")"
                end
            end)
        end
        
        -- Создать ESP для всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        -- Подписка на новых игроков
        Players.PlayerAdded:Connect(function(player)
            CreateESP(player)
        end)
        
        print("[ERAFOX] ESP: ON")
    else
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        print("[ERAFOX] ESP: OFF")
    end
end

-- 3. SPEED функция
local SpeedActive = false
local OriginalWalkSpeed = 16

local function ToggleSpeed(state)
    SpeedActive = state
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    if SpeedActive then
        OriginalWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = 50
        print("[ERAFOX] Speed: ON (50)")
    else
        Humanoid.WalkSpeed = OriginalWalkSpeed
        print("[ERAFOX] Speed: OFF")
    end
end

-- 4. JUMP функция
local JumpActive = false
local OriginalJumpPower = 50

local function ToggleJump(state)
    JumpActive = state
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    if JumpActive then
        OriginalJumpPower = Humanoid.JumpPower
        Humanoid.JumpPower = 120
        print("[ERAFOX] Jump: ON (120)")
    else
        Humanoid.JumpPower = OriginalJumpPower
        print("[ERAFOX] Jump: OFF")
    end
end

-- 5. NOCLIP функция
local NoclipActive = false
local NoclipConnection

local function ToggleNoclip(state)
    NoclipActive = state
    
    if NoclipActive then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("[ERAFOX] Noclip: ON")
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        print("[ERAFOX] Noclip: OFF")
    end
end

-- ============== СОЗДАНИЕ КНОПОК МЕНЮ ==============

local function CreateCategory(title, yOffset)
    local Category = Instance.new("Frame")
    Category.Size = UDim2.new(1, 0, 0, 40)
    Category.Position = UDim2.new(0, 0, 0, yOffset)
    Category.BackgroundTransparency = 1
    
    local CategoryTitle = Instance.new("TextLabel")
    CategoryTitle.Size = UDim2.new(1, 0, 1, 0)
    CategoryTitle.Text = "━━━ " .. title .. " ━━━"
    CategoryTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
    CategoryTitle.Font = Enum.Font.GothamBold
    CategoryTitle.TextSize = 14
    CategoryTitle.BackgroundTransparency = 1
    CategoryTitle.TextXAlignment = Enum.TextXAlignment.Center
    CategoryTitle.Parent = Category
    
    Category.Parent = ScrollingFrame
    return Category
end

local function CreateToggleButton(name, desc, initialState, callback, yOffset)
    local Button = Instance.new("Frame")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Position = UDim2.new(0, 0, 0, yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    Button.BackgroundTransparency = 0.3
    Button.BorderSizePixel = 0
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Текст
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0.7, -10, 1, 0)
    TextLabel.Position = UDim2.new(0, 10, 0, 0)
    TextLabel.Text = name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0.7, -10, 0, 20)
    DescLabel.Position = UDim2.new(0, 10, 0, 25)
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 11
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Button
    
    -- Переключатель
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 50, 0, 25)
    ToggleFrame.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleFrame.BorderSizePixel = 0
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Size = UDim2.new(0, 21, 0, 21)
    ToggleDot.Position = UDim2.new(0, 2, 0.5, -10.5)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    ToggleDot.BorderSizePixel = 0
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = ToggleDot
    ToggleDot.Parent = ToggleFrame
    ToggleFrame.Parent = Button
    
    Button.Parent = ScrollingFrame
    
    local active = initialState
    
    local function UpdateToggle()
        if active then
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(80, 255, 80)
            }):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 100, 40)
            }):Play()
            TextLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        else
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            }):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            }):Play()
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    local function OnClick()
        active = not active
        UpdateToggle()
        if callback then
            callback(active)
        end
    end
    
    -- Клик по всей кнопке
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            }):Play()
        end
    end)
    
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(30, 35, 45)
            }):Play()
            OnClick()
        end
    end)
    
    -- Клик по переключателю
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            OnClick()
        end
    end)
    
    UpdateToggle()
    if initialState and callback then
        callback(true)
    end
    
    return {
        SetActive = function(state)
            active = state
            UpdateToggle()
            if callback then
                callback(state)
            end
        end
    }
end

-- ============== СОЗДАНИЕ ИНТЕРФЕЙСА ==============

local yOffset = 0

-- Категория: VISUAL
CreateCategory("VISUAL", yOffset)
yOffset = yOffset + 45

local espToggle = CreateToggleButton("ESP / WALLHACK", "See players through walls", false, ToggleESP, yOffset)
yOffset = yOffset + 55

-- Категория: MOVEMENT
CreateCategory("MOVEMENT", yOffset)
yOffset = yOffset + 45

local flyToggle = CreateToggleButton("FLY", "Fly using joystick/keys", false, ToggleFly, yOffset)
yOffset = yOffset + 55

local speedToggle = CreateToggleButton("SPEED (x3)", "Increase movement speed", false, ToggleSpeed, yOffset)
yOffset = yOffset + 55

local jumpToggle = CreateToggleButton("JUMP (x2)", "Higher jumps", false, ToggleJump, yOffset)
yOffset = yOffset + 55

local noclipToggle = CreateToggleButton("NOCLIP", "Walk through walls", false, ToggleNoclip, yOffset)
yOffset = yOffset + 55

-- Категория: SETTINGS
CreateCategory("SETTINGS", yOffset)
yOffset = yOffset + 45

CreateToggleButton("HIDE MENU", "Toggle menu visibility", false, function(state)
    MainFrame.Visible = not state
end, yOffset)

yOffset = yOffset + 55

-- Обновляем размер прокрутки
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)

-- ============== ПЕРЕТАСКИВАНИЕ МЕНЮ ==============

local dragging = false
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        TweenService:Create(TopBar, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(35, 45, 55)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        TweenService:Create(TopBar, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(25, 35, 45)
        }):Play()
    end
end)

-- Закрытие меню
CloseButton.MouseButton1Click:Connect(function()
    MenuGui:Destroy()
    -- Деактивируем все функции при закрытии
    if FlyActive then ToggleFly(false) end
    if ESPActive then ToggleESP(false) end
    if SpeedActive then ToggleSpeed(false) end
    if JumpActive then ToggleJump(false) end
    if NoclipActive then ToggleNoclip(false) end
end)

CloseButton.TouchTap:Connect(function()
    MenuGui:Destroy()
    if FlyActive then ToggleFly(false) end
    if ESPActive then ToggleESP(false) end
    if SpeedActive then ToggleSpeed(false) end
    if JumpActive then ToggleJump(false) end
    if NoclipActive then ToggleNoclip(false) end
end)

-- Авто-обновление при смерти
Player.CharacterAdded:Connect(function()
    -- Сбрасываем состояния
    if FlyActive then
        ToggleFly(false)
        flyToggle.SetActive(false)
    end
    if ESPActive then
        -- ESP сам обновится через создание новых адорнов
    end
end)

print("[ERAFOX] Cheat Menu Loaded!")
print("[ERAFOX] Drag top bar to move menu")
