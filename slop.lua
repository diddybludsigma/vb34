-- Exact 1:1 Replica UI Library
-- Clean, minimal, proper colors

local UILibrary = {}
UILibrary.__index = UILibrary

-- EXACT color scheme from reference
local Colors = {
    MainBG = Color3.fromRGB(28, 28, 32),
    TabBarBG = Color3.fromRGB(35, 35, 40),
    TabActive = Color3.fromRGB(28, 28, 32),
    SectionBG = Color3.fromRGB(32, 32, 37),
    SectionHeader = Color3.fromRGB(38, 38, 43),
    SubTabBG = Color3.fromRGB(35, 35, 40),
    SubTabActive = Color3.fromRGB(42, 42, 47),
    
    Accent = Color3.fromRGB(220, 60, 85),
    AccentDark = Color3.fromRGB(180, 50, 70),
    
    Text = Color3.fromRGB(200, 200, 205),
    TextDim = Color3.fromRGB(140, 140, 145),
    
    Border = Color3.fromRGB(50, 50, 55),
    ElementBG = Color3.fromRGB(38, 38, 43),
    
    CheckboxBG = Color3.fromRGB(45, 45, 50),
    SliderBG = Color3.fromRGB(45, 45, 50)
}

function UILibrary:CreateWindow(config)
    local window = {}
    window.tabs = {}
    
    config = config or {}
    local size = config.Size or UDim2.new(0, 690, 0, 460)
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.MainBG
    MainFrame.BorderColor3 = Colors.Border
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(0.5, -345, 0.5, -230)
    MainFrame.Size = size
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Top accent line
    local TopLine = Instance.new("Frame")
    TopLine.Name = "TopLine"
    TopLine.Parent = MainFrame
    TopLine.BackgroundColor3 = Colors.Accent
    TopLine.BorderSizePixel = 0
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 55, 75)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 60, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 55, 75))
    }
    gradient.Parent = TopLine
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Colors.TabBarBG
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 2)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Content Container
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.MainBG
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0, 32)
    ContentFrame.Size = UDim2.new(1, 0, 1, -32)
    
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TabBar = TabBar
    window.ContentFrame = ContentFrame
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    function window:CreateTab(name)
        local tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = Colors.TabBarBG
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 115, 1, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Colors.TextDim
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.columns = {}
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.tabs) do
                t.Button.BackgroundColor3 = Colors.TabBarBG
                t.Button.TextColor3 = Colors.TextDim
                t.Content.Visible = false
            end
            TabButton.BackgroundColor3 = Colors.TabActive
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
        end)
        
        if #window.tabs == 0 then
            TabButton.BackgroundColor3 = Colors.TabActive
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
        end
        
        table.insert(window.tabs, tab)
        
        -- Create Left Column
        function tab:LeftColumn()
            local column = Instance.new("ScrollingFrame")
            column.Name = "Left"
            column.Parent = TabContent
            column.BackgroundTransparency = 1
            column.BorderSizePixel = 0
            column.Position = UDim2.new(0, 10, 0, 10)
            column.Size = UDim2.new(0.5, -15, 1, -20)
            column.ScrollBarThickness = 2
            column.ScrollBarImageColor3 = Colors.Border
            column.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local layout = Instance.new("UIListLayout")
            layout.Parent = column
            layout.Padding = UDim.new(0, 10)
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                column.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)
            
            return column
        end
        
        -- Create Right Column
        function tab:RightColumn()
            local column = Instance.new("ScrollingFrame")
            column.Name = "Right"
            column.Parent = TabContent
            column.BackgroundTransparency = 1
            column.BorderSizePixel = 0
            column.Position = UDim2.new(0.5, 5, 0, 10)
            column.Size = UDim2.new(0.5, -15, 1, -20)
            column.ScrollBarThickness = 2
            column.ScrollBarImageColor3 = Colors.Border
            column.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local layout = Instance.new("UIListLayout")
            layout.Parent = column
            layout.Padding = UDim.new(0, 10)
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                column.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)
            
            return column
        end
        
        return tab
    end
    
    return window
