local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

local NotifyScreen = Instance.new("ScreenGui")
NotifyScreen.Name = "NotifyUI"
NotifyScreen.Parent = CoreGui

local NL = Instance.new("Frame")
NL.Name = "NL"
NL.Size = UDim2.new(0, 250, 1, -20)
NL.Position = UDim2.new(1, -260, 0, 10)
NL.BackgroundTransparency = 1
NL.Parent = NotifyScreen

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.Parent = NL

function Library:Notify(titleText, descText, duration)
    duration = duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotifFrame.BackgroundTransparency = 0.5
    NotifFrame.Parent = NL
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = NotifFrame
    
    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -10, 0, 20)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = titleText
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 14
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NotifFrame
    
    local NDesc = Instance.new("TextLabel")
    NDesc.Size = UDim2.new(1, -10, 0, 30)
    NDesc.Position = UDim2.new(0, 10, 0, 25)
    NDesc.BackgroundTransparency = 1
    NDesc.Text = descText
    NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NDesc.Font = Enum.Font.Gotham
    NDesc.TextSize = 12
    NDesc.TextWrapped = true
    NDesc.TextXAlignment = Enum.TextXAlignment.Left
    NDesc.TextYAlignment = Enum.TextYAlignment.Top
    NDesc.Parent = NotifFrame

    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(duration, function()
        local fade = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        TweenService:Create(NTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(NDesc, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        fade:Play()
        fade.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

function Library:CreateWindow(config)
    local MainTitle = config.Title or "Default Hub"
    local SubTitle = config.SubName or ""
    local CustomSize = config.Size or UDim2.fromOffset(500, 300)
    
    if config.Folder then
        if isfolder and makefolder then
            if not isfolder(config.Folder) then
                makefolder(config.Folder)
            end
        end
    end

    local Window = {}
    local CurrentTab = nil
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUI_" .. MainTitle
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    local Toolbar = Instance.new("Frame")
    Toolbar.Size = UDim2.new(0, 200, 0, 35)
    Toolbar.Position = UDim2.new(0.5, -100, 0, -40)
    Toolbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Toolbar.BackgroundTransparency = 0.4
    Toolbar.Visible = false
    Toolbar.Parent = ScreenGui
    Instance.new("UICorner", Toolbar).CornerRadius = UDim.new(0, 6)
    
    local ToolTitle = Instance.new("TextLabel")
    ToolTitle.Size = UDim2.new(1, -40, 1, 0)
    ToolTitle.Position = UDim2.new(0, 10, 0, 0)
    ToolTitle.BackgroundTransparency = 1
    ToolTitle.Text = MainTitle
    ToolTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToolTitle.Font = Enum.Font.GothamBold
    ToolTitle.TextSize = 14
    ToolTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToolTitle.Parent = Toolbar
    
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MaximizeBtn.Position = UDim2.new(1, -35, 0, 2)
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.Text = "⬜"
    MaximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeBtn.TextSize = 14
    MaximizeBtn.Parent = Toolbar

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = CustomSize -- Sử dụng Size từ config
    MainFrame.Position = UDim2.new(0.5, -CustomSize.X.Offset/2, 0.5, -CustomSize.Y.Offset/2)
    
    -- Custom Background
    if config.Background and config.BackgroundColor then
        MainFrame.BackgroundColor3 = config.BackgroundColor
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Đen mặc định
    end
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Drag
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- TOP BAR
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = MainTitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Subname
    if SubTitle ~= "" then
        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(0, 0, 1, 0)
        Sub.Position = UDim2.new(1, 5, 0, 2)
        Sub.BackgroundTransparency = 1
        Sub.Text = SubTitle
        Sub.TextColor3 = Color3.fromRGB(200, 200, 200)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 12
        Sub.AutomaticSize = Enum.AutomaticSize.X
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Parent = Title
        
        local SubStroke = Instance.new("UIStroke")
        SubStroke.Color = Color3.fromRGB(0, 0, 0)
        SubStroke.Thickness = 1
        SubStroke.Parent = Sub
    end

    -- TopBar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -65, 0, 5)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 20
    MinBtn.Parent = TopBar

    if config.Discord and config.Url then
        local DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Size = UDim2.new(0, 30, 0, 30)
        DiscordBtn.Position = UDim2.new(1, -100, 0, 5)
        DiscordBtn.BackgroundTransparency = 1
        DiscordBtn.Text = "@" -- Icon thay thế cho Discord
        DiscordBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
        DiscordBtn.Font = Enum.Font.GothamBold
        DiscordBtn.TextSize = 16
        DiscordBtn.Parent = TopBar

        DiscordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(config.Url)
                Library:Notify("Discord", "Đã copy link Discord vào bộ nhớ tạm!", 3)
            else
                Library:Notify("Lỗi", "Executor của bạn không hỗ trợ setclipboard!", 3)
            end
        end)
    end

    -- Logic Nút
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        Toolbar.Visible = true
        Toolbar.Position = UDim2.new(0.5, -100, 0, -40)
        TweenService:Create(Toolbar, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, 10)}):Play()
    end)

    MaximizeBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(Toolbar, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, -40)})
        tw:Play()
        tw.Completed:Wait()
        Toolbar.Visible = false
        MainFrame.Visible = true
    end)

    -- TAB BAR
    local TabCo = Instance.new("ScrollingFrame")
    TabCo.Size = UDim2.new(1, -20, 0, 30)
    TabCo.Position = UDim2.new(0, 10, 0, 40)
    TabCo.BackgroundTransparency = 1
    TabCo.ScrollBarThickness = 0
    TabCo.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabCo.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabCo.Parent = MainFrame
    
    local TabL = Instance.new("UIListLayout")
    TabL.FillDirection = Enum.FillDirection.Horizontal
    TabL.SortOrder = Enum.SortOrder.LayoutOrder
    TabL.Padding = UDim.new(0, 5)
    TabL.Parent = TabCo

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 1, -80)
    PageContainer.Position = UDim2.new(0, 10, 0, 75)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame


    function Window:CreateTab(TabName)
        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.Parent = TabCo
        
        local Underline = Instance.new("Frame")
        Underline.Size = UDim2.new(1, 0, 0, 2)
        Underline.Position = UDim2.new(0, 0, 1, -2)
        Underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Underline.Visible = false
        Underline.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(TabCo:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = Color3.fromRGB(150, 150, 150)
                    if child:FindFirstChild("Frame") then child.Frame.Visible = false end
                end
            end
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Underline.Visible = true
            Page.Visible = true
        end)

        if not CurrentTab then
            CurrentTab = TabBtn
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Underline.Visible = true
            Page.Visible = true
        end

        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Page
        end

        function Tab:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

            Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
        end

        function Tab:CreateToggle(text, default, callback)
            local toggled = default or false
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Txt = Instance.new("TextLabel")
            Txt.Size = UDim2.new(1, -50, 1, 0)
            Txt.Position = UDim2.new(0, 10, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = text
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.Font = Enum.Font.Gotham
            Txt.TextSize = 14
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.Parent = ToggleFrame

            local Indicator = Instance.new("TextButton")
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -30, 0.5, -10)
            Indicator.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
            Indicator.Text = ""
            Indicator.Parent = ToggleFrame
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

            Indicator.MouseButton1Click:Connect(function()
                toggled = not toggled
                Indicator.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
                if callback then callback(toggled) end
            end)
        end
        return Tab
    end
    return Window
end

return Library
