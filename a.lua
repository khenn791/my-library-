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


-- Thêm Tab vào Library
function Library:CreateTab(window, title)
    local Tab = {}

    -- Tạo Tab Button trên Sidebar
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0.1, 0)
    TabButton.Text = title
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextScaled = true
    TabButton.Parent = window.MainFrame:FindFirstChild("Sidebar")

    -- Tạo Tab Content
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContent.Visible = false
    TabContent.Parent = window.Content

    -- Bo góc và hiệu ứng
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = TabContent

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 0)
    UIStroke.Thickness = 2
    UIStroke.Parent = TabContent

    -- Khi TabButton được nhấn, nó sẽ hiển thị TabContent tương ứng
    TabButton.MouseButton1Click:Connect(function()
        for _, child in ipairs(window.Content:GetChildren()) do
            child.Visible = false
        end
        TabContent.Visible = true
    end)

    Tab.TabButton = TabButton
    Tab.TabContent = TabContent

    return Tab
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

-- Thêm Dropdown
function Library:AddDropdown(window, label, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(0.9, 0, 0.1, 0)
    Dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Dropdown.Parent = window.Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextScaled = true
    Label.Parent = Dropdown

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    DropdownButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    DropdownButton.Text = "Select"
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextScaled = true
    DropdownButton.Parent = Dropdown

    -- Dropdown Menu
    local DropdownMenu = Instance.new("Frame")
    DropdownMenu.Size = UDim2.new(1, 0, 0, #options * 0.1)
    DropdownMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownMenu.Position = UDim2.new(0, 0, 1, 0)
    DropdownMenu.Visible = false
    DropdownMenu.Parent = Dropdown

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0.1, 0)
        OptionButton.Text = option
        OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextScaled = true
        OptionButton.Parent = DropdownMenu

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            DropdownMenu.Visible = false
            callback(option)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownMenu.Visible = not DropdownMenu.Visible
    end)
end

function Library:AddLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextScaled = true
    Label.Parent = parent
end

function Library:AddParagraph(parent, text)
    local Paragraph = Instance.new("TextLabel")
    Paragraph.Size = UDim2.new(1, 0, 0.2, 0)  -- Điều chỉnh chiều cao để hiển thị đoạn văn
    Paragraph.Text = text
    Paragraph.TextColor3 = Color3.fromRGB(255, 255, 255)
    Paragraph.BackgroundTransparency = 1
    Paragraph.Font = Enum.Font.Gotham
    Paragraph.TextSize = 14
    Paragraph.TextWrapped = true  -- Cho phép văn bản xuống dòng nếu quá dài
    Paragraph.TextScaled = false
    Paragraph.Parent = parent
end



-- Thêm Notification
function Library:AddNotification(window, title, message, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0.6, 0, 0.1, 0)
    Notification.Position = UDim2.new(0.5, -Notification.Size.X.Offset / 2, 0, -Notification.Size.Y.Offset)
    Notification.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    Notification.Parent = window.ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.5, 0)
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Notification

    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, 0, 0.5, 0)
    Message.Text = message
    Message.TextColor3 = Color3.fromRGB(255, 255, 255)
    Message.Font = Enum.Font.Gotham
    Message.TextScaled = true
    Message.BackgroundTransparency = 1
    Message.Parent = Notification

    -- Tự động ẩn notification sau thời gian
    wait(duration or 3)

    -- Tạo hiệu ứng biến mất
    for i = 1, 10 do
        Notification.BackgroundTransparency = i / 10
        wait(0.1)
    end

    Notification:Destroy()
end


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