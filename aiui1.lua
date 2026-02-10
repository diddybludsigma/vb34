--- ai slop 
-- Advanced CSGO-Style UI Library for Roblox
-- Reusable library for creating external cheat-style UIs

local UILibrary = {}
UILibrary.__index = UILibrary

-- Color scheme
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    TopBar = Color3.fromRGB(15, 15, 20),
    TabBackground = Color3.fromRGB(25, 25, 30),
    TabButton = Color3.fromRGB(30, 30, 35),
    TabButtonActive = Color3.fromRGB(138, 180, 248),
    ElementBackground = Color3.fromRGB(30, 30, 35),
    ElementActive = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(138, 180, 248),
    TextPrimary = Color3.fromRGB(200, 200, 210),
    TextSecondary = Color3.fromRGB(150, 150, 160),
    TextActive = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(60, 60, 70),
    CloseButton = Color3.fromRGB(220, 50, 50),
    MinimizeButton = Color3.fromRGB(80, 80, 90),
    SuccessButton = Color3.fromRGB(80, 180, 120),
    DangerButton = Color3.fromRGB(220, 80, 80)
}

-- Create new window
function UILibrary:CreateWindow(config)
    local window = {}
    window.tabs = {}
    window.currentTab = nil
    
    config = config or {}
    local title = config.Title or "UI Library"
    local size = config.Size or UDim2.new(0, 700, 0, 500)
    local theme = config.Theme or "Dark"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. title
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.Size = size
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Colors.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.Accent
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Colors.MinimizeButton
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -60, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 18
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinimizeButton
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Colors.TabBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 140, 1, -40)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 140, 0, 40)
    ContentFrame.Size = UDim2.new(1, -140, 1, -40)
    
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TabContainer = TabContainer
    window.ContentFrame = ContentFrame
    window.minimized = false
    
    -- Close functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        window.minimized = not window.minimized
        if window.minimized then
            MainFrame:TweenSize(UDim2.new(size.X.Scale, size.X.Offset, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            TabContainer.Visible = false
            ContentFrame.Visible = false
        else
            MainFrame:TweenSize(size, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            TabContainer.Visible = true
            ContentFrame.Visible = true
        end
    end)
    
    -- Add to PlayerGui
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Tab methods
    function window:CreateTab(config)
        local tab = {}
        config = config or {}
        local name = config.Name or "Tab"
        local icon = config.Icon or "⚙"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Colors.TabButton
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  " .. icon .. "  " .. name
        TabButton.TextColor3 = Colors.TextSecondary
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = TabButton
        
        -- Content Frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Colors.Accent
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = TabContent
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        
        local padding = Instance.new("UIPadding")
        padding.Parent = TabContent
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
        padding.PaddingTop = UDim.new(0, 15)
        padding.PaddingBottom = UDim.new(0, 15)
        
        -- Auto-resize canvas
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
        end)
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.Layout = layout
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.tabs) do
                t.Button.BackgroundColor3 = Colors.TabButton
                t.Button.TextColor3 = Colors.TextSecondary
                t.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Colors.TabButtonActive
            TabButton.TextColor3 = Colors.TextActive
            TabContent.Visible = true
            window.currentTab = tab
        end)
        
        -- Activate first tab
        if #window.tabs == 0 then
            TabButton.BackgroundColor3 = Colors.TabButtonActive
            TabButton.TextColor3 = Colors.TextActive
            TabContent.Visible = true
            window.currentTab = tab
        end
        
        table.insert(window.tabs, tab)
        
        -- Element creation methods
        function tab:AddSection(text)
            local header = Instance.new("TextLabel")
            header.Parent = TabContent
            header.BackgroundTransparency = 1
            header.Size = UDim2.new(1, 0, 0, 25)
            header.Font = Enum.Font.GothamBold
            header.Text = text
            header.TextColor3 = Colors.Accent
            header.TextSize = 14
            header.TextXAlignment = Enum.TextXAlignment.Left
            
            return header
        end
        
        function tab:AddToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Parent = TabContent
            frame.BackgroundColor3 = Colors.ElementBackground
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(1, 0, 0, 30)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 35, 0, 0)
            label.Size = UDim2.new(1, -35, 1, 0)
            label.Font = Enum.Font.Gotham
            label.Text = name
            label.TextColor3 = Colors.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local checkbox = Instance.new("TextButton")
            checkbox.Parent = frame
            checkbox.BackgroundColor3 = default and Colors.Accent or Colors.ElementActive
            checkbox.BorderSizePixel = 0
            checkbox.Position = UDim2.new(0, 8, 0.5, -8)
            checkbox.Size = UDim2.new(0, 16, 0, 16)
            checkbox.Text = ""
            
            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0, 3)
            checkCorner.Parent = checkbox
            
            local checkStroke = Instance.new("UIStroke")
            checkStroke.Color = Colors.Accent
            checkStroke.Thickness = 1
            checkStroke.Parent = checkbox
            
            local checkmark = Instance.new("TextLabel")
            checkmark.Parent = checkbox
            checkmark.BackgroundTransparency = 1
            checkmark.Size = UDim2.new(1, 0, 1, 0)
            checkmark.Font = Enum.Font.GothamBold
            checkmark.Text = "✓"
            checkmark.TextColor3 = Colors.Accent
            checkmark.TextSize = 12
            checkmark.Visible = default
            
            local isChecked = default
            
            checkbox.MouseButton1Click:Connect(function()
                isChecked = not isChecked
                checkmark.Visible = isChecked
                checkbox.BackgroundColor3 = isChecked and Colors.Accent or Colors.ElementActive
                callback(isChecked)
            end)
            
            local toggle = {}
            function toggle:SetValue(value)
                isChecked = value
                checkmark.Visible = isChecked
                checkbox.BackgroundColor3 = isChecked and Colors.Accent or Colors.ElementActive
            end
            
            return toggle
        end
        
        function tab:AddSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local callback = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Parent = TabContent
            frame.BackgroundColor3 = Colors.ElementBackground
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(1, 0, 0, 50)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Size = UDim2.new(1, -20, 0, 15)
            label.Font = Enum.Font.Gotham
            label.Text = name
            label.TextColor3 = Colors.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = frame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -50, 0, 5)
            valueLabel.Size = UDim2.new(0, 40, 0, 15)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local sliderBack = Instance.new("Frame")
            sliderBack.Parent = frame
            sliderBack.BackgroundColor3 = Colors.ElementActive
            sliderBack.BorderSizePixel = 0
            sliderBack.Position = UDim2.new(0, 10, 0, 28)
            sliderBack.Size = UDim2.new(1, -20, 0, 6)
            
            local sliderBackCorner = Instance.new("UICorner")
            sliderBackCorner.CornerRadius = UDim.new(0, 3)
            sliderBackCorner.Parent = sliderBack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBack
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(0, 3)
            sliderFillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Parent = sliderBack
            sliderButton.BackgroundColor3 = Colors.Accent
            sliderButton.BorderSizePixel = 0
            sliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Text = ""
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(1, 0)
            buttonCorner.Parent = sliderButton
            
            local dragging = false
            local currentValue = default
            
            local function updateSlider(input)
                local relativePos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * relativePos)
                
                sliderButton.Position = UDim2.new(relativePos, -6, 0.5, -6)
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                valueLabel.Text = tostring(currentValue)
                callback(currentValue)
            end
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            sliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            local slider = {}
            function slider:SetValue(value)
                currentValue = math.clamp(value, min, max)
                local relativePos = (currentValue - min) / (max - min)
                sliderButton.Position = UDim2.new(relativePos, -6, 0.5, -6)
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                valueLabel.Text = tostring(currentValue)
            end
            
            return slider
        end
        
        function tab:AddButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end
            local color = config.Color or Colors.Accent
            
            local button = Instance.new("TextButton")
            button.Parent = TabContent
            button.BackgroundColor3 = color
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 35)
            button.Font = Enum.Font.GothamBold
            button.Text = name
            button.TextColor3 = Colors.TextActive
            button.TextSize = 13
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = button
            
            button.MouseButton1Click:Connect(callback)
            
            return button
        end
        
        function tab:AddDropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2"}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Parent = TabContent
            frame.BackgroundColor3 = Colors.ElementBackground
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(1, 0, 0, 30)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Size = UDim2.new(0.5, -10, 1, 0)
            label.Font = Enum.Font.Gotham
            label.Text = name
            label.TextColor3 = Colors.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropButton = Instance.new("TextButton")
            dropButton.Parent = frame
            dropButton.BackgroundColor3 = Colors.ElementActive
            dropButton.BorderSizePixel = 0
            dropButton.Position = UDim2.new(0.5, 0, 0.5, -10)
            dropButton.Size = UDim2.new(0.5, -10, 0, 20)
            dropButton.Font = Enum.Font.Gotham
            dropButton.Text = default .. " ▼"
            dropButton.TextColor3 = Colors.TextPrimary
            dropButton.TextSize = 11
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 3)
            dropCorner.Parent = dropButton
            
            local dropdown = Instance.new("Frame")
            dropdown.Parent = frame
            dropdown.BackgroundColor3 = Colors.ElementActive
            dropdown.BorderSizePixel = 0
            dropdown.Position = UDim2.new(0.5, 0, 1, 5)
            dropdown.Size = UDim2.new(0.5, -10, 0, #options * 25)
            dropdown.Visible = false
            dropdown.ZIndex = 10
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 3)
            dropdownCorner.Parent = dropdown
            
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Parent = dropdown
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local currentValue = default
            
            for _, option in ipairs(options) do
                local optButton = Instance.new("TextButton")
                optButton.Parent = dropdown
                optButton.BackgroundColor3 = Colors.ElementActive
                optButton.BorderSizePixel = 0
                optButton.Size = UDim2.new(1, 0, 0, 25)
                optButton.Font = Enum.Font.Gotham
                optButton.Text = option
                optButton.TextColor3 = Colors.TextPrimary
                optButton.TextSize = 11
                
                optButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    dropButton.Text = option .. " ▼"
                    dropdown.Visible = false
                    callback(option)
                end)
            end
            
            dropButton.MouseButton1Click:Connect(function()
                dropdown.Visible = not dropdown.Visible
            end)
            
            return {Value = currentValue}
        end
        
        function tab:AddTextBox(config)
            config = config or {}
            local name = config.Name or "TextBox"
            local default = config.Default or ""
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Parent = TabContent
            frame.BackgroundColor3 = Colors.ElementBackground
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(1, 0, 0, 50)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Size = UDim2.new(1, -20, 0, 15)
            label.Font = Enum.Font.Gotham
            label.Text = name
            label.TextColor3 = Colors.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local textBox = Instance.new("TextBox")
            textBox.Parent = frame
            textBox.BackgroundColor3 = Colors.ElementActive
            textBox.BorderSizePixel = 0
            textBox.Position = UDim2.new(0, 10, 0, 25)
            textBox.Size = UDim2.new(1, -20, 0, 20)
            textBox.Font = Enum.Font.Gotham
            textBox.PlaceholderText = placeholder
            textBox.Text = default
            textBox.TextColor3 = Colors.TextPrimary
            textBox.TextSize = 11
            textBox.ClearTextOnFocus = false
            
            local textCorner = Instance.new("UICorner")
            textCorner.CornerRadius = UDim.new(0, 3)
            textCorner.Parent = textBox
            
            textBox.FocusLost:Connect(function()
                callback(textBox.Text)
            end)
            
            return textBox
        end
        
        return tab
    end
    
    function window:Destroy()
        ScreenGui:Destroy()
    end
    
    return window
end

return UILibrary
