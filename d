local Library = {}

-- Tạo cửa sổ
function Library:CreateWindow(config)
    local Window = {}

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = config.Title or "Window"
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = config.Size or UDim2.new(0, 500, 0, 400)
    MainFrame.Position = config.Center and UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2) or UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    -- Bo góc và đổ bóng
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 0)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
    TitleBar.Text = config.Title or "Window"
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextScaled = true
    TitleBar.Parent = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0.25, 0, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sidebar.Parent = MainFrame

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(0.75, 0, 1, 0)
    Content.Position = UDim2.new(0.25, 0, 0, 0)
    Content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Content.Parent = MainFrame

    -- Tính năng di chuyển cửa sổ
    local dragging = false
    local dragStart = Vector2.new()
    local startPosition = UDim2.new()

    TitleBar.MouseButton1Down:Connect(function(x, y)
        dragging = true
        dragStart = Vector2.new(x, y)
        startPosition = MainFrame.Position
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging then
            local delta = Vector2.new(input.Position.X - dragStart.X, input.Position.Y - dragStart.Y)
            MainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Hiển thị cửa sổ
    if config.AutoShow then
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    -- Trả về window
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.Content = Content

    return Window
end

-- Thêm Button
function Library:AddButton(window, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0.1, 0)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextScaled = true
    Button.Parent = window.Content

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- Thêm Toggle
function Library:AddToggle(window, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0.9, 0, 0.1, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.Parent = window.Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextScaled = true
    Label.Parent = Toggle

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextScaled = true
    ToggleButton.Parent = Toggle

    ToggleButton.MouseButton1Click:Connect(function()
        default = not default
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(default)
    end)
end

return Library
