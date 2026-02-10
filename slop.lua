-- 1:1 Replica UI Library based on reference images
-- Features: Multiple columns, sub-tabs, sliders, toggles, dropdowns, textboxes

local UILibrary = {}
UILibrary.__index = UILibrary

-- Color scheme matching the reference
local Colors = {
    Background = Color3.fromRGB(25, 25, 30),
    TopBar = Color3.fromRGB(20, 20, 25),
    TabBar = Color3.fromRGB(30, 30, 35),
    TabActive = Color3.fromRGB(45, 45, 50),
    SectionBackground = Color3.fromRGB(35, 35, 40),
    ElementBackground = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(230, 80, 100),
    AccentHover = Color3.fromRGB(250, 100, 120),
    TextPrimary = Color3.fromRGB(220, 220, 230),
    TextSecondary = Color3.fromRGB(150, 150, 160),
    Border = Color3.fromRGB(50, 50, 55),
    SliderFill = Color3.fromRGB(230, 80, 100)
}

function UILibrary:CreateWindow(config)
    local window = {}
    window.tabs = {}
    window.currentTab = nil
    
    config = config or {}
    local title = config.Title or "UI Library"
    local size = config.Size or UDim2.new(0, 700, 0, 500)
    
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
    
    -- Border
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Top gradient line
    local TopLine = Instance.new("Frame")
    TopLine.Name = "TopLine"
    TopLine.Parent = MainFrame
    TopLine.BackgroundColor3 = Colors.Accent
    TopLine.BorderSizePixel = 0
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 80, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 60, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 80, 100))
    }
    gradient.Parent = TopLine
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Colors.TabBar
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 2)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 0)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0, 37)
    ContentFrame.Size = UDim2.new(1, 0, 1, -37)
    
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TabBar = TabBar
    window.ContentFrame = ContentFrame
    
    -- Add to PlayerGui
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Tab creation
    function window:CreateTab(config)
        local tab = {}
        config = config or {}
        local name = config.Name or "Tab"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = Colors.TabBar
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 130, 1, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Colors.TextSecondary
        TabButton.TextSize = 11
        TabButton.AutoButtonColor = false
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.subTabs = {}
        tab.columns = {}
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.tabs) do
                t.Button.BackgroundColor3 = Colors.TabBar
                t.Button.TextColor3 = Colors.TextSecondary
                t.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Colors.TabActive
            TabButton.TextColor3 = Colors.TextPrimary
            TabContent.Visible = true
            window.currentTab = tab
        end)
        
        -- Activate first tab
        if #window.tabs == 0 then
            TabButton.BackgroundColor3 = Colors.TabActive
            TabButton.TextColor3 = Colors.TextPrimary
            TabContent.Visible = true
            window.currentTab = tab
        end
        
        table.insert(window.tabs, tab)
        
        -- Create columns container
        local ColumnsContainer = Instance.new("Frame")
        ColumnsContainer.Name = "ColumnsContainer"
        ColumnsContainer.Parent = TabContent
        ColumnsContainer.BackgroundTransparency = 1
        ColumnsContainer.Size = UDim2.new(1, 0, 1, 0)
        
        tab.ColumnsContainer = ColumnsContainer
        
        -- Create column
        function tab:CreateColumn(config)
            config = config or {}
            local width = config.Width or 0.5
            local position = config.Position or UDim2.new(0, 0, 0, 0)
            
            local column = {}
            column.sections = {}
            
            local ColumnFrame = Instance.new("ScrollingFrame")
            ColumnFrame.Name = "Column"
            ColumnFrame.Parent = ColumnsContainer
            ColumnFrame.BackgroundTransparency = 1
            ColumnFrame.BorderSizePixel = 0
            ColumnFrame.Position = position
            ColumnFrame.Size = UDim2.new(width, -10, 1, -10)
            ColumnFrame.ScrollBarThickness = 3
            ColumnFrame.ScrollBarImageColor3 = Colors.Accent
            ColumnFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local ColumnLayout = Instance.new("UIListLayout")
            ColumnLayout.Parent = ColumnFrame
            ColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ColumnLayout.Padding = UDim.new(0, 8)
            
            local ColumnPadding = Instance.new("UIPadding")
            ColumnPadding.Parent = ColumnFrame
            ColumnPadding.PaddingLeft = UDim.new(0, 10)
            ColumnPadding.PaddingRight = UDim.new(0, 10)
            ColumnPadding.PaddingTop = UDim.new(0, 10)
            
            -- Auto-resize canvas
            ColumnLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ColumnFrame.CanvasSize = UDim2.new(0, 0, 0, ColumnLayout.AbsoluteContentSize.Y + 20)
            end)
            
            column.Frame = ColumnFrame
            column.Layout = ColumnLayout
            
            -- Create section
            function column:CreateSection(sectionName, hasSubTabs)
                local section = {}
                section.subTabs = {}
                section.currentSubTab = nil
                
                -- Section Frame
                local SectionFrame = Instance.new("Frame")
                SectionFrame.Name = sectionName
                SectionFrame.Parent = ColumnFrame
                SectionFrame.BackgroundColor3 = Colors.SectionBackground
                SectionFrame.BorderSizePixel = 0
                SectionFrame.Size = UDim2.new(1, 0, 0, 50)
                SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                
                local SectionStroke = Instance.new("UIStroke")
                SectionStroke.Color = Colors.Border
                SectionStroke.Thickness = 1
                SectionStroke.Parent = SectionFrame
                
                -- Section Header
                local SectionHeader = Instance.new("TextLabel")
                SectionHeader.Name = "Header"
                SectionHeader.Parent = SectionFrame
                SectionHeader.BackgroundTransparency = 1
                SectionHeader.Position = UDim2.new(0, 10, 0, 5)
                SectionHeader.Size = UDim2.new(1, -20, 0, 20)
                SectionHeader.Font = Enum.Font.GothamBold
                SectionHeader.Text = sectionName
                SectionHeader.TextColor3 = Colors.TextPrimary
                SectionHeader.TextSize = 11
                SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
                
                local ContentContainer = Instance.new("Frame")
                ContentContainer.Name = "ContentContainer"
                ContentContainer.Parent = SectionFrame
                ContentContainer.BackgroundTransparency = 1
                ContentContainer.Position = UDim2.new(0, 0, 0, 30)
                ContentContainer.Size = UDim2.new(1, 0, 1, -30)
                ContentContainer.AutomaticSize = Enum.AutomaticSize.Y
                
                section.Frame = SectionFrame
                section.ContentContainer = ContentContainer
                
                -- Sub-tabs if needed
                if hasSubTabs then
                    local SubTabBar = Instance.new("Frame")
                    SubTabBar.Name = "SubTabBar"
                    SubTabBar.Parent = SectionFrame
                    SubTabBar.BackgroundTransparency = 1
                    SubTabBar.Position = UDim2.new(0, 0, 0, 25)
                    SubTabBar.Size = UDim2.new(1, 0, 0, 25)
                    
                    local SubTabLayout = Instance.new("UIListLayout")
                    SubTabLayout.Parent = SubTabBar
                    SubTabLayout.FillDirection = Enum.FillDirection.Horizontal
                    SubTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    SubTabLayout.Padding = UDim.new(0, 0)
                    
                    local SubTabPadding = Instance.new("UIPadding")
                    SubTabPadding.Parent = SubTabBar
                    SubTabPadding.PaddingLeft = UDim.new(0, 5)
                    
                    section.SubTabBar = SubTabBar
                    
                    ContentContainer.Position = UDim2.new(0, 0, 0, 55)
                    
                    function section:CreateSubTab(name)
                        local subTab = {}
                        
                        local SubTabButton = Instance.new("TextButton")
                        SubTabButton.Name = name
                        SubTabButton.Parent = SubTabBar
                        SubTabButton.BackgroundColor3 = Colors.ElementBackground
                        SubTabButton.BorderSizePixel = 0
                        SubTabButton.Size = UDim2.new(0, 100, 1, 0)
                        SubTabButton.Font = Enum.Font.Gotham
                        SubTabButton.Text = name
                        SubTabButton.TextColor3 = Colors.TextSecondary
                        SubTabButton.TextSize = 10
                        SubTabButton.AutoButtonColor = false
                        
                        local SubTabContent = Instance.new("Frame")
                        SubTabContent.Name = name .. "Content"
                        SubTabContent.Parent = ContentContainer
                        SubTabContent.BackgroundTransparency = 1
                        SubTabContent.Size = UDim2.new(1, 0, 0, 0)
                        SubTabContent.AutomaticSize = Enum.AutomaticSize.Y
                        SubTabContent.Visible = false
                        
                        local SubTabLayout = Instance.new("UIListLayout")
                        SubTabLayout.Parent = SubTabContent
                        SubTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        SubTabLayout.Padding = UDim.new(0, 5)
                        
                        local SubTabPadding = Instance.new("UIPadding")
                        SubTabPadding.Parent = SubTabContent
                        SubTabPadding.PaddingLeft = UDim.new(0, 10)
                        SubTabPadding.PaddingRight = UDim.new(0, 10)
                        SubTabPadding.PaddingTop = UDim.new(0, 5)
                        SubTabPadding.PaddingBottom = UDim.new(0, 5)
                        
                        subTab.Button = SubTabButton
                        subTab.Content = SubTabContent
                        
                        SubTabButton.MouseButton1Click:Connect(function()
                            for _, st in ipairs(section.subTabs) do
                                st.Button.BackgroundColor3 = Colors.ElementBackground
                                st.Button.TextColor3 = Colors.TextSecondary
                                st.Content.Visible = false
                            end
                            
                            SubTabButton.BackgroundColor3 = Colors.TabActive
                            SubTabButton.TextColor3 = Colors.TextPrimary
                            SubTabContent.Visible = true
                            section.currentSubTab = subTab
                        end)
                        
                        if #section.subTabs == 0 then
                            SubTabButton.BackgroundColor3 = Colors.TabActive
                            SubTabButton.TextColor3 = Colors.TextPrimary
                            SubTabContent.Visible = true
                            section.currentSubTab = subTab
                        end
                        
                        table.insert(section.subTabs, subTab)
                        
                        -- Element methods for subtab
                        subTab.AddToggle = function(self, config) return AddToggle(SubTabContent, config) end
                        subTab.AddSlider = function(self, config) return AddSlider(SubTabContent, config) end
                        subTab.AddDropdown = function(self, config) return AddDropdown(SubTabContent, config) end
                        subTab.AddTextBox = function(self, config) return AddTextBox(SubTabContent, config) end
                        subTab.AddKeybind = function(self, config) return AddKeybind(SubTabContent, config) end
                        
                        return subTab
                    end
                else
                    local MainContent = Instance.new("Frame")
                    MainContent.Parent = ContentContainer
                    MainContent.BackgroundTransparency = 1
                    MainContent.Size = UDim2.new(1, 0, 0, 0)
                    MainContent.AutomaticSize = Enum.AutomaticSize.Y
                    
                    local MainLayout = Instance.new("UIListLayout")
                    MainLayout.Parent = MainContent
                    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    MainLayout.Padding = UDim.new(0, 5)
                    
                    local MainPadding = Instance.new("UIPadding")
                    MainPadding.Parent = MainContent
                    MainPadding.PaddingLeft = UDim.new(0, 10)
                    MainPadding.PaddingRight = UDim.new(0, 10)
                    MainPadding.PaddingTop = UDim.new(0, 5)
                    MainPadding.PaddingBottom = UDim.new(0, 10)
                    
                    section.MainContent = MainContent
                    
                    -- Element methods for section
                    section.AddToggle = function(self, config) return AddToggle(MainContent, config) end
                    section.AddSlider = function(self, config) return AddSlider(MainContent, config) end
                    section.AddDropdown = function(self, config) return AddDropdown(MainContent, config) end
                    section.AddTextBox = function(self, config) return AddTextBox(MainContent, config) end
                    section.AddKeybind = function(self, config) return AddKeybind(MainContent, config) end
                end
                
                table.insert(column.sections, section)
                return section
            end
            
            table.insert(tab.columns, column)
            return column
        end
        
        return tab
    end
    
    return window