end

-- Section creator
function UILibrary:CreateSection(parent, name)
    local section = {}
    section.subTabs = {}
    
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = name
    SectionFrame.Parent = parent
    SectionFrame.BackgroundColor3 = Colors.SectionBG
    SectionFrame.BorderColor3 = Colors.Border
    SectionFrame.BorderSizePixel = 1
    SectionFrame.Size = UDim2.new(1, 0, 0, 200)
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = SectionFrame
    Header.BackgroundColor3 = Colors.SectionHeader
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 20)
    
    local HeaderText = Instance.new("TextLabel")
    HeaderText.Parent = Header
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.Text = name
    HeaderText.TextColor3 = Colors.Text
    HeaderText.TextSize = 11
    
    -- Sub-tab bar (if needed)
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabs"
    SubTabBar.Parent = SectionFrame
    SubTabBar.BackgroundTransparency = 1
    SubTabBar.Position = UDim2.new(0, 0, 0, 20)
    SubTabBar.Size = UDim2.new(1, 0, 0, 25)
    SubTabBar.Visible = false
    
    local SubTabLayout = Instance.new("UIListLayout")
    SubTabLayout.Parent = SubTabBar
    SubTabLayout.FillDirection = Enum.FillDirection.Horizontal
    
    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Parent = SectionFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 0, 0, 20)
    ContentArea.Size = UDim2.new(1, 0, 1, -20)
    ContentArea.AutomaticSize = Enum.AutomaticSize.Y
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = ContentArea
    ContentLayout.Padding = UDim.new(0, 4)
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = ContentArea
    ContentPadding.PaddingLeft = UDim.new(0, 8)
    ContentPadding.PaddingRight = UDim.new(0, 8)
    ContentPadding.PaddingTop = UDim.new(0, 6)
    ContentPadding.PaddingBottom = UDim.new(0, 8)
    
    section.Frame = SectionFrame
    section.Content = ContentArea
    section.SubTabBar = SubTabBar
    
    -- Add sub-tabs
    function section:AddSubTab(name)
        SubTabBar.Visible = true
        ContentArea.Position = UDim2.new(0, 0, 0, 45)
        
        local subTab = {}
        
        local SubButton = Instance.new("TextButton")
        SubButton.Name = name
        SubButton.Parent = SubTabBar
        SubButton.BackgroundColor3 = Colors.SubTabBG
        SubButton.BorderSizePixel = 0
        SubButton.Size = UDim2.new(0.5, 0, 1, 0)
        SubButton.Font = Enum.Font.Gotham
        SubButton.Text = name
        SubButton.TextColor3 = Colors.TextDim
        SubButton.TextSize = 10
        SubButton.AutoButtonColor = false
        
        local SubContent = Instance.new("Frame")
        SubContent.Name = name
        SubContent.Parent = ContentArea
        SubContent.BackgroundTransparency = 1
        SubContent.Size = UDim2.new(1, 0, 0, 0)
        SubContent.AutomaticSize = Enum.AutomaticSize.Y
        SubContent.Visible = false
        
        local SubLayout = Instance.new("UIListLayout")
        SubLayout.Parent = SubContent
        SubLayout.Padding = UDim.new(0, 4)
        
        subTab.Button = SubButton
        subTab.Content = SubContent
        
        SubButton.MouseButton1Click:Connect(function()
            for _, st in ipairs(section.subTabs) do
                st.Button.BackgroundColor3 = Colors.SubTabBG
                st.Button.TextColor3 = Colors.TextDim
                st.Content.Visible = false
            end
            SubButton.BackgroundColor3 = Colors.SubTabActive
            SubButton.TextColor3 = Colors.Text
            SubContent.Visible = true
        end)
        
        if #section.subTabs == 0 then
            SubButton.BackgroundColor3 = Colors.SubTabActive
            SubButton.TextColor3 = Colors.Text
            SubContent.Visible = true
        end
        
        table.insert(section.subTabs, subTab)
        
        -- Methods
        subTab.AddToggle = function(self, cfg) return AddToggle(SubContent, cfg) end
        subTab.AddSlider = function(self, cfg) return AddSlider(SubContent, cfg) end
        subTab.AddDropdown = function(self, cfg) return AddDropdown(SubContent, cfg) end
        subTab.AddTextBox = function(self, cfg) return AddTextBox(SubContent, cfg) end
        subTab.AddKeybind = function(self, cfg) return AddKeybind(SubContent, cfg) end
        subTab.AddLabel = function(self, cfg) return AddLabel(SubContent, cfg) end
        
        return subTab
    end
    
    -- Methods for non-subtab sections
    section.AddToggle = function(self, cfg) return AddToggle(ContentArea, cfg) end
    section.AddSlider = function(self, cfg) return AddSlider(ContentArea, cfg) end
    section.AddDropdown = function(self, cfg) return AddDropdown(ContentArea, cfg) end
    section.AddTextBox = function(self, cfg) return AddTextBox(ContentArea, cfg) end
    section.AddKeybind = function(self, cfg) return AddKeybind(ContentArea, cfg) end
    section.AddLabel = function(self, cfg) return AddLabel(ContentArea, cfg) end
    
    return section
