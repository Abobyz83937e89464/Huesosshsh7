-- Morpheus_Cheat_Menu.lua
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Удаляем старые GUI
if CoreGui:FindFirstChild("MorpheusMenu") then
    CoreGui.MorpheusMenu:Destroy()
end

-- ============== НАСТРОЙКИ ==============
local MENU_TITLE = "MORPHEUS CHEAT"
local IS_MINIMIZED = false
local MINIMIZED_WIDTH = 60
local NORMAL_WIDTH = 320
local MENU_HEIGHT = 450

-- ============== ОСНОВНОЕ МЕНЮ ==============
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "MorpheusMenu"
MenuGui.Parent = CoreGui
MenuGui.ResetOnSpawn = false
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, NORMAL_WIDTH, 0, MENU_HEIGHT)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30) -- Фиолетово-чёрный
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
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

-- ============== ВЕРХНЯЯ ПАНЕЛЬ ==============
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 30, 60) -- Фиолетовый
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 2

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = MENU_TITLE
Title.TextColor3 = Color3.fromRGB(180, 120, 255) -- Фиолетовый текст
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопка сворачивания
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeButton.Text = "–"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Parent = TopBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 150)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = TopBar

TopBar.Parent = MainFrame

-- ============== КОНТЕНТ ==============
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Прокрутка
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 255)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = ContentFrame

-- ============== ФУНКЦИИ ЧИТОВ ==============
local Cheats = {
    Fly = {Active = false, Speed = 35},
    ESP = {Active = false},
    Speed = {Active = false, Value = 50},
    Jump = {Active = false, Value = 120},
    Noclip = {Active = false}
}

-- FLY
local FlyBodyVelocity, FlyConnection
local function UpdateFly(state)
    Cheats.Fly.Active = state
    
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local Torso = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not Torso then return end
    
    if state then
        Humanoid.PlatformStand = true
        
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        FlyBodyVelocity.P = 10000
        FlyBodyVelocity.Parent = Torso
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not Cheats.Fly.Active or not FlyBodyVelocity or not FlyBodyVelocity.Parent then return end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Используем встроенный джойстик
            if UserInputService.TouchEnabled then
                moveDirection = Humanoid.MoveDirection
            else
                -- Для ПК клавиши
                local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
                local backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
                local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
                local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
                local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
                local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0
                
                local Camera = workspace.CurrentCamera
                if Camera then
                    local lookVector = Camera.CFrame.LookVector
                    local rightVector = Camera.CFrame.RightVector
                    
                    moveDirection = (lookVector * (forward - backward)) + 
                                   (rightVector * (right - left)) + 
                                   (Vector3.new(0, 1, 0) * (up - down))
                end
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
                FlyBodyVelocity.Velocity = moveDirection * Cheats.Fly.Speed
            else
                FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        
        print("[MORPHEUS] Fly: ON")
    else
        Humanoid.PlatformStand = false
        
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        
        print("[MORPHEUS] Fly: OFF")
    end
end

