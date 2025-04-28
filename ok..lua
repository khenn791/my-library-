local MyOrcaUI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tạo cái ScreenGui trước đã
local function makeScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "khen.cc"
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    return gui
end

-- Hàm chính để làm cái window
function MyOrcaUI:MakeWindow(options)
    local window = {}
    setmetatable(window, MyOrcaUI)

    -- Lấy tên window, không có thì để mặc định
    local windowName = options.Name or "My Menu"
    local screenGui = makeScreenGui()

    -- Tạo cái khung chính (window) nè
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 350) -- Kích thước giống Orca
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Căn giữa màn hình
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu xám tối giống Orca
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    -- Làm cái bóng cho đẹp, nhìn giống Orca
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    shadow.Parent = mainFrame

    -- Bo góc cho khung chính
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadow

    -- Tạo cái thanh tiêu đề (title bar)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    -- Tên window trên title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = windowName
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    -- Làm cái ô search cho giống Orca (mà tui làm giả thôi :v)
    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(0, 100, 0, 20)
    searchBar.Position = UDim2.new(0.5, 0, 0, 5)
    searchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchBar.Text = "Search"
    searchBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    searchBar.TextSize = 14
    searchBar.Font = Enum.Font.SourceSans
    searchBar.ClearTextOnFocus = true
    searchBar.Parent = titleBar

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 5)
    searchCorner.Parent = searchBar

    -- Nút minimize (thu nhỏ window)
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 14
    minimizeBtn.Font = Enum.Font.SourceSans
    minimizeBtn.Parent = titleBar

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 5)
    minimizeCorner.Parent = minimizeBtn

    -- Tạo khung chứa tab (bên trái)
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 120, 1, -30)
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame

    -- Tạo khung chứa nội dung (bên phải)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -120, 1, -30)
    contentFrame.Position = UDim2.new(0, 120, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    -- List layout cho tab
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabFrame

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.Parent = tabFrame

    -- Lưu tab và nội dung
    window.Tabs = {}
    window.Contents = {}

    -- Kéo thả window (hỗ trợ cả PC và mobile)
    local dragging = false
    local dragStart
    local startPos

    -- PC: Dùng chuột
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Mobile: Dùng cảm ứng
    titleBar.TouchPan:Connect(function(touchPositions, totalTranslation, velocity, state)
        if state == Enum.UserInputState.Begin then
            dragging = true
            dragStart = touchPositions[1]
            startPos = mainFrame.Position
        elseif state == Enum.UserInputState.End then
            dragging = false
        elseif state == Enum.UserInputState.Change and dragging then
            local delta = touchPositions[1] - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Minimize window (ấn nút - để thu nhỏ)
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "-"
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = isMinimized and UDim2.new(0, 500, 0, 30) or UDim2.new(0, 500, 0, 350)
        })
        tween:Play()
    end)

    -- Keybind để bật/tắt UI (dùng phím Insert nha)
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            uiVisible = not uiVisible
            mainFrame.Visible = uiVisible
        end
    end)

    -- Thêm nút toggle bên ngoài để bật/tắt menu
    local toggleMenu = Instance.new("Frame")
    toggleMenu.Size = UDim2.new(0, 50, 0, 30)
    toggleMenu.Position = UDim2.new(0, 10, 0, 10) -- Góc trên bên trái
    toggleMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleMenu.BorderSizePixel = 0
    toggleMenu.Parent = screenGui

    local toggleMenuCorner = Instance.new("UICorner")
    toggleMenuCorner.CornerRadius = UDim.new(0, 5)
    toggleMenuCorner.Parent = toggleMenu

    -- Label nhỏ để biết đây là nút bật/tắt menu
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, 0, 0, 15)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Menu"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 12
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
    toggleLabel.Parent = toggleMenu

    -- Tạo toggle giống trong menu (hình tròn trượt)
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0, 5, 0, 15)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleBtn.Parent = toggleMenu

    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleBtn

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.BackgroundColor3 = uiVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    toggleCircle.Position = uiVisible and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    toggleCircle.Parent = toggleBtn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle

    -- Kéo thả nút toggleMenu (hỗ trợ cả PC và mobile)
    local draggingToggle = false
    local toggleDragStart
    local toggleStartPos

    -- PC: Dùng chuột
    toggleMenu.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingToggle = true
            toggleDragStart = input.Position
            toggleStartPos = toggleMenu.Position
        end
    end)

    toggleMenu.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingToggle = false
        end
    end)

    -- Mobile: Dùng cảm ứng
    toggleMenu.TouchPan:Connect(function(touchPositions, totalTranslation, velocity, state)
        if state == Enum.UserInputState.Begin then
            draggingToggle = true
            toggleDragStart = touchPositions[1]
            toggleStartPos = toggleMenu.Position
        elseif state == Enum.UserInputState.End then
            draggingToggle = false
        elseif state == Enum.UserInputState.Change and draggingToggle then
            local delta = touchPositions[1] - toggleDragStart
            toggleMenu.Position = UDim2.new(
                toggleStartPos.X.Scale,
                toggleStartPos.X.Offset + delta.X,
                toggleStartPos.Y.Scale,
                toggleStartPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - toggleDragStart
            toggleMenu.Position = UDim2.new(
                toggleStartPos.X.Scale,
                toggleStartPos.X.Offset + delta.X,
                toggleStartPos.Y.Scale,
                toggleStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Bật/tắt menu khi nhấn toggle (hỗ trợ cả PC và mobile)
    -- PC: Dùng chuột
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            uiVisible = not uiVisible
            mainFrame.Visible = uiVisible
            local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = uiVisible and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = uiVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
            })
            tween:Play()
        end
    end)

    -- Mobile: Dùng cảm ứng
    toggleBtn.TouchTap:Connect(function()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
        local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = uiVisible and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = uiVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        })
        tween:Play()
    end)

    -- Hiệu ứng hover cho nút toggle bên ngoài
    toggleMenu.MouseEnter:Connect(function()
        toggleMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    toggleMenu.MouseLeave:Connect(function()
        toggleMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    -- Hàm tạo tab
    function window:MakeTab(options)
        local tabName = options.Name or "Tab"
        
        -- Tạo nút tab
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -10, 0, 30)
        tabBtn.Position = UDim2.new(0, 5, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.SourceSans
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabFrame

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabBtn

        -- Hiệu ứng hover cho tab
        tabBtn.MouseEnter:Connect(function()
            if window.Tabs[tabName].BackgroundColor3 ~= Color3.fromRGB(60, 60, 60) then
                tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Sáng lên tí khi hover
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if window.Tabs[tabName].BackgroundColor3 ~= Color3.fromRGB(60, 60, 60) then
                tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Trả lại màu cũ
            end
        end)

        -- Tạo khung nội dung cho tab
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        tabContent.Parent = contentFrame
        tabContent.Visible = false

        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 10)
        contentList.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.Parent = tabContent

        contentList.Changed:Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
        end)

        -- Lưu tab
        window.Tabs[tabName] = tabBtn
        window.Contents[tabName] = tabContent

        -- Chuyển tab khi click (hỗ trợ cả PC và mobile)
        tabBtn.MouseButton1Click:Connect(function()
            for name, content in pairs(window.Contents) do
                content.Visible = (name == tabName)
                window.Tabs[name].BackgroundColor3 = (name == tabName) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
            end
        end)

        tabBtn.TouchTap:Connect(function()
            for name, content in pairs(window.Contents) do
                content.Visible = (name == tabName)
                window.Tabs[name].BackgroundColor3 = (name == tabName) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
            end
        end)

        -- Tab đầu tiên mặc định được chọn
        if #tabFrame:GetChildren() == 2 then
            tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tabContent.Visible = true
        end

        -- Hàm thêm toggle (công tắc)
        function tabContent:AddToggle(options)
            local toggleName = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleName
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.SourceSans
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            -- Tạo cái toggle giống Orca (hình tròn trượt qua lại)
            local toggleBtn = Instance.new("Frame")
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -40, 0, 5)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleBtn.Parent = toggleFrame

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBtn

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
            toggleCircle.Position = default and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
            toggleCircle.Parent = toggleBtn

            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle

            -- Hỗ trợ cả PC và mobile
            toggleBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                        Position = default and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
                    })
                    tween:Play()
                    callback(default)
                end
            end)

            toggleBtn.TouchTap:Connect(function()
                default = not default
                local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                    Position = default and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
                })
                tween:Play()
                callback(default)
            end)
        end

        -- Hàm thêm slider (thanh trượt) - Hỗ trợ cả mobile và PC
        function tabContent:AddSlider(options)
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 1
            local default = options.Default or min
            local step = options.Increment or 0.01
            local callback = options.Callback or function() end

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 50)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = sliderName .. ": " .. string.format("%.5f", default)
            sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.SourceSans
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, 0, 0, 10) -- Tăng chiều cao tí cho dễ chạm trên mobile
            sliderBar.Position = UDim2.new(0, 0, 0, 30)
            sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = sliderFrame

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar

            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = sliderBar

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill

            local draggingSlider = false
            local dragStartSlider

            -- PC: Dùng chuột
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    dragStartSlider = input.Position
                end
            end)

            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local pos = (mousePos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                    pos = math.clamp(pos, 0, 1)
                    local value = min + (max - min) * pos
                    value = math.floor(value / step + 0.5) * step
                    default = value
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderLabel.Text = sliderName .. ": " .. string.format("%.5f", value)
                    callback(value)
                end
            end)

            -- Mobile: Dùng cảm ứng
            sliderBar.TouchPan:Connect(function(touchPositions, totalTranslation, velocity, state)
                if state == Enum.UserInputState.Begin then
                    draggingSlider = true
                    dragStartSlider = touchPositions[1]
                elseif state == Enum.UserInputState.End then
                    draggingSlider = false
                elseif state == Enum.UserInputState.Change and draggingSlider then
                    local touchPos = touchPositions[1]
                    local pos = (touchPos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                    pos = math.clamp(pos, 0, 1)
                    local value = min + (max - min) * pos
                    value = math.floor(value / step + 0.5) * step
                    default = value
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderLabel.Text = sliderName .. ": " .. string.format("%.5f", value)
                    callback(value)
                end
            end)
        end

        -- Hàm thêm dropdown (menu thả xuống)
        function tabContent:AddDropdown(options)
            local dropdownName = options.Name or "Dropdown"
            local optionsList = options.Options or {"Option 1", "Option 2"}
            local default = options.Default or optionsList[1]
            local callback = options.Callback or function() end

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = tabContent

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(0.7, 0, 1, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = dropdownName
            dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.SourceSans
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0, 120, 0, 30)
            dropdownBtn.Position = UDim2.new(1, -120, 0, 0)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownBtn.Text = default
            dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownBtn.TextSize = 14
            dropdownBtn.Font = Enum.Font.SourceSans
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Parent = dropdownFrame

            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 5)
            dropdownCorner.Parent = dropdownBtn

            local dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(0, 120, 0, 0)
            dropdownList.Position = UDim2.new(1, -120, 0, 30)
            dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownList.BorderSizePixel = 0
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = dropdownList

            for _, option in pairs(optionsList) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Size = UDim2.new(1, 0, 0, 30)
                optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                optionBtn.Text = option
                optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionBtn.TextSize = 14
                optionBtn.Font = Enum.Font.SourceSans
                optionBtn.BorderSizePixel = 0
                optionBtn.Parent = dropdownList

                -- Hỗ trợ cả PC và mobile
                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownList.Visible = false
                    dropdownList.Size = UDim2.new(0, 120, 0, 0)
                    callback(option)
                end)

                optionBtn.TouchTap:Connect(function()
                    dropdownBtn.Text = option
                    dropdownList.Visible = false
                    dropdownList.Size = UDim2.new(0, 120, 0, 0)
                    callback(option)
                end)
            end

            dropdownList.Size = UDim2.new(0, 120, 0, #optionsList * 30)

            -- Hỗ trợ cả PC và mobile
            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
                dropdownList.Size = dropdownList.Visible and UDim2.new(0, 120, 0, #optionsList * 30) or UDim2.new(0, 120, 0, 0)
            end)

            dropdownBtn.TouchTap:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
                dropdownList.Size = dropdownList.Visible and UDim2.new(0, 120, 0, #optionsList * 30) or UDim2.new(0, 120, 0, 0)
            end)
        end

        return tabContent
    end

    return window
end

return MyOrcaUI