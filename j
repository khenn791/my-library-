--hi
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
function GrokUI:CreateWindow(title, size)
    local screenGui = createScreenGui()
    local window = Instance.new("Frame")
    local titleBar = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local closeButton = Instance.new("TextButton")
    local tabBar = Instance.new("Frame")
    local tabLayout = Instance.new("UIListLayout")
    local contentContainer = Instance.new("Frame")
    local uiCorner = Instance.new("UICorner")
    local uiGradient = Instance.new("UIGradient")
    local shadow = Instance.new("ImageLabel")

    -- Cài đặt Window với size tùy chỉnh
    window.Name = "GrokWindow"
    window.Size = size or UDim2.new(0, 320, 0, 450) -- Default size nếu không truyền size
    window.Position = UDim2.new(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
    window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = screenGui

    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = window

    -- Thêm shadow
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.5
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = window

    -- Title Bar
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    uiGradient.Rotation = 45
    uiGradient.Parent = titleBar

    -- Title Label
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "GrokUI"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleBar

    -- Close Button
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.Gotham
    closeButton.Parent = titleBar
    uiCorner:Clone().CornerRadius = UDim.new(0, 5)
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
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = window

    uiGradient:Clone().Parent = tabBar

    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabBar

    -- Content Container
    contentContainer.Size = UDim2.new(1, -10, 1, -80)
    contentContainer.Position = UDim2.new(0, 5, 0, 75)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window

    -- Tối ưu cho Mobile
    local function adjustForMobile()
        if UserInputService.TouchEnabled then
            window.Size = UDim2.new(0, window.Size.X.Offset * 0.9, 0, window.Size.Y.Offset * 0.9)
            window.Position = UDim2.new(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
            titleLabel.TextSize = 14
            closeButton.Size = UDim2.new(0, 22, 0, 22)
            closeButton.Position = UDim2.new(1, -27, 0.5, -11)
        end
    end
    adjustForMobile()

    -- Animation mở window
    local originalSize = window.Size
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(window, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = originalSize,
        Position = UDim2.new(0.5, -originalSize.X.Offset / 2, 0.5, -originalSize.Y.Offset / 2)
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
        local tabFrame = Instance.new("Frame")
        local sectionLabel = Instance.new("TextLabel")
        local tabContent = Instance.new("ScrollingFrame")
        local uiListLayout = Instance.new("UIListLayout")
        local uiCorner = Instance.new("UICorner")
        local glow = Instance.new("ImageLabel")

        -- Tab Button
        tabButton.Size = UDim2.new(0, 100, 0, 30)
        tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabButton.Text = tabName or "Tab"
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabBar

        uiCorner.CornerRadius = UDim.new(0, 5)
        uiCorner.Parent = tabButton

        -- Glow effect
        glow.Size = UDim2.new(1, 0, 1, 0)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://5028857472"
        glow.ImageTransparency = 1
        glow.ImageColor3 = Color3.fromRGB(0, 170, 255)
        glow.Parent = tabButton

        -- Tab Frame (chứa section và content)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = contentContainer

        -- Section Label (cố định ở trên đầu)
        sectionLabel.Size = UDim2.new(1, 0, 0, 25)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = ""
        sectionLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
        sectionLabel.TextSize = 14
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Center
        sectionLabel.Parent = tabFrame

        -- Tab Content (ScrollingFrame bên dưới section)
        tabContent.Size = UDim2.new(1, 0, 1, -30)
        tabContent.Position = UDim2.new(0, 0, 0, 30)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        tabContent.Parent = tabFrame

        uiListLayout.Padding = UDim.new(0, 8)
        uiListLayout.Parent = tabContent

        -- Tab Switching with Animation
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                TweenService:Create(currentTab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    TextColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(currentTab.Button:FindFirstChild("ImageLabel"), TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                currentTab.Frame.Visible = false
            end
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(0, 170, 255)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            tabFrame.Visible = true
            currentTab = {Button = tabButton, Frame = tabFrame, Content = tabContent}
        end)

        -- Default to first tab
        if not currentTab then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(0, 170, 255)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            tabFrame.Visible = true
            currentTab = {Button = tabButton, Frame = tabFrame, Content = tabContent}
        end

        -- Hover effect
        tabButton.MouseEnter:Connect(function()
            if currentTab.Button ~= tabButton then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if currentTab.Button ~= tabButton then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
        end)

        -- Elements for this tab
        local elements = {}

        -- Hàm tạo Section
        function elements:CreateSection(sectionName)
            sectionLabel.Text = "-- " .. (sectionName or "SECTION") .. " --"
        end

        -- Hàm tạo Toggle
        function elements:CreateToggle(text, callback)
            local toggleFrame = Instance.new("Frame")
            local toggleLabel = Instance.new("TextLabel")
            local toggleButton = Instance.new("Frame")
            local toggleCircle = Instance.new("Frame")
            local toggleCorner = Instance.new("UICorner")
            local isToggled = false

            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = text or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.Gotham
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

            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent

            sliderLabel.Size = UDim2.new(1, -50, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = text or "Slider"
            sliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            sliderValue.Size = UDim2.new(0, 40, 0, 20)
            sliderValue.Position = UDim2.new(1, -40, 0, 0)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(min)
            sliderValue.TextColor3 = Color3.fromRGB(220, 220, 220)
            sliderValue.TextSize = 14
            sliderValue.Font = Enum.Font.Gotham
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame

            sliderBar.Size = UDim2.new(1, 0, 0, 6)
            sliderBar.Position = UDim2.new(0, 0, 0, 25)
            sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderBar.Parent = sliderFrame
            sliderCorner.CornerRadius = UDim.new(0, 3)
            sliderCorner.Parent = sliderBar

            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            sliderFill.Parent = sliderBar
            sliderCorner:Clone().Parent = sliderFill

            local buttonSize = UserInputService.TouchEnabled and 14 or 10
            sliderButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
            sliderButton.Position = UDim2.new(0, -(buttonSize / 2), 0, -((buttonSize - 6) / 2))
            sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderButton.Parent = sliderBar
            sliderCorner:Clone().CornerRadius = UDim.new(0, buttonSize / 2)
            sliderCorner:Clone().Parent = sliderButton

            local function updateSlider(input)
                local barSize = sliderBar.AbsoluteSize.X
                local mouseX = input.Position.X - sliderBar.AbsolutePosition.X
                local percent = math.clamp(mouseX / barSize, 0, 1)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderButton.Position = UDim2.new(percent, -(buttonSize / 2), 0, -((buttonSize - 6) / 2))
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

            sliderButton.MouseEnter:Connect(function()
                TweenService:Create(sliderButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end)
            sliderButton.MouseLeave:Connect(function()
                TweenService:Create(sliderButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
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
            local uiCorner = Instance.new("UICorner")
            local isOpen = false

            dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = tabContent

            dropdownLabel.Size = UDim2.new(0.7, 0, 1, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = text or "Dropdown"
            dropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            dropdownButton.Size = UDim2.new(0, 40, 0, 20)
            dropdownButton.Position = UDim2.new(1, -40, 0.5, -10)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            dropdownButton.Text = options[1] or "Select"
            dropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.Parent = dropdownFrame
            uiCorner.CornerRadius = UDim.new(0, 5)
            uiCorner.Parent = dropdownButton

            dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            dropdownArrow.Position = UDim2.new(1, -20, 0.5, -10)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Color3.fromRGB(220, 220, 220)
            dropdownArrow.TextSize = 12
            dropdownArrow.Parent = dropdownFrame

            dropdownList.Size = UDim2.new(0, 40, 0, 0)
            dropdownList.Position = UDim2.new(1, -40, 0, 30)
            dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame
            uiCorner:Clone().Parent = dropdownList

            uiListLayout.Parent = dropdownList

            for _, option in pairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 20)
                optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham
                optionButton.Parent = dropdownList
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    isOpen = false
                    TweenService:Create(dropdownList, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 0)}):Play()
                    wait(0.2)
                    dropdownList.Visible = false
                    if callback then callback(option) end
                end)

                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end)
            end

            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownList.Visible = true
                TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                    Size = isOpen and UDim2.new(0, 40, 0, #options * 20) or UDim2.new(0, 40, 0, 0)
                }):Play()
                if not isOpen then
                    wait(0.2)
                    dropdownList.Visible = false
                end
            end)
        end

        return elements
    end

    return tabs
end

return GrokUI