-- ESP
local ESPFolder
local ESPConnections = {}
local function UpdateESP(state)
    Cheats.ESP.Active = state
    
    if state then
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "MorpheusESP"
        ESPFolder.Parent = game.CoreGui
        
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local function UpdatePlayerESP(player)
            if player == LocalPlayer then return end
            
            local character = player.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Удаляем старый ESP
            if ESPConnections[player] then
                ESPConnections[player]:Disconnect()
                ESPConnections[player] = nil
            end
            
            -- Бокс
            local Box = Instance.new("BoxHandleAdornment")
            Box.Name = player.Name .. "_ESP"
            Box.Adornee = humanoidRootPart
            Box.AlwaysOnTop = true
            Box.ZIndex = 5
            Box.Size = Vector3.new(4, 6, 4)
            Box.Color3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80)
            Box.Transparency = 0.5
            Box.Parent = ESPFolder
            
            -- Имя
            local NameTag = Instance.new("BillboardGui")
            NameTag.Name = player.Name .. "_Name"
            NameTag.Adornee = humanoidRootPart
            NameTag.Size = UDim2.new(0, 200, 0, 40)
            NameTag.StudsOffset = Vector3.new(0, 4, 0)
            NameTag.AlwaysOnTop = true
            NameTag.Parent = ESPFolder
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = player.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 14
            TextLabel.Parent = NameTag
            
            -- Обновление
            local connection = RunService.RenderStepped:Connect(function()
                if not character or not humanoidRootPart or not humanoidRootPart.Parent then
                    Box:Destroy()
                    NameTag:Destroy()
                    connection:Disconnect()
                    return
                end
                
                if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
                    local distance = math.floor((humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    TextLabel.Text = player.Name .. " (" .. distance .. ")"
                end
            end)
            
            ESPConnections[player] = connection
        end
        
        -- Инициализация ESP
        for _, player in pairs(Players:GetPlayers()) do
            UpdatePlayerESP(player)
        end
        
        -- Подписки
        Players.PlayerAdded:Connect(function(player)
            UpdatePlayerESP(player)
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            if ESPConnections[player] then
                ESPConnections[player]:Disconnect()
                ESPConnections[player] = nil
            end
        end)
        
        print("[MORPHEUS] ESP: ON")
    else
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        
        for player, connection in pairs(ESPConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        ESPConnections = {}
        
        print("[MORPHEUS] ESP: OFF")
    end
end

-- SPEED
local OriginalWalkSpeed = 16
local function UpdateSpeed(state)
    Cheats.Speed.Active = state
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    if state then
        OriginalWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = Cheats.Speed.Value
        print("[MORPHEUS] Speed: ON (" .. Cheats.Speed.Value .. ")")
    else
        Humanoid.WalkSpeed = OriginalWalkSpeed
        print("[MORPHEUS] Speed: OFF")
    end
end

-- JUMP
local OriginalJumpPower = 50
local function UpdateJump(state)
    Cheats.Jump.Active = state
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    if state then
        OriginalJumpPower = Humanoid.JumpPower
        Humanoid.JumpPower = Cheats.Jump.Value
        print("[MORPHEUS] Jump: ON (" .. Cheats.Jump.Value .. ")")
    else
        Humanoid.JumpPower = OriginalJumpPower
        print("[MORPHEUS] Jump: OFF")
    end
end

-- NOCLIP
local NoclipConnection
local function UpdateNoclip(state)
    Cheats.Noclip.Active = state
    
    if state then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("[MORPHEUS] Noclip: ON")
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        print("[MORPHEUS] Noclip: OFF")
    end
end

-- ============== СОЗДАНИЕ ИНТЕРФЕЙСА ==============
local ToggleButtons = {}

local function CreateCategory(title, yOffset)
    local Category = Instance.new("Frame")
    Category.Size = UDim2.new(1, 0, 0, 35)
    Category.Position = UDim2.new(0, 0, 0, yOffset)
    Category.BackgroundTransparency = 1
    
    local CategoryTitle = Instance.new("TextLabel")
    CategoryTitle.Size = UDim2.new(1, 0, 1, 0)
    CategoryTitle.Text = "───── " .. title .. " ─────"
    CategoryTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
    CategoryTitle.Font = Enum.Font.GothamBold
    CategoryTitle.TextSize = 14
    CategoryTitle.BackgroundTransparency = 1
    CategoryTitle.TextXAlignment = Enum.TextXAlignment.Center
    CategoryTitle.Parent = Category
    
    Category.Parent = ScrollingFrame
    return Category
end

local function CreateToggleButton(name, desc, cheatKey, yOffset)
    local Button = Instance.new("Frame")
    Button.Name = cheatKey .. "_Button"
    Button.Size = UDim2.new(1, 0, 0, 55)
    Button.Position = UDim2.new(0, 0, 0, yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Текст
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.Size = UDim2.new(0.7, -10, 0.6, 0)
    TextLabel.Position = UDim2.new(0, 12, 0, 5)
    TextLabel.Text = name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 15
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0.7, -10, 0.4, 0)
    DescLabel.Position = UDim2.new(0, 12, 0.6, 0)
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Button
    
    -- Переключатель
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(0, 55, 0, 28)
    ToggleFrame.Position = UDim2.new(1, -65, 0.5, -14)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    ToggleFrame.BorderSizePixel = 0
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Name = "ToggleDot"
    ToggleDot.Size = UDim2.new(0, 24, 0, 24)
    ToggleDot.Position = UDim2.new(0, 2, 0.5, -12)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
    ToggleDot.BorderSizePixel = 0
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = ToggleDot
    ToggleDot.Parent = ToggleFrame
    ToggleFrame.Parent = Button
    
    Button.Parent = ScrollingFrame
    
    -- Функции кнопки
    local function UpdateToggle()
        local active = Cheats[cheatKey].Active
        
        if active then
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -26, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(120, 255, 150)
            }):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 100, 60)
            }):Play()
            TextLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
        else
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(255, 100, 150)
            }):Play()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 50, 80)
            }):Play()
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    local function OnClick()
        local newState = not Cheats[cheatKey].Active
        
        -- Обновляем чит
        if cheatKey == "Fly" then
            UpdateFly(newState)
        elseif cheatKey == "ESP" then
            UpdateESP(newState)
        elseif cheatKey == "Speed" then
            UpdateSpeed(newState)
        elseif cheatKey == "Jump" then
            UpdateJump(newState)
        elseif cheatKey == "Noclip" then
            UpdateNoclip(newState)
        end
        
        UpdateToggle()
    end
    
    -- Клики
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(45, 35, 65)
            }):Play()
        end
    end)
    
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(35, 25, 50)
            }):Play()
            task.wait(0.05)
            OnClick()
        end
    end)
    
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            OnClick()
        end
    end)
    
    UpdateToggle()
    ToggleButtons[cheatKey] = {
        Button = Button,
        Update = UpdateToggle
    }
    
    return Button
