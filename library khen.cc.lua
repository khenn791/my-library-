local Library = {}

function Library:CreateHub(title)
    local Hub = {}

    -- Main Frame
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "KhenHub"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
    TitleBar.Text = title
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.Font = Enum.Font.SourceSansBold
    TitleBar.TextScaled = true
    TitleBar.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0.3, 0, 0.9, 0)
    Sidebar.Position = UDim2.new(0, 0, 0.1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sidebar.Parent = MainFrame

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(0.7, 0, 0.9, 0)
    Content.Position = UDim2.new(0.3, 0, 0.1, 0)
    Content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Content.ClipsDescendants = true
    Content.Parent = MainFrame

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
    Button.Font = Enum.Font.SourceSans
    Button.TextScaled = true
    Button.Parent = window.MainFrame:FindFirstChild("Sidebar")

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
    Label.Font = Enum.Font.SourceSans
    Label.TextScaled = true
    Label.Parent = window.Content
end

function Library:AddToggle(window, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0.9, 0, 0.1, 0)
    Toggle.Position = UDim2.new(0.05, 0, 0.6 + (#window.Content:GetChildren() * 0.12), 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.Parent = window.Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextScaled = true
    Label.Parent = Toggle

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.TextScaled = true
    ToggleButton.Parent = Toggle

    local isOn = default
    ToggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        ToggleButton.Text = isOn and "ON" or "OFF"
        ToggleButton.TextColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        pcall(callback, isOn)
    end)
end

function Library:AddDropdown(window, text, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(0.9, 0, 0.1, 0)
    Dropdown.Position = UDim2.new(0.05, 0, 0.6 + (#window.Content:GetChildren() * 0.12), 0)
    Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Dropdown.Parent = window.Content

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.Text = text
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropdownButton.Font = Enum.Font.SourceSans
    DropdownButton.TextScaled = true
    DropdownButton.Parent = Dropdown

    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 1, 0)
    DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownList.ClipsDescendants = true
    DropdownList.Parent = Dropdown

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = DropdownList

    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0.2, 0)
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.TextScaled = true
        OptionButton.Parent = DropdownList

        OptionButton.MouseButton1Click:Connect(function()
            pcall(callback, option)
            DropdownButton.Text = text .. ": " .. option
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        if DropdownList.Size.Y.Scale == 0 then
            DropdownList.Size = UDim2.new(1, 0, 0.2 * #options, 0)
        else
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
end

return Library