end

-- Toggle
function AddToggle(parent, cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Toggle"
    local default = cfg.Default or false
    local callback = cfg.Callback or function() end
    
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 14)
    
    local Checkbox = Instance.new("Frame")
    Checkbox.Parent = Container
    Checkbox.BackgroundColor3 = default and Colors.Accent or Colors.CheckboxBG
    Checkbox.BorderColor3 = Colors.Border
    Checkbox.BorderSizePixel = 1
    Checkbox.Size = UDim2.new(0, 8, 0, 8)
    Checkbox.Position = UDim2.new(0, 0, 0, 3)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.Size = UDim2.new(1, -14, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Text = ""
    
    local toggled = default
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        Checkbox.BackgroundColor3 = toggled and Colors.Accent or Colors.CheckboxBG
        callback(toggled)
    end)
    
    return {Value = toggled}
end

-- Slider
function AddSlider(parent, cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Slider"
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local default = cfg.Default or 50
    local callback = cfg.Callback or function() end
    
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 26)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -40, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Container
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -35, 0, 0)
    ValueLabel.Size = UDim2.new(0, 35, 0, 12)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Colors.Text
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Parent = Container
    SliderBG.BackgroundColor3 = Colors.SliderBG
    SliderBG.BorderSizePixel = 0
    SliderBG.Position = UDim2.new(0, 0, 0, 16)
    SliderBG.Size = UDim2.new(1, 0, 0, 4)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBG
    SliderFill.BackgroundColor3 = Colors.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBG
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local dragging = false
    local value = default
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    SliderButton.MouseButton1Down:Connect(function() dragging = true end)
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    return {Value = value}
end

