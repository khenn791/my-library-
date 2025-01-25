local Library = {}

function Library:CreateHub(title)
    local Hub = {}

    -- Main Frame
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "KhenHub"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.35, 0, 0.5, 0)
    MainFrame.Position = UDim2.new(0.325, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    -- Hiệu ứng bo góc
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Đổ bóng
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 0) -- Đường viền xanh
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
    TitleBar.Text = title
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextScaled = true
    TitleBar.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0.3, 0, 0.9, 0)
    Sidebar.Position = UDim2.new(0, 0, 0.1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sidebar.Parent = MainFrame

    -- Bo góc cho Sidebar
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(0.7, 0, 0.9, 0)
    Content.Position = UDim2.new(0.3, 0, 0.1, 0)
    Content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Content.Parent = MainFrame

    -- Bo góc cho Content
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = Content

    -- Sidebar layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Sidebar

    Hub.ScreenGui = ScreenGui
    Hub.MainFrame = MainFrame
    Hub.Content = Content
    return Hub
end

function Library:AddSidebarButton(window, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0.1, 0)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Font = Enum.Font.Gotham
    Button.TextScaled = true
    Button.Parent = window.MainFrame:FindFirstChild("Sidebar")

    -- Hiệu ứng bo góc
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

function Library:AddContentLabel(window, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextScaled = true
    Label.Parent = window.Content
end

function Library:AddToggle(window, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0.9, 0, 0.1, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

    -- Bo góc cho nút
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton

    local isOn = default
    ToggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        ToggleButton.Text = isOn and "ON" or "OFF"
        ToggleButton.TextColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        pcall(callback, isOn)
    end)
end

return Library