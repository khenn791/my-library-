
local GrokUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Khởi tạo ScreenGui
local function createScreenGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GrokUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return screenGui
end

-- Tạo Frame chính (Window)
function GrokUI:CreateWindow(title)
    local screenGui = createScreenGui()
    local window = Instance.new("Frame")
    local titleBar = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local closeButton = Instance.new("TextButton")
    local tabBar = Instance.new("Frame")
    local tabLayout = Instance.new("UIListLayout")
    local contentContainer = Instance.new("Frame")
    local uiCorner = Instance.new("UICorner")

    -- Cài đặt Window
    window.Name = "GrokWindow"
    window.Size = UDim2.new(0, 300, 0, 400)
    window.Position = UDim2.new(0.5, -150, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = screenGui

    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = window

    -- Title Bar
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    -- Title Label
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "GrokUI"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleBar

    -- Close Button
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = titleBar
    uiCorner:Clone().CornerRadius = UDim.new(0, 3)
    uiCorner:Clone().Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        screenGui:Destroy()
    end)

    -- Tab Bar
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = window

    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabBar

    -- Content Container
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window

    -- Tối ưu cho Mobile
    local function adjustForMobile()
        if UserInputService.TouchEnabled then
            window.Size = UDim2.new(0, 260, 0, 350)
            titleLabel.TextSize = 12
            closeButton.Size = UDim2.new(0, 18, 0, 18)
            closeButton.Position = UDim2.new(1, -22, 0, 6)
        end
    end
    adjustForMobile()

    -- Animation mở window
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(window, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200)
    }):Play()

    -- Di chuyển Window
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        local screenSize = screenGui.AbsoluteSize
        local windowSize = window.AbsoluteSize
        newPos = UDim2.new(
            0, math.clamp(newPos.X.Offset, 0, screenSize.X - windowSize.X),
            0, math.clamp(newPos.Y.Offset, 0, screenSize.Y - windowSize.Y)
        )
        TweenService:Create(window, TweenInfo.new(0.1), {Position = newPos}):Play()
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            updateDrag(dragInput)
        end
    end)

    -- Tab System
    local tabs = {}
    local currentTab = nil

    function tabs:CreateTab(tabName)
        local tabButton = Instance.new("TextButton")
        local tabContent = Instance.new("ScrollingFrame")
        local uiListLayout = Instance.new("UIListLayout")

        -- Tab Button
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabButton.Text = tabName or "Tab"
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.SourceSans
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabBar

        -- Tab Content
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        tabContent.Visible = false
        tabContent.Parent = contentContainer

        uiListLayout.Padding = UDim.new(0, 5)
        uiListLayout.Parent = tabContent

        -- Tab Switching
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
                currentTab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                currentTab.Content.Visible = false
            end
            tabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
            tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tabContent.Visible = true
            currentTab = {Button = tabButton, Content = tabContent}
        end)

        -- Default to first tab
        if not currentTab then
            tabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
            tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tabContent.Visible = true
            currentTab = {Button = tabButton, Content = tabContent}
        end

        -- Elements for this tab
        local elements = {}

        -- Hàm tạo Section
        function elements:CreateSection(sectionName)
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 20)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = "-- " .. (sectionName or "SECTION") .. " --"
            sectionLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
            sectionLabel.TextSize = 14
            sectionLabel.Font = Enum.Font.SourceSansBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Center
            sectionLabel.Parent = tabContent
        end

        -- Hàm tạo Toggle
        function elements:CreateToggle(text, callback)
            local toggleFrame = Instance.new("Frame")
            local toggleLabel = Instance.new("TextLabel")
            local toggleButton = Instance.new("Frame")
            local toggleCircle = Instance.new("Frame")
            local toggleCorner = Instance.new("UICorner")
            local isToggled = false

            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = text or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.SourceSans
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleButton.Parent = toggleFrame

            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleButton

            toggleCircle.Size = UDim2.new(0, 16, 0, 16)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.Parent = toggleButton
            toggleCorner:Clone().CornerRadius = UDim.new(0, 8)
            toggleCorner:Clone().Parent = toggleCircle

            toggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isToggled = not isToggled
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
                    }):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                        Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    if callback then callback(isToggled) end
                end
            end)
        end

        -- Hàm tạo Slider
        function elements:CreateSlider(text, min, max, callback)
            local sliderFrame = Instance.new("Frame")
            local sliderLabel = Instance.new("TextLabel")
            local sliderBar = Instance.new("Frame")
            local sliderFill = Instance.new("Frame")
            local sliderButton = Instance.new("Frame")
            local sliderCorner = Instance.new("UICorner")
            local sliderValue = Instance.new("TextLabel")

            sliderFrame.Size = UDim2.new(1, 0, 0, 40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent

            sliderLabel.Size = UDim2.new(1, -50, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = text or "Slider"
            sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.SourceSans
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            sliderValue.Size = UDim2.new(0, 40, 0, 20)
            sliderValue.Position = UDim2.new(1, -40, 0, 0)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(min)
            sliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            sliderValue.TextSize = 14
            sliderValue.Font = Enum.Font.SourceSans
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame

            sliderBar.Size = UDim2.new(1, 0, 0, 5)
            sliderBar.Position = UDim2.new(0, 0, 0, 25)
            sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderBar.Parent = sliderFrame
            sliderCorner.CornerRadius = UDim.new(0, 3)
            sliderCorner.Parent = sliderBar

            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderFill.Parent = sliderBar
            sliderCorner:Clone().Parent = sliderFill

            sliderButton.Size = UDim2.new(0, 10, 0, 10)
            sliderButton.Position = UDim2.new(0, -2, 0, -2.5)
            sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderButton.Parent = sliderBar
            sliderCorner:Clone().CornerRadius = UDim.new(0, 5)
            sliderCorner:Clone().Parent = sliderButton

            local function updateSlider(input)
                local barSize = sliderBar.AbsoluteSize.X
                local mouseX = input.Position.X - sliderBar.AbsolutePosition.X
                local percent = math.clamp(mouseX / barSize, 0, 1)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderButton.Position = UDim2.new(percent, -5, 0, -2.5)
                local value = min + (max - min) * percent
                sliderValue.Text = string.format("%.1f", value)
                if callback then callback(value) end
            end

            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(changedInput)
                        if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch then
                            updateSlider(changedInput)
                        end
                    end)
                    input.InputEnded:Connect(function()
                        connection:Disconnect()
                    end)
                end
            end)
        end

        -- Hàm tạo Dropdown
        function elements:CreateDropdown(text, options, callback)
            local dropdownFrame = Instance.new("Frame")
            local dropdownLabel = Instance.new("TextLabel")
            local dropdownButton = Instance.new("TextButton")
            local dropdownArrow = Instance.new("TextLabel")
            local dropdownList = Instance.new("Frame")
            local uiListLayout = Instance.new("UIListLayout")
            local isOpen = false

            dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = tabContent

            dropdownLabel.Size = UDim2.new(0.7, 0, 1, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = text or "Dropdown"
            dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.SourceSans
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            dropdownButton.Size = UDim2.new(0, 40, 0, 20)
            dropdownButton.Position = UDim2.new(1, -40, 0.5, -10)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dropdownButton.Text = options[1] or "Select"
            dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.SourceSans
            dropdownButton.Parent = dropdownFrame
            uiCorner:Clone().CornerRadius = UDim.new(0, 3)
            uiCorner:Clone().Parent = dropdownButton

            dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            dropdownArrow.Position = UDim2.new(1, -20, 0.5, -10)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownArrow.TextSize = 12
            dropdownArrow.Parent = dropdownFrame

            dropdownList.Size = UDim2.new(0, 40, 0, 0)
            dropdownList.Position = UDim2.new(1, -40, 0, 30)
            dropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame
            uiCorner:Clone().CornerRadius = UDim.new(0, 3)
            uiCorner:Clone().Parent = dropdownList

            uiListLayout.Parent = dropdownList

            for _, option in pairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 20)
                optionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.SourceSans
                optionButton.Parent = dropdownList
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    dropdownList.Visible = false
                    isOpen = false
                    dropdownList.Size = UDim2.new(0, 40, 0, 0)
                    if callback then callback(option) end
                end)
            end

            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownList.Visible = isOpen
                dropdownList.Size = isOpen and UDim2.new(0, 40, 0, #options * 20) or UDim2.new(0, 40, 0, 0)
            end)
        end

        return elements
    end

    return tabs
end

return GrokUI