end

-- Создание интерфейса
local yOffset = 0

-- VISUAL
CreateCategory("VISUAL", yOffset)
yOffset = yOffset + 40

CreateToggleButton("ESP / WALLHACK", "See players through walls", "ESP", yOffset)
yOffset = yOffset + 60

-- MOVEMENT
CreateCategory("MOVEMENT", yOffset)
yOffset = yOffset + 40

CreateToggleButton("FLY", "Fly using joystick/keys", "Fly", yOffset)
yOffset = yOffset + 60

CreateToggleButton("SPEED (x3)", "Increase movement speed", "Speed", yOffset)
yOffset = yOffset + 60

CreateToggleButton("JUMP (x2)", "Higher jumps", "Jump", yOffset)
yOffset = yOffset + 60

CreateToggleButton("NOCLIP", "Walk through walls", "Noclip", yOffset)
yOffset = yOffset + 60

-- Обновляем размер прокрутки
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)

-- ============== СВОРАЧИВАНИЕ МЕНЮ ==============
local function ToggleMinimize()
    IS_MINIMIZED = not IS_MINIMIZED
    
    if IS_MINIMIZED then
        -- Сворачиваем
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, MINIMIZED_WIDTH, 0, 40)
        }):Play()
        
        TweenService:Create(ContentFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
        
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
        Title.Text = "MC"
    else
        -- Разворачиваем
        ContentFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, NORMAL_WIDTH, 0, MENU_HEIGHT)
        }):Play()
        
        TweenService:Create(ContentFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
        
        MinimizeButton.Text = "–"
        Title.Text = MENU_TITLE
    end
end

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
MinimizeButton.TouchTap:Connect(ToggleMinimize)

-- ============== ПЕРЕТАСКИВАНИЕ ==============
local dragging = false
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        TweenService:Create(TopBar, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(50, 40, 75)
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
            BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        }):Play()
    end
end)

-- ============== ЗАКРЫТИЕ ==============
CloseButton.MouseButton1Click:Connect(function()
    -- Деактивируем все читы
    if Cheats.Fly.Active then UpdateFly(false) end
    if Cheats.ESP.Active then UpdateESP(false) end
    if Cheats.Speed.Active then UpdateSpeed(false) end
    if Cheats.Jump.Active then UpdateJump(false) end
    if Cheats.Noclip.Active then UpdateNoclip(false) end
    
    -- Удаляем GUI
    MenuGui:Destroy()
    print("[MORPHEUS] Menu closed")
end)

CloseButton.TouchTap:Connect(function()
    if Cheats.Fly.Active then UpdateFly(false) end
    if Cheats.ESP.Active then UpdateESP(false) end
    if Cheats.Speed.Active then UpdateSpeed(false) end
    if Cheats.Jump.Active then UpdateJump(false) end
    if Cheats.Noclip.Active then UpdateNoclip(false) end
    
    MenuGui:Destroy()
    print("[MORPHEUS] Menu closed")
end)

-- ============== АВТОСБРОС ПРИ СМЕРТИ ==============
Player.CharacterAdded:Connect(function()
    -- Сбрасываем визуальные состояния
    for cheatKey, _ in pairs(Cheats) do
        Cheats[cheatKey].Active = false
        if ToggleButtons[cheatKey] then
            ToggleButtons[cheatKey].Update()
        end
    end
    
    -- Физически выключаем
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    print("[MORPHEUS] Character reset")
end)

print("[MORPHEUS] Cheat Menu Loaded!")
print("[MORPHEUS] Drag to move | Click - to minimize")
]])()