end

-- Toggle element
function AddToggle(parent, config)
    config = config or {}
    local name = config.Name or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 15)
    
    local Checkbox = Instance.new("Frame")
    Checkbox.Parent = ToggleFrame
    Checkbox.BackgroundColor3 = default and Colors.Accent or Colors.ElementBackground
    Checkbox.BorderSizePixel = 0
    Checkbox.Size = UDim2.new(0, 10, 0, 10)
    Checkbox.Position = UDim2.new(0, 0, 0, 2)
    
    local CheckboxStroke = Instance.new("UIStroke")
    CheckboxStroke.Color = Colors.Border
    CheckboxStroke.Thickness = 1
    CheckboxStroke.Parent = Checkbox
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 18, 0, 0)
    Label.Size = UDim2.new(1, -18, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.TextPrimary
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Button = Instance.new("TextButton")
    Button.Parent = ToggleFrame
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Text = ""
    
    local isToggled = default
    
    Button.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        Checkbox.BackgroundColor3 = isToggled and Colors.Accent or Colors.ElementBackground
        callback(isToggled)
    end)
    
    return {Value = isToggled, Set = function(val) isToggled = val Checkbox.BackgroundColor3 = val and Colors.Accent or Colors.ElementBackground end}
end

-- Slider element
function AddSlider(parent, config)
    config = config or {}
    local name = config.Name or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or 50
    local suffix = config.Suffix or ""
    local callback = config.Callback or function() end
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -50, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.TextPrimary
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -45, 0, 0)
    ValueLabel.Size = UDim2.new(0, 45, 0, 12)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default) .. suffix
    ValueLabel.TextColor3 = Colors.TextPrimary
    ValueLabel.TextSize = 10
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Parent = SliderFrame
    SliderBack.BackgroundColor3 = Colors.ElementBackground
    SliderBack.BorderSizePixel = 0
    SliderBack.Position = UDim2.new(0, 0, 0, 16)
    SliderBack.Size = UDim2.new(1, 0, 0, 4)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBack
    SliderFill.BackgroundColor3 = Colors.SliderFill
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBack
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local relativePos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * relativePos)
        SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        ValueLabel.Text = tostring(currentValue) .. suffix
        callback(currentValue)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    SliderBack.InputBegan:Connect(function(input)
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
    
    return {Value = currentValue}
end

-- Dropdown element
function AddDropdown(parent, config)
    config = config or {}
    local name = config.Name or "Dropdown"
    local options = config.Options or {"Option 1", "Option 2"}
    local default = config.Default or options[1]
    local callback = config.Callback or function() end
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
    DropdownFrame.ZIndex = 5
    
    local Label = Instance.new("TextLabel")
    Label.Parent = DropdownFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.TextPrimary
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Colors.ElementBackground
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Position = UDim2.new(0, 0, 0, 15)
    DropdownButton.Size = UDim2.new(1, 0, 0, 15)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = default
    DropdownButton.TextColor3 = Colors.TextPrimary
    DropdownButton.TextSize = 9
    DropdownButton.AutoButtonColor = false
    
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Colors.Border
    DropdownStroke.Thickness = 1
    DropdownStroke.Parent = DropdownButton
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Parent = DropdownButton
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(1, -15, 0, 0)
    Arrow.Size = UDim2.new(0, 15, 1, 0)
    Arrow.Font = Enum.Font.Gotham
    Arrow.Text = "▼"
    Arrow.TextColor3 = Colors.TextSecondary
    Arrow.TextSize = 8
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Parent = DropdownFrame
    OptionsFrame.BackgroundColor3 = Colors.ElementBackground
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Position = UDim2.new(0, 0, 0, 31)
    OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 15)
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 10
    
    local OptionsStroke = Instance.new("UIStroke")
    OptionsStroke.Color = Colors.Border
    OptionsStroke.Thickness = 1
    OptionsStroke.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsFrame
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local currentValue = default
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = OptionsFrame
        OptionButton.BackgroundColor3 = Colors.ElementBackground
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, 0, 0, 15)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Colors.TextPrimary
        OptionButton.TextSize = 9
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 11
        
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = Colors.TabActive
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundColor3 = Colors.ElementBackground
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            currentValue = option
            DropdownButton.Text = option
            OptionsFrame.Visible = false
            callback(option)
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)
    
    return {Value = currentValue}
