local Library = {}

-- Dịch vụ cần thiết
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Người chơi
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Hàm tạo gradient
local function createGradient(frame, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(30, 30, 30))
    })
    gradient.Parent = frame
end

-- Hàm tạo bóng đổ
local function createShadow(frame)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.6
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame
end

-- Hàm tạo hiệu ứng phát sáng
local function createGlow(frame, glowColor)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857472"
    glow.ImageTransparency = 0.7
    glow.ImageColor3 = glowColor or Color3.fromRGB(128, 0, 128)
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.Parent = frame
    return glow
end

-- Tạo GUI chính
function Library:CreateWindow(windowName)
    local Window = {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui
    ScreenGui.Name = windowName
    ScreenGui.ResetOnSpawn = false

    -- Frame chính (kích thước 500x350, giống Muta | Buyer)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    createGradient(MainFrame)
    createShadow(MainFrame)

    -- Tiêu đề (hỗ trợ kéo thả)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.Parent = MainFrame
    createGradient(TitleBar, Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20))

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = TitleBar

    -- Tab container (thanh bên trái, rộng 100px)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 100, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    -- Content container (phần nội dung bên phải với scroll)
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, -110, 1, -40)
    ContentContainer.Position = UDim2.new(0, 110, 0, 35)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ScrollBarThickness = 4
    ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 128)
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.Parent = MainFrame

    -- Hỗ trợ kéo thả trên PC và Mobile (chỉ kéo từ TitleBar)
    local dragging, dragInput, dragStart, startPos
    local function startDragging(input, position)
        dragging = true
        dragStart = position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end

    local function updateDragging(input)
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    -- Kéo thả trên PC
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDragging(input, input.Position)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput then
            updateDragging(input)
        end
    end)

    -- Kéo thả trên Mobile
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            startDragging(input, input.Position)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    -- Hàm tạo Tab
    function Window:CreateTab(tabName)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Parent = TabContainer
        createGradient(TabButton)

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = ContentContainer
        TabContent.Visible = false

        local ContentListLayout = Instance.new("UIListLayout")
        ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentListLayout.Parent = TabContent
        ContentListLayout.Padding = UDim.new(0, 5)

        -- Hiệu ứng khi chọn tab
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            TabContent.Visible = true
            local tween = TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)})
            tween:Play()
        end)

        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                local tween = TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                tween:Play()
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                local tween = TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
                tween:Play()
            end
        end)

        -- Hàm tạo Section
        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -10, 0, 25)
            SectionFrame.Position = UDim2.new(0, 5, 0, 0)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            SectionLabel.TextSize = 12
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.Parent = SectionFrame

            -- Đường viền dưới gradient cho section
            local SectionDivider = Instance.new("Frame")
            SectionDivider.Size = UDim2.new(0.5, 0, 0, 2)
            SectionDivider.Position = UDim2.new(0, 0, 1, -2)
            SectionDivider.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
            SectionDivider.Parent = SectionLabel
            createGradient(SectionDivider, Color3.fromRGB(128, 0, 128), Color3.fromRGB(50, 50, 50))

            local SectionContent = Instance.new("Frame")
            SectionContent.Size = UDim2.new(1, -10, 0, 0)
            SectionContent.Position = UDim2.new(0, 5, 0, 25)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = TabContent
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y

            local SectionListLayout = Instance.new("UIListLayout")
            SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionListLayout.Parent = SectionContent
            SectionListLayout.Padding = UDim.new(0, 5)

            local Section = {}

            -- Hàm tạo Toggle
            function Section:CreateToggle(toggleName, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = SectionContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Font = Enum.Font.SourceSans
                ToggleLabel.Parent = ToggleFrame

                -- Toggle container
                local ToggleContainer = Instance.new("Frame")
                ToggleContainer.Size = UDim2.new(0, 40, 0, 18)
                ToggleContainer.Position = UDim2.new(1, -50, 0.5, -9)
                ToggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleContainer.Parent = ToggleFrame
                createGradient(ToggleContainer)

                local UICornerContainer = Instance.new("UICorner")
                UICornerContainer.CornerRadius = UDim.new(1, 0)
                UICornerContainer.Parent = ToggleContainer

                -- Toggle button (hình tròn)
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 14, 0, 14)
                ToggleButton.Position = UDim2.new(0, 2, 0.5, -7)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleContainer

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = ToggleButton

                -- Hiệu ứng phát sáng cho toggle
                local ToggleGlow = createGlow(ToggleButton)
                ToggleGlow.ImageTransparency = 1

                local toggleState = false
                ToggleButton.MouseButton1Click:Connect(function()
                    toggleState = not toggleState
                    local newColor = toggleState and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(100, 100, 100)
                    local newPos = toggleState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local glowTransparency = toggleState and 0.5 or 1

                    local tweenColor = TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = newColor})
                    local tweenPos = TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = newPos})
                    local tweenGlow = TweenService:Create(ToggleGlow, TweenInfo.new(0.3), {ImageTransparency = glowTransparency})

                    tweenColor:Play()
                    tweenPos:Play()
                    tweenGlow:Play()

                    if callback then
                        callback(toggleState)
                    end
                end)

                ToggleButton.MouseEnter:Connect(function()
                    local tween = TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    tween:Play()
                end)

                ToggleButton.MouseLeave:Connect(function()
                    local tween = TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                    tween:Play()
                end)
            end

            -- Hàm tạo Button
            function Section:CreateButton(buttonName, callback)
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Size = UDim2.new(1, 0, 0, 25)
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Parent = SectionContent

                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.3, 0, 0, 20)
                Button.Position = UDim2.new(0, 0, 0.5, -10)
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.Text = buttonName
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 12
                Button.Font = Enum.Font.SourceSans
                Button.Parent = ButtonFrame
                createGradient(Button, Color3.fromRGB(70, 70, 70), Color3.fromRGB(50, 50, 50))

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = Button

                local ButtonGlow = createGlow(Button)
                ButtonGlow.ImageTransparency = 1

                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)

                Button.MouseEnter:Connect(function()
                    local tween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
                    local tweenGlow = TweenService:Create(ButtonGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5})
                    tween:Play()
                    tweenGlow:Play()
                end)

                Button.MouseLeave:Connect(function()
                    local tween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    local tweenGlow = TweenService:Create(ButtonGlow, TweenInfo.new(0.2), {ImageTransparency = 1})
                    tween:Play()
                    tweenGlow:Play()
                end)
            end

            -- Hàm tạo Textbox
            function Section:CreateTextbox(textboxName, placeholder, callback)
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Size = UDim2.new(1, 0, 0, 25)
                TextboxFrame.BackgroundTransparency = 1
                TextboxFrame.Parent = SectionContent

                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Text = textboxName
                TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                TextboxLabel.TextSize = 12
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Font = Enum.Font.SourceSans
                TextboxLabel.Parent = TextboxFrame

                local Textbox = Instance.new("TextBox")
                Textbox.Size = UDim2.new(0.3, 0, 0, 20)
                Textbox.Position = UDim2.new(0.7, 0, 0.5, -10)
                Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Textbox.Text = ""
                Textbox.PlaceholderText = placeholder
                Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.TextSize = 12
                Textbox.Font = Enum.Font.SourceSans
                Textbox.Parent = TextboxFrame
                createGradient(Textbox)

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = Textbox

                local TextboxGlow = createGlow(Textbox)
                TextboxGlow.ImageTransparency = 1

                Textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(Textbox.Text)
                    end
                    local tweenGlow = TweenService:Create(TextboxGlow, TweenInfo.new(0.2), {ImageTransparency = 1})
                    tweenGlow:Play()
                end)

                Textbox.Focused:Connect(function()
                    local tweenGlow = TweenService:Create(TextboxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5})
                    tweenGlow:Play()
                end)
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
