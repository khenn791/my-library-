-- GUI Library (MyGuiLibrary.lua)
local MyGuiLibrary = {}

-- Tạo một Tab mới
function MyGuiLibrary:MakeTab(tabName)
    local tab = Instance.new("Frame")
    tab.Name = tabName
    tab.Size = UDim2.new(0, 300, 0, 500)
    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tab.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
    
    -- Tạo Title cho Tab
    local title = Instance.new("TextLabel")
    title.Text = tabName
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.Parent = tab
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    return tab
end

-- Tạo một Button
function MyGuiLibrary:Button(options)
    local button = Instance.new("TextButton")
    button.Text = options["Title"]
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    button.Parent = options["Parent"]
    
    button.MouseButton1Click:Connect(options["Callback"])
    
    return button
end

-- Tạo một Toggle
function MyGuiLibrary:Toggle(options)
    local toggle = Instance.new("TextButton")
    toggle.Text = options["Title"]
    toggle.Size = UDim2.new(1, 0, 0, 50)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    toggle.Parent = options["Parent"]
    
    local toggled = false
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggle.BackgroundColor3 = toggled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 255, 100)
        options["Callback"](toggled)
    end)
    
    return toggle
end

-- Tạo một Label
function MyGuiLibrary:Label(options)
    local label = Instance.new("TextLabel")
    label.Text = options["Text"]
    label.Size = UDim2.new(1, 0, 0, 50)
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = options["Parent"]
    
    return label
end

return MyGuiLibrary