end

-- TextBox element
function AddTextBox(parent, config)
    config = config or {}
    local name = config.Name or "TextBox"
    local default = config.Default or ""
    local placeholder = config.Placeholder or "value"
    local callback = config.Callback or function() end
    
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = TextBoxFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 12)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.TextPrimary
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = TextBoxFrame
    TextBox.BackgroundColor3 = Colors.ElementBackground
    TextBox.BorderSizePixel = 0
    TextBox.Position = UDim2.new(0, 0, 0, 15)
    TextBox.Size = UDim2.new(1, 0, 0, 15)
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = placeholder
    TextBox.Text = default
    TextBox.TextColor3 = Colors.TextPrimary
    TextBox.TextSize = 9
    TextBox.ClearTextOnFocus = false
    
    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.Color = Colors.Border
    TextBoxStroke.Thickness = 1
    TextBoxStroke.Parent = TextBox
    
    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
    
    return TextBox
end

-- Keybind element
function AddKeybind(parent, config)
    config = config or {}
    local name = config.Name or "Keybind"
    local default = config.Default or "None"
    local callback = config.Callback or function() end
    
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Parent = parent
    KeybindFrame.BackgroundTransparency = 1
    KeybindFrame.Size = UDim2.new(1, 0, 0, 15)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = KeybindFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.TextPrimary
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Parent = KeybindFrame
    KeybindButton.BackgroundColor3 = Colors.ElementBackground
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Position = UDim2.new(0.6, 0, 0, 0)
    KeybindButton.Size = UDim2.new(0.4, 0, 1, 0)
    KeybindButton.Font = Enum.Font.Gotham
    KeybindButton.Text = default
    KeybindButton.TextColor3 = Colors.TextSecondary
    KeybindButton.TextSize = 9
    
    local KeybindStroke = Instance.new("UIStroke")
    KeybindStroke.Color = Colors.Border
    KeybindStroke.Thickness = 1
    KeybindStroke.Parent = KeybindButton
    
    local listening = false
    local currentKey = default
    
    KeybindButton.MouseButton1Click:Connect(function()
        listening = true
        KeybindButton.Text = "..."
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                currentKey = input.KeyCode.Name
                KeybindButton.Text = currentKey
                listening = false
                callback(currentKey)
            end
        end
    end)
    
    return {Key = currentKey}
end

return UILibrary