-- Dropdown
function AddDropdown(parent, cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Dropdown"
    local options = cfg.Options or {"Option 1"}
    local default = cfg.Default or options[1]
    local callback = cfg.Callback or function() end
    
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 26)
    Container.ZIndex = 5
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropButton = Instance.new("TextButton")
    DropButton.Parent = Container
    DropButton.BackgroundColor3 = Colors.ElementBG
    DropButton.BorderColor3 = Colors.Border
    DropButton.BorderSizePixel = 1
    DropButton.Position = UDim2.new(0, 0, 0, 14)
    DropButton.Size = UDim2.new(1, 0, 0, 12)
    DropButton.Font = Enum.Font.Gotham
    DropButton.Text = default
    DropButton.TextColor3 = Colors.Text
    DropButton.TextSize = 10
    DropButton.AutoButtonColor = false
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Parent = DropButton
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(1, -12, 0, 0)
    Arrow.Size = UDim2.new(0, 12, 1, 0)
    Arrow.Font = Enum.Font.Gotham
    Arrow.Text = "▼"
    Arrow.TextColor3 = Colors.TextDim
    Arrow.TextSize = 8
    
    local DropFrame = Instance.new("Frame")
    DropFrame.Parent = Container
    DropFrame.BackgroundColor3 = Colors.ElementBG
    DropFrame.BorderColor3 = Colors.Border
    DropFrame.BorderSizePixel = 1
    DropFrame.Position = UDim2.new(0, 0, 0, 27)
    DropFrame.Size = UDim2.new(1, 0, 0, #options * 12)
    DropFrame.Visible = false
    DropFrame.ZIndex = 10
    
    local DropLayout = Instance.new("UIListLayout")
    DropLayout.Parent = DropFrame
    
    local value = default
    
    for _, opt in ipairs(options) do
        local OptButton = Instance.new("TextButton")
        OptButton.Parent = DropFrame
        OptButton.BackgroundColor3 = Colors.ElementBG
        OptButton.BorderSizePixel = 0
        OptButton.Size = UDim2.new(1, 0, 0, 12)
        OptButton.Font = Enum.Font.Gotham
        OptButton.Text = opt
        OptButton.TextColor3 = Colors.Text
        OptButton.TextSize = 10
        OptButton.AutoButtonColor = false
        OptButton.ZIndex = 11
        
        OptButton.MouseEnter:Connect(function() OptButton.BackgroundColor3 = Colors.SubTabActive end)
        OptButton.MouseLeave:Connect(function() OptButton.BackgroundColor3 = Colors.ElementBG end)
        OptButton.MouseButton1Click:Connect(function()
            value = opt
            DropButton.Text = opt
            DropFrame.Visible = false
            callback(opt)
        end)
    end
    
    DropButton.MouseButton1Click:Connect(function()
        DropFrame.Visible = not DropFrame.Visible
    end)
    
    return {Value = value}
end

-- TextBox
function AddTextBox(parent, cfg)
    cfg = cfg or {}
    local name = cfg.Name or "TextBox"
    local default = cfg.Default or ""
    local callback = cfg.Callback or function() end
    
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 26)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Container
    TextBox.BackgroundColor3 = Colors.ElementBG
    TextBox.BorderColor3 = Colors.Border
    TextBox.BorderSizePixel = 1
    TextBox.Position = UDim2.new(0, 0, 0, 14)
    TextBox.Size = UDim2.new(1, 0, 0, 12)
    TextBox.Font = Enum.Font.Gotham
    TextBox.Text = default
    TextBox.TextColor3 = Colors.Text
    TextBox.TextSize = 10
    TextBox.ClearTextOnFocus = false
    
    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
    
    return TextBox
end

-- Keybind
function AddKeybind(parent, cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Keybind"
    local default = cfg.Default or "None"
    local callback = cfg.Callback or function() end
    
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 14)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local KeyButton = Instance.new("TextButton")
    KeyButton.Parent = Container
    KeyButton.BackgroundColor3 = Colors.ElementBG
    KeyButton.BorderColor3 = Colors.Border
    KeyButton.BorderSizePixel = 1
    KeyButton.Position = UDim2.new(0.6, 0, 0, 0)
    KeyButton.Size = UDim2.new(0.4, 0, 1, 0)
    KeyButton.Font = Enum.Font.Gotham
    KeyButton.Text = default
    KeyButton.TextColor3 = Colors.TextDim
    KeyButton.TextSize = 10
    
    local listening = false
    local key = default
    
    KeyButton.MouseButton1Click:Connect(function()
        listening = true
        KeyButton.Text = "..."
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
        if listening and not gpe and input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode.Name
            KeyButton.Text = key
            listening = false
            callback(key)
        end
    end)
    
    return {Key = key}
end

-- Label
function AddLabel(parent, cfg)
    cfg = cfg or {}
    local text = cfg.Text or "Label"
    
    local Label = Instance.new("TextLabel")
    Label.Parent = parent
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Colors.TextDim
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    return Label
end

return UILibrary
