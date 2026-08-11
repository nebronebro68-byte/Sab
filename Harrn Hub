
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

local ADMIN_ID = 11169216887
local REQUIRED_KEY = "Haroon1211"

local HaroonWindUI = {}
HaroonWindUI.__index = HaroonWindUI

--==================================================
-- THEME
--==================================================

HaroonWindUI.Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    Sidebar = Color3.fromRGB(18, 18, 24),
    Card = Color3.fromRGB(28, 28, 36),
    CardHover = Color3.fromRGB(40, 40, 52),

    AccentRed = Color3.fromRGB(230, 35, 60),
    IndicatorBlue = Color3.fromRGB(0, 140, 255),

    TextActive = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(150, 150, 170),
    SubText = Color3.fromRGB(170, 170, 190),

    Border = Color3.fromRGB(50, 50, 65),
    ToggleOff = Color3.fromRGB(45, 45, 58),

    MultiSelectSelected = Color3.fromRGB(60, 60, 80),

    NotificationClose = Color3.fromRGB(255, 50, 50),

    KeySystemBg = Color3.fromRGB(20, 20, 28),
    KeySystemAccent = Color3.fromRGB(60, 120, 255),

    LoadingBg = Color3.fromRGB(25, 25, 35)
}

--==================================================
-- ICONS
--==================================================

local ICONS = {
    Close = "rbxassetid://96287149287629",

    Minimize = "rbxassetid://121960953523495",

    Maximize = "rbxassetid://15928997778",

    Verified = "rbxassetid://90637005932446",

    ButtonDefault = "rbxassetid://7158102700",

    Checkmark = "rbxassetid://3926305904",

    ToggleUI = "rbxassetid://78282125662320",

    LoadingSpinner = "rbxassetid://6031206606"
}

local SOUNDS = {
    Notification = "rbxassetid://117653664939966"
}

--==================================================
-- HELPERS
--==================================================

local function FastTween(object, time, properties, style, direction)

    if not object or not object.Parent then
        return
    end

    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out

    local tweenInfo = TweenInfo.new(
        time,
        style,
        direction
    )

    local tween = TweenService:Create(
        object,
        tweenInfo,
        properties
    )

    tween:Play()

    return tween
end

local function GetUIParent()

    if type(gethui) == "function" then

        local success, hui = pcall(gethui)

        if success and hui then
            return hui
        end
    end

    if CoreGui then
        return CoreGui
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local function SafeDestroy(object)

    if object then
        pcall(function()
            object:Destroy()
        end)
    end
end

local function HSV_to_RGB(h, s, v)

    local i = math.floor(h * 6)

    local f = h * 6 - i

    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    local r, g, b

    if i % 6 == 0 then
        r, g, b = v, t, p
    elseif i % 6 == 1 then
        r, g, b = q, v, p
    elseif i % 6 == 2 then
        r, g, b = p, v, t
    elseif i % 6 == 3 then
        r, g, b = p, q, v
    elseif i % 6 == 4 then
        r, g, b = t, p, v
    else
        r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

--==================================================
-- DRAG SYSTEM
--==================================================

local function EnableSmoothDrag(frame, handle)

    if not frame or not handle then
        return
    end

    local dragging = false

    local dragStart
    local startPosition

    local dragInput

    handle.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end

            end)
        end

    end)

    handle.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input ~= dragInput then
            return
        end

        if not frame.Parent then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

    end)
end

--==================================================
-- NOTIFICATION SOUND
--==================================================

local function PlayNotificationSound()

    local success = pcall(function()

        local sound = Instance.new("Sound")

        sound.SoundId = SOUNDS.Notification
        sound.Volume = 0.5

        sound.Parent = SoundService

        sound:Play()

        sound.Ended:Connect(function()
            SafeDestroy(sound)
        end)

        task.delay(10, function()

            if sound.Parent then
                SafeDestroy(sound)
            end

        end)

    end)

    if not success then
        return
    end
end

--==================================================
-- NOTIFICATIONS
--==================================================

function HaroonWindUI:Notify(config)

    config = config or {}

    local title = tostring(
        config.Title or "Notification"
    )

    local content = tostring(
        config.Content or ""
    )

    local duration = tonumber(
        config.Duration or 3
    ) or 3

    duration = math.max(duration, 0.5)

    PlayNotificationSound()

    local parentUI = GetUIParent()

    local holder =
        parentUI:FindFirstChild("HaroonNotificationHolder")

    if not holder then

        holder = Instance.new("Frame")

        holder.Name =
            "HaroonNotificationHolder"

        holder.Size =
            UDim2.fromOffset(280, 420)

        holder.Position =
            UDim2.new(1, -295, 0, 15)

        holder.BackgroundTransparency = 1

        holder.Parent = parentUI

        local padding =
            Instance.new("UIPadding")

        padding.PaddingTop =
            UDim.new(0, 5)

        padding.PaddingBottom =
            UDim.new(0, 5)

        padding.Parent = holder

        local layout =
            Instance.new("UIListLayout")

        layout.SortOrder =
            Enum.SortOrder.LayoutOrder

        layout.VerticalAlignment =
            Enum.VerticalAlignment.Top

        layout.Padding =
            UDim.new(0, 7)

        layout.Parent = holder
    end

    local toast =
        Instance.new("Frame")

    toast.Name = "Notification"

    toast.Size =
        UDim2.new(1, 0, 0, 68)

    toast.BackgroundColor3 =
        HaroonWindUI.Theme.Card

    toast.BackgroundTransparency = 0

    toast.BorderSizePixel = 0

    toast.ClipsDescendants = true

    toast.Parent = holder

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 7)

    corner.Parent = toast

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        HaroonWindUI.Theme.AccentRed

    stroke.Thickness = 1

    stroke.Parent = toast

    local titleLabel =
        Instance.new("TextLabel")

    titleLabel.Size =
        UDim2.new(1, -45, 0, 19)

    titleLabel.Position =
        UDim2.new(0, 10, 0, 6)

    titleLabel.Text =
        title

    titleLabel.Font =
        Enum.Font.GothamBold

    titleLabel.TextColor3 =
        HaroonWindUI.Theme.TextActive

    titleLabel.TextSize = 12

    titleLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    titleLabel.TextTruncate =
        Enum.TextTruncate.AtEnd

    titleLabel.BackgroundTransparency = 1

    titleLabel.Parent = toast

    local contentLabel =
        Instance.new("TextLabel")

    contentLabel.Size =
        UDim2.new(1, -20, 0, 25)

    contentLabel.Position =
        UDim2.new(0, 10, 0, 27)

    contentLabel.Text =
        content

    contentLabel.Font =
        Enum.Font.Gotham

    contentLabel.TextColor3 =
        HaroonWindUI.Theme.SubText

    contentLabel.TextSize = 10

    contentLabel.TextWrapped = true

    contentLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    contentLabel.TextYAlignment =
        Enum.TextYAlignment.Top

    contentLabel.BackgroundTransparency = 1

    contentLabel.Parent = toast

    local closeButton =
        Instance.new("ImageButton")

    closeButton.Size =
        UDim2.fromOffset(17, 17)

    closeButton.Position =
        UDim2.new(1, -25, 0, 7)

    closeButton.BackgroundTransparency = 1

    closeButton.Image =
        ICONS.Close

    closeButton.ImageColor3 =
        HaroonWindUI.Theme.NotificationClose

    closeButton.Parent = toast

    local timeBar =
        Instance.new("Frame")

    timeBar.Size =
        UDim2.new(1, -20, 0, 4)

    timeBar.Position =
        UDim2.new(0, 10, 1, -9)

    timeBar.BackgroundColor3 =
        HaroonWindUI.Theme.ToggleOff

    timeBar.BorderSizePixel = 0

    timeBar.Parent = toast

    local timeCorner =
        Instance.new("UICorner")

    timeCorner.CornerRadius =
        UDim.new(1, 0)

    timeCorner.Parent = timeBar

    local timeFill =
        Instance.new("Frame")

    timeFill.Size =
        UDim2.new(1, 0, 1, 0)

    timeFill.BackgroundColor3 =
        HaroonWindUI.Theme.AccentRed

    timeFill.BorderSizePixel = 0

    timeFill.Parent = timeBar

    local timeFillCorner =
        Instance.new("UICorner")

    timeFillCorner.CornerRadius =
        UDim.new(1, 0)

    timeFillCorner.Parent = timeFill

    local closed = false

    local function closeToast()

        if closed then
            return
        end

        closed = true

        local tween =
            FastTween(
                toast,
                0.25,
                {
                    Size = UDim2.new(
                        1,
                        0,
                        0,
                        0
                    )
                },
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            )

        if tween then

            tween.Completed:Connect(function()
                SafeDestroy(toast)
            end)

        else
            SafeDestroy(toast)
        end
    end

    closeButton.MouseButton1Click:Connect(
        closeToast
    )

    task.spawn(function()

        local startTime = os.clock()

        while toast.Parent and not closed do

            local elapsed =
                os.clock() - startTime

            local remaining =
                math.max(
                    duration - elapsed,
                    0
                )

            timeFill.Size =
                UDim2.new(
                    remaining / duration,
                    0,
                    1,
                    0
                )

            if remaining <= 0 then
                break
            end

            task.wait(0.05)
        end

        if toast.Parent and not closed then
            closeToast()
        end

    end)

    return toast
end

--==================================================
-- CREATE WINDOW
--==================================================

function HaroonWindUI:CreateWindow(config)

    config = config or {}

    local windowTitle =
        tostring(config.Title or "Haroon UI")

    local windowSubtitle =
        tostring(config.SubTitle or "PRO EDITION")

    local defaultSize =
        config.Size or
        UDim2.fromOffset(500, 340)

    local minimizedSize =
        UDim2.fromOffset(
            defaultSize.X.Offset,
            50
        )

    local parentUI =
        GetUIParent()

    local oldGui =
        parentUI:FindFirstChild(
            "HaroonWindRedGui"
        )

    if oldGui then
        SafeDestroy(oldGui)
    end

    local ScreenGui =
        Instance.new("ScreenGui")

    ScreenGui.Name =
        "HaroonWindRedGui"

    ScreenGui.ResetOnSpawn = false

    ScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    ScreenGui.Parent =
        parentUI

    --==============================================
    -- MAIN FRAME
    --==============================================

    local MainFrame =
        Instance.new("Frame")

    MainFrame.Name =
        "MainFrame"

    MainFrame.Size =
        UDim2.fromOffset(0, 0)

    MainFrame.Position =
        UDim2.new(0.5, 0, 0.5, 0)

    MainFrame.AnchorPoint =
        Vector2.new(0.5, 0.5)

    MainFrame.BackgroundColor3 =
        HaroonWindUI.Theme.Background

    MainFrame.BorderSizePixel = 0

    MainFrame.ClipsDescendants = true

    MainFrame.Visible = false

    MainFrame.Parent =
        ScreenGui

    local mainCorner =
        Instance.new("UICorner")

    mainCorner.CornerRadius =
        UDim.new(0, 10)

    mainCorner.Parent =
        MainFrame

    local mainStroke =
        Instance.new("UIStroke")

    mainStroke.Color =
        HaroonWindUI.Theme.Border

    mainStroke.Thickness = 1

    mainStroke.Parent =
        MainFrame

    task.spawn(function()

        local hue = 0

        while MainFrame.Parent do

            hue =
                (hue + 0.005) % 1

            mainStroke.Color =
                HSV_to_RGB(
                    hue,
                    1,
                    1
                )

            task.wait(0.03)
        end
    end)

    --==============================================
    -- TOP BAR
    --==============================================

    local TopBar =
        Instance.new("Frame")

    TopBar.Name =
        "TopBar"

    TopBar.Size =
        UDim2.new(1, 0, 0, 50)

    TopBar.BackgroundColor3 =
        HaroonWindUI.Theme.Sidebar

    TopBar.BorderSizePixel = 0

    TopBar.Parent =
        MainFrame

    EnableSmoothDrag(
        MainFrame,
        TopBar
    )

    local titleLabel =
        Instance.new("TextLabel")

    titleLabel.Size =
        UDim2.new(0, 250, 0, 20)

    titleLabel.Position =
        UDim2.new(0, 12, 0, 5)

    titleLabel.Text =
        windowTitle

    titleLabel.Font =
        Enum.Font.GothamBold

    titleLabel.TextColor3 =
        HaroonWindUI.Theme.TextActive

    titleLabel.TextSize = 13

    titleLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    titleLabel.BackgroundTransparency = 1

    titleLabel.Parent =
        TopBar

    local subtitleLabel =
        Instance.new("TextLabel")

    subtitleLabel.Size =
        UDim2.new(0, 250, 0, 15)

    subtitleLabel.Position =
        UDim2.new(0, 12, 0, 25)

    subtitleLabel.Text =
        windowSubtitle

    subtitleLabel.Font =
        Enum.Font.Gotham

    subtitleLabel.TextColor3 =
        HaroonWindUI.Theme.AccentRed

    subtitleLabel.TextSize = 10

    subtitleLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    subtitleLabel.BackgroundTransparency = 1

    subtitleLabel.Parent =
        TopBar

    --==============================================
    -- CONTROLS
    --==============================================

    local Controls =
        Instance.new("Frame")

    Controls.Size =
        UDim2.fromOffset(85, 50)

    Controls.Position =
        UDim2.new(1, -90, 0, 0)

    Controls.BackgroundTransparency = 1

    Controls.Parent =
        TopBar

    local function CreateHeaderButton(
        icon,
        x,
        callback
    )

        local button =
            Instance.new("ImageButton")

        button.Size =
            UDim2.fromOffset(18, 18)

        button.Position =
            UDim2.new(
                0,
                x,
                0.5,
                -9
            )

        button.BackgroundTransparency = 1

        button.Image = icon

        button.ImageColor3 =
            HaroonWindUI.Theme.TextInactive

        button.Parent =
            Controls

        button.MouseEnter:Connect(function()

            FastTween(
                button,
                0.15,
                {
                    ImageColor3 =
                        HaroonWindUI.Theme.AccentRed
                }
            )

        end)

        button.MouseLeave:Connect(function()

            FastTween(
                button,
                0.15,
                {
                    ImageColor3 =
                        HaroonWindUI.Theme.TextInactive
                }
            )

        end)

        button.MouseButton1Click:Connect(
            function()
                pcall(callback)
            end
        )

        return button
    end

    local Sidebar
    local ContentContainer

    local isMinimized = false
    local destroyed = false

    local MinimizeButton

    -- Close
    CreateHeaderButton(
        ICONS.Close,
        62,
        function()

            if destroyed then
                return
            end

            destroyed = true

            local tween =
                FastTween(
                    MainFrame,
                    0.25,
                    {
                        Size =
                            UDim2.fromOffset(
                                0,
                                0
                            )
                    },
                    Enum.EasingStyle.Back,
                    Enum.EasingDirection.In
                )

            if tween then

                tween.Completed:Connect(
                    function()

                        SafeDestroy(
                            ScreenGui
                        )

                        local toggleGui =
                            parentUI:FindFirstChild(
                                "HaroonUIToggleButton"
                            )

                        if toggleGui then
                            SafeDestroy(toggleGui)
                        end
                    end
                )

            else

                SafeDestroy(ScreenGui)

            end
        end
    )

    --==============================================
    -- SIDEBAR
    --==============================================

    Sidebar =
        Instance.new("Frame")

    Sidebar.Name =
        "Sidebar"

    Sidebar.Size =
        UDim2.new(
            0,
            140,
            1,
            -50
        )

    Sidebar.Position =
        UDim2.new(
            0,
            0,
            0,
            50
        )

    Sidebar.BackgroundColor3 =
        HaroonWindUI.Theme.Sidebar

    Sidebar.BorderSizePixel = 0

    Sidebar.Parent =
        MainFrame

    local sidebarCorner =
        Instance.new("UICorner")

    sidebarCorner.CornerRadius =
        UDim.new(0, 10)

    sidebarCorner.Parent =
        Sidebar

    --==============================================
    -- CONTENT
    --==============================================

    ContentContainer =
        Instance.new("Frame")

    ContentContainer.Name =
        "ContentContainer"

    ContentContainer.Size =
        UDim2.new(
            1,
            -140,
            1,
            -50
        )

    ContentContainer.Position =
        UDim2.new(
            0,
            140,
            0,
            50
        )

    ContentContainer.BackgroundTransparency = 1

    ContentContainer.ClipsDescendants = true

    ContentContainer.Parent =
        MainFrame

    --==============================================
    -- INDICATOR
    --==============================================

    local Indicator =
        Instance.new("Frame")

    Indicator.Name =
        "ActiveTabIndicator"

    Indicator.Size =
        UDim2.new(
            0,
            3,
            0,
            24
        )

    Indicator.Position =
        UDim2.new(
            0,
            0,
            0,
            9
        )

    Indicator.BackgroundColor3 =
        HaroonWindUI.Theme.IndicatorBlue

    Indicator.BorderSizePixel = 0

    Indicator.Visible = false

    Indicator.Parent =
        Sidebar

    local indicatorCorner =
        Instance.new("UICorner")

    indicatorCorner.CornerRadius =
        UDim.new(0, 4)

    indicatorCorner.Parent =
        Indicator

    --==============================================
    -- TABS HOLDER
    --==============================================

    local TabsHolder =
        Instance.new("ScrollingFrame")

    TabsHolder.Size =
        UDim2.new(
            1,
            0,
            1,
            -55
        )

    TabsHolder.BackgroundTransparency = 1

    TabsHolder.BorderSizePixel = 0

    TabsHolder.ScrollBarThickness = 0

    TabsHolder.CanvasSize =
        UDim2.new(0, 0, 0, 0)

    TabsHolder.Parent =
        Sidebar

    local tabsPadding =
        Instance.new("UIPadding")

    tabsPadding.PaddingTop =
        UDim.new(0, 7)

    tabsPadding.PaddingLeft =
        UDim.new(0, 8)

    tabsPadding.PaddingRight =
        UDim.new(0, 8)

    tabsPadding.Parent =
        TabsHolder

    local tabsLayout =
        Instance.new("UIListLayout")

    tabsLayout.SortOrder =
        Enum.SortOrder.LayoutOrder

    tabsLayout.Padding =
        UDim.new(0, 4)

    tabsLayout.Parent =
        TabsHolder

    tabsLayout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function()

        TabsHolder.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                tabsLayout.AbsoluteContentSize.Y + 15
            )
    end)

    --==============================================
    -- PROFILE
    --==============================================

    local ProfileFrame =
        Instance.new("Frame")

    ProfileFrame.Size =
        UDim2.new(
            1,
            0,
            0,
            50
        )

    ProfileFrame.Position =
        UDim2.new(
            0,
            0,
            1,
            -50
        )

    ProfileFrame.BackgroundColor3 =
        HaroonWindUI.Theme.Background

    ProfileFrame.BorderSizePixel = 0

    ProfileFrame.Parent =
        Sidebar

    local profileCorner =
        Instance.new("UICorner")

    profileCorner.CornerRadius =
        UDim.new(0, 10)

    profileCorner.Parent =
        ProfileFrame

    local profileStroke =
        Instance.new("UIStroke")

    profileStroke.Color =
        HaroonWindUI.Theme.Border

    profileStroke.Parent =
        ProfileFrame

    local avatar =
        Instance.new("ImageLabel")

    avatar.Size =
        UDim2.fromOffset(34, 34)

    avatar.Position =
        UDim2.new(
            0,
            8,
            0.5,
            -17
        )

    avatar.BackgroundColor3 =
        HaroonWindUI.Theme.Card

    avatar.BackgroundTransparency = 0

    avatar.Parent =
        ProfileFrame

    local avatarCorner =
        Instance.new("UICorner")

    avatarCorner.CornerRadius =
        UDim.new(1, 0)

    avatarCorner.Parent =
        avatar

    task.spawn(function()

        local success, content, loaded =
            pcall(
                Players.GetUserThumbnailAsync,
                Players,
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )

        if success
        and loaded
        and avatar.Parent then

            avatar.Image = content
        end
    end)

    local userName =
        Instance.new("TextLabel")

    userName.Size =
        UDim2.new(
            0,
            75,
            0,
            16
        )

    userName.Position =
        UDim2.new(
            0,
            46,
            0,
            7
        )

    userName.Text =
        LocalPlayer.DisplayName

    userName.Font =
        Enum.Font.GothamBold

    userName.TextColor3 =
        HaroonWindUI.Theme.TextActive

    userName.TextSize = 11

    userName.TextXAlignment =
        Enum.TextXAlignment.Left

    userName.TextTruncate =
        Enum.TextTruncate.AtEnd

    userName.BackgroundTransparency = 1

    userName.Parent =
        ProfileFrame

    local isAdmin =
        LocalPlayer.UserId == ADMIN_ID

    if isAdmin then

        local verified =
            Instance.new("ImageLabel")

        verified.Size =
            UDim2.fromOffset(14, 14)

        verified.Position =
            UDim2.new(
                0,
                120,
                0,
                8
            )

        verified.Image =
            ICONS.Verified

        verified.BackgroundTransparency = 1

        verified.Parent =
            ProfileFrame
    end

    local role =
        Instance.new("TextLabel")

    role.Size =
        UDim2.new(
            0,
            90,
            0,
            14
        )

    role.Position =
        UDim2.new(
            0,
            46,
            0,
            25
        )

    role.Text =
        isAdmin
        and "Developer Of The Library"
        or ("ID: " .. tostring(LocalPlayer.UserId))

    role.Font =
        Enum.Font.Gotham

    role.TextColor3 =
        isAdmin
        and HaroonWindUI.Theme.AccentRed
        or HaroonWindUI.Theme.SubText

    role.TextSize = 8

    role.TextXAlignment =
        Enum.TextXAlignment.Left

    role.TextTruncate =
        Enum.TextTruncate.AtEnd

    role.BackgroundTransparency = 1

    role.Parent =
        ProfileFrame

    --==============================================
    -- WINDOW OBJECT
    --==============================================

    local WindowObj = {

        ScreenGui = ScreenGui,

        MainFrame = MainFrame,

        Tabs = {},

        ActiveTab = nil,

        Destroyed = false
    }

    --==============================================
    -- MINIMIZE
    --==============================================

    MinimizeButton =
        CreateHeaderButton(
            ICONS.Minimize,
            32,
            function()

                if destroyed
                or not MainFrame.Parent then
                    return
                end

                isMinimized =
                    not isMinimized

                if isMinimized then

                    FastTween(
                        MainFrame,
                        0.3,
                        {
                            Size =
                                minimizedSize
                        }
                    )

                    Sidebar.Visible = false

                    ContentContainer.Visible = false

                    MinimizeButton.Image =
                        ICONS.Maximize

                else

                    FastTween(
                        MainFrame,
                        0.3,
                        {
                            Size =
                                defaultSize
                        }
                    )

                    Sidebar.Visible = true

                    ContentContainer.Visible = true

                    MinimizeButton.Image =
                        ICONS.Minimize
                end

            end
        )

    --==============================================
    -- SHOW
    --==============================================

    function WindowObj:Show()

        if destroyed then
            return
        end

        MainFrame.Visible = true

        MainFrame.Size =
            UDim2.fromOffset(0, 0)

        MainFrame.Position =
            UDim2.new(
                0.5,
                0,
                0.5,
                0
            )

        local tween =
            FastTween(
                MainFrame,
                0.45,
                {
                    Size = defaultSize,

                    Position =
                        UDim2.new(
                            0.5,
                            0,
                            0.5,
                            0
                        )
                },
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            )

        return tween
    end

    --==============================================
    -- DESTROY
    --==============================================

    function WindowObj:Destroy()

        if destroyed then
            return
        end

        destroyed = true
        WindowObj.Destroyed = true

        SafeDestroy(ScreenGui)

        local toggleGui =
            parentUI:FindFirstChild(
                "HaroonUIToggleButton"
            )

        if toggleGui then
            SafeDestroy(toggleGui)
        end
    end

    --==============================================
    -- CREATE TAB
    --==============================================

    function WindowObj:CreateTab(tabName)

        tabName =
            tostring(tabName or "Tab")

        local TabButton =
            Instance.new("TextButton")

        TabButton.Size =
            UDim2.new(
                1,
                0,
                0,
                30
            )

        TabButton.BackgroundTransparency = 1

        TabButton.Text =
            tabName

        TabButton.TextColor3 =
            HaroonWindUI.Theme.TextInactive

        TabButton.Font =
            Enum.Font.GothamMedium

        TabButton.TextSize = 12

        TabButton.TextXAlignment =
            Enum.TextXAlignment.Left

        TabButton.AutoButtonColor = false

        TabButton.Parent =
            TabsHolder

        local tabPadding =
            Instance.new("UIPadding")

        tabPadding.PaddingLeft =
            UDim.new(0, 12)

        tabPadding.PaddingRight =
            UDim.new(0, 8)

        tabPadding.Parent =
            TabButton

        local tabCorner =
            Instance.new("UICorner")

        tabCorner.CornerRadius =
            UDim.new(0, 6)

        tabCorner.Parent =
            TabButton

        local Page =
            Instance.new("ScrollingFrame")

        Page.Size =
            UDim2.new(1, 0, 1, 0)

        Page.BackgroundTransparency = 1

        Page.BorderSizePixel = 0

        Page.ScrollBarThickness = 2

        Page.ScrollBarImageColor3 =
            HaroonWindUI.Theme.AccentRed

        Page.CanvasSize =
            UDim2.new(0, 0, 0, 0)

        Page.Visible = false

        Page.Parent =
            ContentContainer

        local pagePadding =
            Instance.new("UIPadding")

        pagePadding.PaddingTop =
            UDim.new(0, 10)

        pagePadding.PaddingLeft =
            UDim.new(0, 12)

        pagePadding.PaddingRight =
            UDim.new(0, 12)

        pagePadding.PaddingBottom =
            UDim.new(0, 10)

        pagePadding.Parent =
            Page

        local pageLayout =
            Instance.new("UIListLayout")

        pageLayout.SortOrder =
            Enum.SortOrder.LayoutOrder

        pageLayout.Padding =
            UDim.new(0, 8)

        pageLayout.Parent =
            Page

        pageLayout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()

            Page.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    pageLayout.AbsoluteContentSize.Y + 20
                )
        end)

        local TabObj = {

            Page = Page,

            Button = TabButton,

            Window = WindowObj
        }

        local function ActivateTab()

            if destroyed then
                return
            end

            for _, tab in ipairs(
                WindowObj.Tabs
            ) do

                if tab.Page then
                    tab.Page.Visible = false
                end

                if tab.Button then

                    FastTween(
                        tab.Button,
                        0.15,
                        {
                            TextColor3 =
                                HaroonWindUI.Theme.TextInactive
                        }
                    )
                end
            end

            Page.Visible = true

            FastTween(
                TabButton,
                0.15,
                {
                    TextColor3 =
                        HaroonWindUI.Theme.TextActive
                }
            )

            Indicator.Visible = true

            local y =
                TabButton.AbsolutePosition.Y
                - TabsHolder.AbsolutePosition.Y
                + 3

            FastTween(
                Indicator,
                0.2,
                {
                    Position =
                        UDim2.new(
                            0,
                            0,
                            0,
                            y
                        )
                }
            )

            WindowObj.ActiveTab =
                TabObj
        end

        TabButton.MouseButton1Click:Connect(
            ActivateTab
        )

        table.insert(
            WindowObj.Tabs,
            TabObj
        )

        if #WindowObj.Tabs == 1 then

            task.defer(function()

                if TabButton.Parent then
                    ActivateTab()
                end

            end)
        end

        --==========================================
        -- SECTION
        --==========================================

        function TabObj:CreateSection(
            sectionTitle
        )

            local frame =
                Instance.new("Frame")

            frame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    24
                )

            frame.BackgroundTransparency = 1

            frame.Parent =
                Page

            local label =
                Instance.new("TextLabel")

            label.Size =
                UDim2.new(1, 0, 1, 0)

            label.Text =
                string.upper(
                    tostring(
                        sectionTitle or "SECTION"
                    )
                )

            label.Font =
                Enum.Font.GothamBold

            label.TextColor3 =
                HaroonWindUI.Theme.AccentRed

            label.TextSize = 10

            label.TextXAlignment =
                Enum.TextXAlignment.Left

            label.BackgroundTransparency = 1

            label.Parent =
                frame

            return frame
        end

        --==========================================
        -- PARAGRAPH
        --==========================================

        function TabObj:CreateParagraph(
            pTitle,
            pContent
        )

            local frame =
                Instance.new("Frame")

            frame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    62
                )

            frame.BackgroundColor3 =
                HaroonWindUI.Theme.Card

            frame.BorderSizePixel = 0

            frame.Parent =
                Page

            local corner =
                Instance.new("UICorner")

            corner.CornerRadius =
                UDim.new(0, 6)

            corner.Parent =
                frame

            local title =
                Instance.new("TextLabel")

            title.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    20
                )

            title.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    6
                )

            title.Text =
                tostring(
                    pTitle or "Information"
                )

            title.Font =
                Enum.Font.GothamBold

            title.TextColor3 =
                HaroonWindUI.Theme.TextActive

            title.TextSize = 12

            title.TextXAlignment =
                Enum.TextXAlignment.Left

            title.BackgroundTransparency = 1

            title.Parent =
                frame

            local body =
                Instance.new("TextLabel")

            body.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    30
                )

            body.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    27
                )

            body.Text =
                tostring(
                    pContent or ""
                )

            body.Font =
                Enum.Font.Gotham

            body.TextColor3 =
                HaroonWindUI.Theme.SubText

            body.TextSize = 10

            body.TextWrapped = true

            body.TextXAlignment =
                Enum.TextXAlignment.Left

            body.TextYAlignment =
                Enum.TextYAlignment.Top

            body.BackgroundTransparency = 1

            body.Parent =
                frame

            return frame
        end

        --==========================================
        -- BUTTON
        --==========================================

        function TabObj:CreateButton(
            btnText,
            iconAssetId,
            callback
        )

            if type(iconAssetId) == "function" then

                callback =
                    iconAssetId

                iconAssetId = nil
            end

            callback =
                type(callback) == "function"
                and callback
                or function() end

            iconAssetId =
                iconAssetId
                or ICONS.ButtonDefault

            local button =
                Instance.new("TextButton")

            button.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    34
                )

            button.BackgroundColor3 =
                HaroonWindUI.Theme.Card

            button.Text =
                tostring(btnText or "Button")

            button.TextColor3 =
                HaroonWindUI.Theme.TextActive

            button.Font =
                Enum.Font.GothamMedium

            button.TextSize = 12

            button.TextXAlignment =
                Enum.TextXAlignment.Left

            button.AutoButtonColor = false

            button.BorderSizePixel = 0

            button.Parent =
                Page

            local padding =
                Instance.new("UIPadding")

            padding.PaddingLeft =
                UDim.new(0, 12)

            padding.PaddingRight =
                UDim.new(0, 35)

            padding.Parent =
                button

            local corner =
                Instance.new("UICorner")

            corner.CornerRadius =
                UDim.new(0, 6)

            corner.Parent =
                button

            local stroke =
                Instance.new("UIStroke")

            stroke.Color =
                HaroonWindUI.Theme.Border

            stroke.Thickness = 1

            stroke.Parent =
                button

            local icon =
                Instance.new("ImageLabel")

            icon.Size =
                UDim2.fromOffset(
                    16,
                    16
                )

            icon.Position =
                UDim2.new(
                    1,
                    -26,
                    0.5,
                    -8
                )

            icon.Image =
                iconAssetId

            icon.ImageColor3 =
                HaroonWindUI.Theme.AccentRed

            icon.BackgroundTransparency = 1

            icon.Parent =
                button

            button.MouseEnter:Connect(
                function()

                    FastTween(
                        button,
                        0.15,
                        {
                            BackgroundColor3 =
                                HaroonWindUI.Theme.CardHover
                        }
                    )
                end
            )

            button.MouseLeave:Connect(
                function()

                    FastTween(
                        button,
                        0.15,
                        {
                            BackgroundColor3 =
                                HaroonWindUI.Theme.Card
                        }
                    )
                end
            )

            button.MouseButton1Click:Connect(
                function()

                    FastTween(
                        button,
                        0.06,
                        {
                            Size =
                                UDim2.new(
                                    1,
                                    -4,
                                    0,
                                    32
                                )
                        }
                    )

                    task.delay(
                        0.06,
                        function()

                            if button.Parent then

                                FastTween(
                                    button,
                                    0.06,
                                    {
                                        Size =
                                            UDim2.new(
                                                1,
                                                0,
                                                0,
                                                34
                                            )
                                    }
                                )
                            end
                        end
                    )

                    task.spawn(function()
                        pcall(callback)
                    end)

                end
            )

            return button
        end

        --==========================================
        -- TOGGLE
        --==========================================

        function TabObj:CreateToggle(
            toggleText,
            default,
            callback
        )

            local state =
                default == true

            callback =
                type(callback) == "function"
                and callback
                or function() end

            local frame =
                Instance.new("Frame")

            frame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    34
                )

            frame.BackgroundColor3 =
                HaroonWindUI.Theme.Card

            frame.BorderSizePixel = 0

            frame.Parent =
                Page

            local corner =
                Instance.new("UICorner")

            corner.CornerRadius =
                UDim.new(0, 6)

            corner.Parent =
                frame

            local label =
                Instance.new("TextLabel")

            label.Size =
                UDim2.new(
                    1,
                    -60,
                    1,
                    0
                )

            label.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    0
                )

            label.Text =
                tostring(
                    toggleText or "Toggle"
                )

            label.Font =
                Enum.Font.GothamMedium

            label.TextColor3 =
                HaroonWindUI.Theme.TextActive

            label.TextSize = 12

            label.TextXAlignment =
                Enum.TextXAlignment.Left

            label.BackgroundTransparency = 1

            label.Parent =
                frame

            local switch =
                Instance.new("Frame")

            switch.Size =
                UDim2.fromOffset(
                    36,
                    18
                )

            switch.Position =
                UDim2.new(
                    1,
                    -44,
                    0.5,
                    -9
                )

            switch.BackgroundColor3 =
                state
                and HaroonWindUI.Theme.AccentRed
                or HaroonWindUI.Theme.ToggleOff

            switch.BorderSizePixel = 0

            switch.Parent =
                frame

            local switchCorner =
                Instance.new("UICorner")

            switchCorner.CornerRadius =
                UDim.new(1, 0)

            switchCorner.Parent =
                switch

            local knob =
                Instance.new("Frame")

            knob.Size =
                UDim2.fromOffset(
                    14,
                    14
                )

            knob.Position =
                state
                and UDim2.new(
                    1,
                    -16,
                    0.5,
                    -7
                )
                or UDim2.new(
                    0,
                    2,
                    0.5,
                    -7
                )

            knob.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            knob.BorderSizePixel = 0

            knob.Parent =
                switch

            local knobCorner =
                Instance.new("UICorner")

            knobCorner.CornerRadius =
                UDim.new(1, 0)

            knobCorner.Parent =
                knob

            local clicker =
                Instance.new("TextButton")

            clicker.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )

            clicker.BackgroundTransparency = 1

            clicker.Text = ""

            clicker.Parent =
                frame

            local function SetState(
                newState,
                fireCallback
            )

                state =
                    newState == true

                FastTween(
                    switch,
                    0.18,
                    {
                        BackgroundColor3 =
                            state
                            and HaroonWindUI.Theme.AccentRed
                            or HaroonWindUI.Theme.ToggleOff
                    }
                )

                FastTween(
                    knob,
                    0.18,
                    {
                        Position =
                            state
                            and UDim2.new(
                                1,
                                -16,
                                0.5,
                                -7
                            )
                            or UDim2.new(
                                0,
                                2,
                                0.5,
                                -7
                            )
                    }
                )

                if fireCallback then
                    pcall(
                        callback,
                        state
                    )
                end
            end

            clicker.MouseButton1Click:Connect(
                function()

                    SetState(
                        not state,
                        true
                    )
                end
            )

            local toggleObject = {}

            function toggleObject:Set(
                value
            )

                SetState(
                    value,
                    true
                )
            end

            function toggleObject:Get()
                return state
            end

            toggleObject.Frame = frame

            return toggleObject
        end

        --==========================================
        -- SLIDER
        --==========================================

        function TabObj:CreateSlider(
            sliderText,
            min,
            max,
            default,
            callback
        )

            min =
                tonumber(min)
                or 0

            max =
                tonumber(max)
                or 100

            if max < min then
                min, max =
                    max, min
            end

            if max == min then
                max = min + 1
            end

            default =
                tonumber(default)
                or min

            default =
                math.clamp(
                    default,
                    min,
                    max
                )

            callback =
                type(callback) == "function"
                and callback
                or function() end

            local frame =
                Instance.new("Frame")

            frame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    46
                )

            frame.BackgroundColor3 =
                HaroonWindUI.Theme.Card

            frame.BorderSizePixel = 0

            frame.Parent =
                Page

            local corner =
                Instance.new("UICorner")

            corner.CornerRadius =
                UDim.new(0, 6)

            corner.Parent =
                frame

            local label =
                Instance.new("TextLabel")

            label.Size =
                UDim2.new(
                    0.65,
                    0,
                    0,
                    18
                )

            label.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    4
                )

            label.Text =
                tostring(
                    sliderText or "Slider"
                )

            label.Font =
                Enum.Font.GothamMedium

            label.TextColor3 =
                HaroonWindUI.Theme.TextActive

            label.TextSize = 12

            label.TextXAlignment =
                Enum.TextXAlignment.Left

            label.BackgroundTransparency = 1

            label.Parent =
                frame

            local valueLabel =
                Instance.new("TextLabel")

            valueLabel.Size =
                UDim2.new(
                    0.3,
                    0,
                    0,
                    18
                )

            valueLabel.Position =
                UDim2.new(
                    0.7,
                    -10,
                    0,
                    4
                )

            valueLabel.Text =
                tostring(
                    math.floor(
                        default + 0.5
                    )
                )

            valueLabel.Font =
                Enum.Font.GothamBold

            valueLabel.TextColor3 =
                HaroonWindUI.Theme.SubText

            valueLabel.TextSize = 11

            valueLabel.TextXAlignment =
                Enum.TextXAlignment.Right

            valueLabel.BackgroundTransparency = 1

            valueLabel.Parent =
                frame

            local bar =
                Instance.new("Frame")

            bar.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    5
                )

            bar.Position =
                UDim2.new(
                    0,
                    10,
                    1,
                    -13
                )

            bar.BackgroundColor3 =
                HaroonWindUI.Theme.ToggleOff

            bar.BorderSizePixel = 0

            bar.Parent =
                frame

            local barCorner =
                Instance.new("UICorner")

            barCorner.CornerRadius =
                UDim.new(1, 0)

            barCorner.Parent =
                bar

            local percent =
                (default - min)
                / (max - min)

            local fill =
                Instance.new("Frame")

            fill.Size =
                UDim2.new(
                    percent,
                    0,
                    1,
                    0
                )

            fill.BackgroundColor3 =
                HaroonWindUI.Theme.AccentRed

            fill.BorderSizePixel = 0

            fill.Parent =
                bar

            local fillCorner =
                Instance.new("UICorner")

            fillCorner.CornerRadius =
                UDim.new(1, 0)

            fillCorner.Parent =
                fill

            local dragging = false

            local function UpdateSlider(
                input
            )

                if bar.AbsoluteSize.X <= 0 then
                    return
                end

                local position =
                    (
                        input.Position.X
                        - bar.AbsolutePosition.X
                    )
                    / bar.AbsoluteSize.X

                position =
                    math.clamp(
                        position,
                        0,
                        1
                    )

                local value =
                    math.floor(
                        min
                        + (
                            max - min
                        )
                        * position
                        + 0.5
                    )

                valueLabel.Text =
                    tostring(value)

                fill.Size =
                    UDim2.new(
                        position,
                        0,
                        1,
                        0
                    )

                pcall(
                    callback,
                    value
                )
            end

            bar.InputBegan:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        dragging = true

                        UpdateSlider(
                            input
                        )
                    end
                end
            )

            UserInputService.InputEnded:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        dragging = false
                    end
                end
            )

            UserInputService.InputChanged:Connect(
                function(input)

                    if not dragging then
                        return
                    end

                    if input.UserInputType ==
                        Enum.UserInputType.MouseMovement
                    or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        UpdateSlider(
                            input
                        )
                    end
                end
            )

            local sliderObject = {}

            function sliderObject:Set(
                value
            )

                value =
                    math.clamp(
                        tonumber(value)
                        or min,
                        min,
                        max
                    )

                local position =
                    (
                        value - min
                    )
                    / (
                        max - min
                    )

                valueLabel.Text =
                    tostring(
                        math.floor(
                            value + 0.5
                        )
                    )

                fill.Size =
                    UDim2.new(
                        position,
                        0,
                        1,
                        0
                    )

                pcall(
                    callback,
                    value
                )
            end

            function sliderObject:Get()

                return tonumber(
                    valueLabel.Text
                )
            end

            sliderObject.Frame =
                frame

            return sliderObject
        end

        --==========================================
        -- DROPDOWN / MULTISELECT
        --==========================================

        function TabObj:CreateDropdown(
            dropText,
            options,
            default,
            multiSelect,
            callback
        )

            options =
                type(options) == "table"
                and options
                or {}

            multiSelect =
                multiSelect == true

            callback =
                type(callback) == "function"
                and callback
                or function() end

            local selectedStates = {}

            local singleSelected = nil

            if multiSelect then

                for _, option in ipairs(
                    options
                ) do

                    selectedStates[
                        tostring(option)
                    ] = false
                end

                if type(default) == "table" then

                    for _, value in ipairs(
                        default
                    ) do

                        value =
                            tostring(value)

                        if selectedStates[value] ~= nil then

                            selectedStates[value] =
                                true
                        end
                    end
                end

            else

                singleSelected =
                    tostring(
                        default
                        or options[1]
                        or "Select..."
                    )

                local exists = false

                for _, option in ipairs(
                    options
                ) do

                    if tostring(option) ==
                        singleSelected then

                        exists = true
                        break
                    end
                end

                if not exists then

                    singleSelected =
                        tostring(
                            options[1]
                            or "Select..."
                        )
                end
            end

            local expanded = false

            local optionHeight = 26

            local collapsedHeight = 38

            local expandedHeight =
                collapsedHeight
                + (
                    #options
                    * optionHeight
                )

            local frame =
                Instance.new("Frame")

            frame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    collapsedHeight
                )

            frame.BackgroundColor3 =
                HaroonWindUI.Theme.Card

            frame.BorderSizePixel = 0

            frame.ClipsDescendants = true

            frame.Parent =
                Page

            local corner =
                Instance.new("UICorner")

            corner.CornerRadius =
                UDim.new(0, 6)

            corner.Parent =
                frame

            -- Header
            local header =
                Instance.new("TextButton")

            header.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    collapsedHeight
                )

            header.Position =
                UDim2.new(0, 0, 0, 0)

            header.BackgroundTransparency = 1

            header.Text = ""

            header.AutoButtonColor = false

            header.ZIndex = 3

            header.Parent =
                frame

            local label =
                Instance.new("TextLabel")

            label.Size =
                UDim2.new(
                    0.5,
                    0,
                    1,
                    0
                )

            label.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    0
                )

            label.Text =
                tostring(
                    dropText or "Dropdown"
                )

            label.Font =
                Enum.Font.GothamMedium

            label.TextColor3 =
                HaroonWindUI.Theme.TextActive

            label.TextSize = 12

            label.TextXAlignment =
                Enum.TextXAlignment.Left

            label.BackgroundTransparency = 1

            label.ZIndex = 4

            label.Parent =
                header

            local selectedLabel =
                Instance.new("TextLabel")

            selectedLabel.Size =
                UDim2.new(
                    0.45,
                    -20,
                    1,
                    0
                )

            selectedLabel.Position =
                UDim2.new(
                    0.55,
                    0,
                    0,
                    0
                )

            selectedLabel.Font =
                Enum.Font.Gotham

            selectedLabel.TextColor3 =
                HaroonWindUI.Theme.AccentRed

            selectedLabel.TextSize = 10

            selectedLabel.TextXAlignment =
                Enum.TextXAlignment.Right

            selectedLabel.TextTruncate =
                Enum.TextTruncate.AtEnd

            selectedLabel.BackgroundTransparency = 1

            selectedLabel.ZIndex = 4

            selectedLabel.Parent =
                header

            local arrow =
                Instance.new("TextLabel")

            arrow.Size =
                UDim2.fromOffset(
                    18,
                    18
                )

            arrow.Position =
                UDim2.new(
                    1,
                    -23,
                    0.5,
                    -9
                )

            arrow.Text = "▼"

            arrow.Font =
                Enum.Font.GothamBold

            arrow.TextSize = 9

            arrow.TextColor3 =
                HaroonWindUI.Theme.AccentRed

            arrow.BackgroundTransparency = 1

            arrow.ZIndex = 5

            arrow.Parent =
                header

            -- Options
            local optionsContainer =
                Instance.new("Frame")

            optionsContainer.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    #options * optionHeight
                )

            optionsContainer.Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    collapsedHeight
                )

            optionsContainer.BackgroundTransparency = 1

            optionsContainer.ZIndex = 2

            optionsContainer.Parent =
                frame

            local optionLayout =
                Instance.new("UIListLayout")

            optionLayout.SortOrder =
                Enum.SortOrder.LayoutOrder

            optionLayout.Padding =
                UDim.new(0, 2)

            optionLayout.Parent =
                optionsContainer

            local function GetSelectedText()

                if not multiSelect then
                    return singleSelected
                end

                local selected = {}

                for _, option in ipairs(
                    options
                ) do

                    local key =
                        tostring(option)

                    if selectedStates[key] then

                        table.insert(
                            selected,
                            key
                        )
                    end
                end

                if #selected == 0 then
                    return "Select items..."
                end

                return table.concat(
                    selected,
                    ", "
                )
            end

            local function UpdateHeader()

                selectedLabel.Text =
                    GetSelectedText()

                arrow.Text =
                    expanded
                    and "▲"
                    or "▼"
            end

            local function SetExpanded(
                value
            )

                expanded =
                    value == true

                local targetHeight =
                    expanded
                    and expandedHeight
                    or collapsedHeight

                FastTween(
                    frame,
                    0.22,
                    {
                        Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                targetHeight
                            )
                    }
                )

                UpdateHeader()
            end

            for index, option in ipairs(
                options
            ) do

                local optionText =
                    tostring(option)

                local button =
                    Instance.new("TextButton")

                button.Name =
                    "Option_" .. index

                button.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        optionHeight
                    )

                button.BackgroundColor3 =
                    (
                        multiSelect
                        and selectedStates[
                            optionText
                        ]
                    )
                    and HaroonWindUI.Theme.MultiSelectSelected
                    or HaroonWindUI.Theme.Sidebar

                button.Text =
                    "  " .. optionText

                button.Font =
                    Enum.Font.Gotham

                button.TextSize = 11

                button.TextXAlignment =
                    Enum.TextXAlignment.Left

                button.TextColor3 =
                    (
                        multiSelect
                        and selectedStates[
                            optionText
                        ]
                    )
                    and HaroonWindUI.Theme.TextActive
                    or HaroonWindUI.Theme.SubText

                button.AutoButtonColor = false

                button.BorderSizePixel = 0

                button.ZIndex = 3

                button.Parent =
                    optionsContainer

                local optionCorner =
                    Instance.new("UICorner")

                optionCorner.CornerRadius =
                    UDim.new(0, 4)

                optionCorner.Parent =
                    button

                local checkmark

                if multiSelect then

                    checkmark =
                        Instance.new("ImageLabel")

                    checkmark.Size =
                        UDim2.fromOffset(
                            14,
                            14
                        )

                    checkmark.Position =
                        UDim2.new(
                            1,
                            -20,
                            0.5,
                            -7
                        )

                    checkmark.Image =
                        ICONS.Checkmark

                    checkmark.ImageColor3 =
                        HaroonWindUI.Theme.AccentRed

                    checkmark.BackgroundTransparency = 1

                    checkmark.Visible =
                        selectedStates[
                            optionText
                        ]

                    checkmark.ZIndex = 4

                    checkmark.Parent =
                        button
                end

                button.MouseButton1Click:Connect(
                    function()

                        if multiSelect then

                            selectedStates[
                                optionText
                            ] =
                                not selectedStates[
                                    optionText
                                ]

                            local enabled =
                                selectedStates[
                                    optionText
                                ]

                            FastTween(
                                button,
                                0.12,
                                {
                                    BackgroundColor3 =
                                        enabled
                                        and HaroonWindUI.Theme.MultiSelectSelected
                                        or HaroonWindUI.Theme.Sidebar,

                                    TextColor3 =
                                        enabled
                                        and HaroonWindUI.Theme.TextActive
                                        or HaroonWindUI.Theme.SubText
                                }
                            )

                            if checkmark then

                                checkmark.Visible =
                                    enabled
                            end

                            UpdateHeader()

                            pcall(
                                callback,
                                selectedStates
                            )

                        else

                            singleSelected =
                                optionText

                            UpdateHeader()

                            SetExpanded(false)

                            pcall(
                                callback,
                                optionText
                            )
                        end
                    end
                )
            end

            header.MouseButton1Click:Connect(
                function()

                    SetExpanded(
                        not expanded
                    )
                end
            )

            UpdateHeader()

            local dropdownObject = {}

            function dropdownObject:Set(
                value
            )

                if multiSelect then

                    if type(value) ~= "table" then
                        return
                    end

                    for key in pairs(
                        selectedStates
                    ) do

                        selectedStates[key] =
                            false
                    end

                    for _, selected in ipairs(
                        value
                    ) do

                        selected =
                            tostring(selected)

                        if selectedStates[selected]
                            ~= nil then

                            selectedStates[
                                selected
                            ] = true
                        end
                    end

                    for index, option in ipairs(
                        options
                    ) do

                        local key =
                            tostring(option)

                        local button =
                            optionsContainer:
                            FindFirstChild(
                                "Option_" .. index
                            )

                        if button then

                            local enabled =
                                selectedStates[
                                    key
                                ]

                            button.BackgroundColor3 =
                                enabled
                                and HaroonWindUI.Theme.MultiSelectSelected
                                or HaroonWindUI.Theme.Sidebar

                            button.TextColor3 =
                                enabled
                                and HaroonWindUI.Theme.TextActive
                                or HaroonWindUI.Theme.SubText

                            local check =
                                button:FindFirstChild(
                                    "ImageLabel"
                                )

                            if check then
                                check.Visible =
                                    enabled
                            end
                        end
                    end

                else

                    value =
                        tostring(value)

                    for _, option in ipairs(
                        options
                    ) do

                        if tostring(option) ==
                            value then

                            singleSelected =
                                value

                            break
                        end
                    end
                end

                UpdateHeader()

                pcall(
                    callback,
                    multiSelect
                    and selectedStates
                    or singleSelected
                )
            end

            function dropdownObject:Get()

                if multiSelect then

                    local result = {}

                    for key, value in pairs(
                        selectedStates
                    ) do

                        result[key] = value
                    end

                    return result
                end

                return singleSelected
            end

            dropdownObject.Frame =
                frame

            return dropdownObject
        end

        return TabObj
    end

    return WindowObj
end

--==================================================
-- KEY SYSTEM
--==================================================

local function CreateKeySystem(
    onKeyValidated
)

    local completed = false

    local KeyScreenGui =
        Instance.new("ScreenGui")

    KeyScreenGui.Name =
        "HaroonKeySystemGui"

    KeyScreenGui.ResetOnSpawn = false

    KeyScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    KeyScreenGui.Parent =
        GetUIParent()

    local background =
        Instance.new("Frame")

    background.Size =
        UDim2.new(1, 0, 1, 0)

    background.BackgroundColor3 =
        Color3.fromRGB(0, 0, 0)

    background.BackgroundTransparency =
        0.7

    background.BorderSizePixel = 0

    background.Parent =
        KeyScreenGui

    local keyFrame =
        Instance.new("Frame")

    keyFrame.Size =
        UDim2.fromOffset(
            320,
            210
        )

    keyFrame.Position =
        UDim2.new(
            0.5,
            -160,
            0.5,
            -105
        )

    keyFrame.BackgroundColor3 =
        HaroonWindUI.Theme.KeySystemBg

    keyFrame.BorderSizePixel = 0

    keyFrame.Parent =
        background

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 10)

    corner.Parent =
        keyFrame

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        HaroonWindUI.Theme.Border

    stroke.Parent =
        keyFrame

    local title =
        Instance.new("TextLabel")

    title.Size =
        UDim2.new(
            1,
            -20,
            0,
            22
        )

    title.Position =
        UDim2.new(
            0,
            10,
            0,
            13
        )

    title.Text =
        "Welcome, loading"

    title.Font =
        Enum.Font.GothamBold

    title.TextColor3 =
        HaroonWindUI.Theme.TextActive

    title.TextSize = 14

    title.BackgroundTransparency = 1

    title.Parent =
        keyFrame

    local subtitle =
        Instance.new("TextLabel")

    subtitle.Size =
        UDim2.new(
            1,
            -20,
            0,
            20
        )

    subtitle.Position =
        UDim2.new(
            0,
            10,
            0,
            35
        )

    subtitle.Text =
        "Enter key to continue"

    subtitle.Font =
        Enum.Font.Gotham

    subtitle.TextColor3 =
        HaroonWindUI.Theme.SubText

    subtitle.TextSize = 11

    subtitle.BackgroundTransparency = 1

    subtitle.Parent =
        keyFrame

    local keyBox =
        Instance.new("TextBox")

    keyBox.Size =
        UDim2.new(
            1,
            -20,
            0,
            32
        )

    keyBox.Position =
        UDim2.new(
            0,
            10,
            0,
            66
        )

    keyBox.PlaceholderText =
        "Enter your key..."

    keyBox.Text = ""

    keyBox.ClearTextOnFocus = false

    keyBox.Font =
        Enum.Font.Gotham

    keyBox.TextColor3 =
        HaroonWindUI.Theme.TextActive

    keyBox.PlaceholderColor3 =
        HaroonWindUI.Theme.TextInactive

    keyBox.TextSize = 12

    keyBox.BackgroundColor3 =
        HaroonWindUI.Theme.Card

    keyBox.BorderSizePixel = 0

    keyBox.TextXAlignment =
        Enum.TextXAlignment.Left

    keyBox.Parent =
        keyFrame

    local boxCorner =
        Instance.new("UICorner")

    boxCorner.CornerRadius =
        UDim.new(0, 6)

    boxCorner.Parent =
        keyBox

    local paste =
        Instance.new("TextButton")

    paste.Size =
        UDim2.new(
            1,
            -20,
            0,
            27
        )

    paste.Position =
        UDim2.new(
            0,
            10,
            0,
            104
        )

    paste.Text =
        "Paste Key"

    paste.Font =
        Enum.Font.GothamBold

    paste.TextColor3 =
        HaroonWindUI.Theme.TextActive

    paste.TextSize = 11

    paste.BackgroundColor3 =
        HaroonWindUI.Theme.CardHover

    paste.BorderSizePixel = 0

    paste.Parent =
        keyFrame

    local pasteCorner =
        Instance.new("UICorner")

    pasteCorner.CornerRadius =
        UDim.new(0, 6)

    pasteCorner.Parent =
        paste

    paste.MouseButton1Click:Connect(
        function()

            local success, clipboardText =
                pcall(function()

                    if type(getclipboard) ==
                        "function" then

                        return getclipboard()
                    end

                    if type(
                        UserInputService.GetClipboard
                    ) == "function" then

                        return UserInputService:
                            GetClipboard()
                    end

                    return nil
                end)

            if success
            and type(clipboardText) == "string"
            and clipboardText ~= "" then

                keyBox.Text =
                    clipboardText

            else

                HaroonWindUI:Notify({
                    Title = "Clipboard",
                    Content = "تعذر قراءة الـ Clipboard.",
                    Duration = 3
                })
            end
        end
    )

    local getKey =
        Instance.new("TextButton")

    getKey.Size =
        UDim2.new(
            1,
            -20,
            0,
            18
        )

    getKey.Position =
        UDim2.new(
            0,
            10,
            0,
            136
        )

    getKey.Text =
        "Don't have a key? Click here to get one."

    getKey.Font =
        Enum.Font.Gotham

    getKey.TextColor3 =
        HaroonWindUI.Theme.SubText

    getKey.TextSize = 9

    getKey.BackgroundTransparency = 1

    getKey.AutoButtonColor = false

    getKey.Parent =
        keyFrame

    getKey.MouseButton1Click:Connect(
        function()

            HaroonWindUI:Notify({
                Title = "Get Key",
                Content = "Please use your official key source.",
                Duration = 4
            })
        end
    )

    local confirm =
        Instance.new("TextButton")

    confirm.Size =
        UDim2.new(
            1,
            -20,
            0,
            32
        )

    confirm.Position =
        UDim2.new(
            0,
            10,
            0,
            165
        )

    confirm.Text =
        "Confirm"

    confirm.Font =
        Enum.Font.GothamBold

    confirm.TextColor3 =
        HaroonWindUI.Theme.TextActive

    confirm.TextSize = 13

    confirm.BackgroundColor3 =
        HaroonWindUI.Theme.KeySystemAccent

    confirm.BorderSizePixel = 0

    confirm.Parent =
        keyFrame

    local confirmCorner =
        Instance.new("UICorner")

    confirmCorner.CornerRadius =
        UDim.new(0, 6)

    confirmCorner.Parent =
        confirm

    local function Complete()

        if completed then
            return
        end

        completed = true

        HaroonWindUI:Notify({
            Title = "Key Validated",
            Content = "Key accepted! Loading UI...",
            Duration = 3
        })

        FastTween(
            keyFrame,
            0.3,
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.new(
                        0.5,
                        -160,
                        0.5,
                        -300
                    )
            },
            Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        )

        FastTween(
            background,
            0.3,
            {
                BackgroundTransparency = 1
            }
        )

        task.delay(
            0.3,
            function()

                SafeDestroy(
                    KeyScreenGui
                )

                pcall(
                    onKeyValidated
                )
            end
        )
    end

    confirm.MouseButton1Click:Connect(
        function()

            if completed then
                return
            end

            if keyBox.Text ==
                REQUIRED_KEY then

                Complete()

            else

                HaroonWindUI:Notify({
                    Title = "Key Error",
                    Content = "Invalid key. Please try again.",
                    Duration = 3
                })
            end
        end
    )

    keyFrame.Position =
        UDim2.new(
            0.5,
            -160,
            0.5,
            -300
        )

    FastTween(
        keyFrame,
        0.5,
        {
            Position =
                UDim2.new(
                    0.5,
                    -160,
                    0.5,
                    -105
                )
        },
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out
    )
end

--==================================================
-- LOADING SCREEN
--==================================================

local function CreateLoadingScreen(
    onLoadingComplete
)

    local finished = false

    local LoadingScreenGui =
        Instance.new("ScreenGui")

    LoadingScreenGui.Name =
        "HaroonLoadingScreenGui"

    LoadingScreenGui.ResetOnSpawn = false

    LoadingScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    LoadingScreenGui.Parent =
        GetUIParent()

    local background =
        Instance.new("Frame")

    background.Size =
        UDim2.new(1, 0, 1, 0)

    background.BackgroundColor3 =
        Color3.fromRGB(0, 0, 0)

    background.BackgroundTransparency =
        0.7

    background.BorderSizePixel = 0

    background.Parent =
        LoadingScreenGui

    local loadingFrame =
        Instance.new("Frame")

    loadingFrame.Size =
        UDim2.fromOffset(
            350,
            200
        )

    loadingFrame.Position =
        UDim2.new(
            0.5,
            -175,
            0.5,
            -300
        )

    loadingFrame.BackgroundColor3 =
        HaroonWindUI.Theme.LoadingBg

    loadingFrame.BorderSizePixel = 0

    loadingFrame.Parent =
        background

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 10)

    corner.Parent =
        loadingFrame

    local title =
        Instance.new("TextLabel")

    title.Size =
        UDim2.new(1, 0, 0, 20)

    title.Position =
        UDim2.new(0, 0, 0, 15)

    title.Text =
        "HAROON STUDIO"

    title.Font =
        Enum.Font.GothamBold

    title.TextColor3 =
        HaroonWindUI.Theme.TextActive

    title.TextSize = 16

    title.BackgroundTransparency = 1

    title.Parent =
        loadingFrame

    local spinner =
        Instance.new("ImageLabel")

    spinner.Size =
        UDim2.fromOffset(
            55,
            55
        )

    spinner.Position =
        UDim2.new(
            0.5,
            -27.5,
            0,
            45
        )

    spinner.Image =
        ICONS.LoadingSpinner

    spinner.ImageColor3 =
        HaroonWindUI.Theme.AccentRed

    spinner.BackgroundTransparency = 1

    spinner.Parent =
        loadingFrame

    task.spawn(function()

        while spinner.Parent
        and not finished do

            FastTween(
                spinner,
                0.8,
                {
                    Rotation =
                        spinner.Rotation
                        + 360
                },
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )

            task.wait(0.8)
        end
    end)

    local progressBar =
        Instance.new("Frame")

    progressBar.Size =
        UDim2.new(
            1,
            -40,
            0,
            8
        )

    progressBar.Position =
        UDim2.new(
            0,
            20,
            0,
            120
        )

    progressBar.BackgroundColor3 =
        HaroonWindUI.Theme.Card

    progressBar.BorderSizePixel = 0

    progressBar.Parent =
        loadingFrame

    local progressCorner =
        Instance.new("UICorner")

    progressCorner.CornerRadius =
        UDim.new(1, 0)

    progressCorner.Parent =
        progressBar

    local fill =
        Instance.new("Frame")

    fill.Size =
        UDim2.new(
            0,
            0,
            1,
            0
        )

    fill.BackgroundColor3 =
        HaroonWindUI.Theme.AccentRed

    fill.BorderSizePixel = 0

    fill.Parent =
        progressBar

    local fillCorner =
        Instance.new("UICorner")

    fillCorner.CornerRadius =
        UDim.new(1, 0)

    fillCorner.Parent =
        fill

    local progressText =
        Instance.new("TextLabel")

    progressText.Size =
        UDim2.new(1, 0, 0, 15)

    progressText.Position =
        UDim2.new(0, 0, 0, 132)

    progressText.Text =
        "0%"

    progressText.Font =
        Enum.Font.GothamBold

    progressText.TextColor3 =
        HaroonWindUI.Theme.TextActive

    progressText.TextSize = 10

    progressText.BackgroundTransparency = 1

    progressText.Parent =
        loadingFrame

    local tips =
        Instance.new("TextLabel")

    tips.Size =
        UDim2.new(1, -20, 0, 15)

    tips.Position =
        UDim2.new(0, 10, 0, 150)

    tips.Text =
        "Loading..."

    tips.Font =
        Enum.Font.Gotham

    tips.TextColor3 =
        HaroonWindUI.Theme.SubText

    tips.TextSize = 9

    tips.TextTruncate =
        Enum.TextTruncate.AtEnd

    tips.BackgroundTransparency = 1

    tips.Parent =
        loadingFrame

    local skip =
        Instance.new("TextButton")

    skip.Size =
        UDim2.fromOffset(
            100,
            25
        )

    skip.Position =
        UDim2.new(
            0.5,
            -50,
            0,
            170
        )

    skip.Text =
        "Skip Loading"

    skip.Font =
        Enum.Font.GothamBold

    skip.TextColor3 =
        HaroonWindUI.Theme.TextActive

    skip.TextSize = 11

    skip.BackgroundColor3 =
        HaroonWindUI.Theme.CardHover

    skip.BorderSizePixel = 0

    skip.Parent =
        loadingFrame

    local skipCorner =
        Instance.new("UICorner")

    skipCorner.CornerRadius =
        UDim.new(0, 6)

    skipCorner.Parent =
        skip

    local loadingTips = {

        "Optimizing scripts...",

        "Initializing UI components...",

        "Fetching configurations...",

        "Preparing experience...",

        "Almost there...",

        "Ensuring performance...",

        "Loading assets..."
    }

    local function UpdateProgress(
        value
    )

        value =
            math.clamp(
                tonumber(value)
                or 0,
                0,
                100
            )

        FastTween(
            fill,
            0.15,
            {
                Size =
                    UDim2.new(
                        value / 100,
                        0,
                        1,
                        0
                    )
            }
        )

        progressText.Text =
            tostring(
                math.floor(value)
            ) .. "%"

        local tipIndex =
            math.clamp(
                math.floor(
                    value / 15
                ) + 1,
                1,
                #loadingTips
            )

        tips.Text =
            loadingTips[tipIndex]
    end

    local function FinishLoading()

        if finished then
            return
        end

        finished = true

        UpdateProgress(100)

        FastTween(
            loadingFrame,
            0.3,
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.new(
                        0.5,
                        -175,
                        0.5,
                        -300
                    )
            },
            Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        )

        FastTween(
            background,
            0.3,
            {
                BackgroundTransparency = 1
            }
        )

        task.delay(
            0.3,
            function()

                SafeDestroy(
                    LoadingScreenGui
                )

                pcall(
                    onLoadingComplete
                )
            end
        )
    end

    skip.MouseButton1Click:Connect(
        FinishLoading
    )

    task.spawn(function()

        for i = 0, 100, 5 do

            if finished
            or not LoadingScreenGui.Parent then
                return
            end

            UpdateProgress(i)

            task.wait(0.12)
        end

        if not finished then

            task.wait(0.25)

            FinishLoading()
        end
    end)

    FastTween(
        loadingFrame,
        0.5,
        {
            Position =
                UDim2.new(
                    0.5,
                    -175,
                    0.5,
                    -100
                )
        },
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out
    )
end

--==================================================
-- MOVABLE TOGGLE BUTTON
--==================================================

local function CreateUIToggleButton(
    mainUIFrame
)

    local parentUI =
        GetUIParent()

    local old =
        parentUI:FindFirstChild(
            "HaroonUIToggleButton"
        )

    if old then
        SafeDestroy(old)
    end

    local ToggleScreenGui =
        Instance.new("ScreenGui")

    ToggleScreenGui.Name =
        "HaroonUIToggleButton"

    ToggleScreenGui.ResetOnSpawn = false

    ToggleScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    ToggleScreenGui.Parent =
        parentUI

    local button =
        Instance.new("ImageButton")

    button.Name =
        "ToggleButton"

    button.Size =
        UDim2.fromOffset(
            42,
            42
        )

    button.Position =
        UDim2.new(
            1,
            -55,
            0,
            15
        )

    button.BackgroundColor3 =
        HaroonWindUI.Theme.Background

    button.BackgroundTransparency = 0.1

    button.Image =
        ICONS.ToggleUI

    button.ImageColor3 =
        HaroonWindUI.Theme.AccentRed

    button.BorderSizePixel = 0

    button.Parent =
        ToggleScreenGui

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 10)

    corner.Parent =
        button

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        HaroonWindUI.Theme.AccentRed

    stroke.Thickness = 1

    stroke.Parent =
        button

    local dragging = false

    local dragStart

    local startPosition

    local moved = false

    local dragInput

    button.InputBegan:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
            or input.UserInputType ==
                Enum.UserInputType.Touch then

                dragging = true

                moved = false

                dragStart =
                    input.Position

                startPosition =
                    button.Position

                input.Changed:Connect(
                    function()

                        if input.UserInputState ==
                            Enum.UserInputState.End then

                            dragging = false
                        end
                    end
                )
            end
        end
    )

    button.InputChanged:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
            or input.UserInputType ==
                Enum.UserInputType.Touch then

                dragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not dragging
            or input ~= dragInput then
                return
            end

            local delta =
                input.Position
                - dragStart

            if delta.Magnitude > 8 then
                moved = true
            end

            button.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset
                        + delta.X,

                    startPosition.Y.Scale,
                    startPosition.Y.Offset
                        + delta.Y
                )
        end
    )

    button.MouseButton1Click:Connect(
        function()

            if moved then

                moved = false

                return
            end

            if mainUIFrame
            and mainUIFrame.Parent then

                mainUIFrame.Visible =
                    not mainUIFrame.Visible

            end
        end
    )

    return ToggleScreenGui
end

--==================================================
-- GLOBAL EXPORT
--==================================================

if type(getgenv) == "function" then

    getgenv().HaroonWindUI =
        HaroonWindUI

else

    warn(
        "HaroonWindUI: getgenv() is unavailable."
    )
end

--==================================================
-- AUTO START
--==================================================

task.spawn(function()

    CreateKeySystem(
        function()

            CreateLoadingScreen(
                function()

                    local Window =
                        HaroonWindUI:CreateWindow({

                            Title =
                                "Haroon Studio",

                            SubTitle =
                                "PRO EDITION",

                            Size =
                                UDim2.fromOffset(
                                    500,
                                    340
                                )
                        })

                    Window:Show()

                    CreateUIToggleButton(
                        Window.MainFrame
                    )

                    HaroonWindUI:Notify({

                        Title =
                            "مرحباً بك في HaroonWindUI!",

                        Content =
                            "تم تحميل المكتبة بنجاح.",

                        Duration = 5
                    })

                    --==================================
                    -- MAIN TAB
                    --==================================

                    local MainTab =
                        Window:CreateTab(
                            "Main Hub"
                        )

                    MainTab:CreateSection(
                        "General Options"
                    )

                    MainTab:CreateParagraph(
                        "Welcome Note",
                        "هذه مكتبة HaroonWindUI المطورة. تم إصلاح الأنظمة الأساسية والـ Dropdown والـ Slider والـ Loading."
                    )

                    MainTab:CreateButton(
                        "Teleport To Spawn",
                        function()

                            local character =
                                LocalPlayer.Character

                            local root =
                                character
                                and character:
                                FindFirstChild(
                                    "HumanoidRootPart"
                                )

                            if root then

                                root.CFrame =
                                    CFrame.new(
                                        0,
                                        100,
                                        0
                                    )

                                HaroonWindUI:Notify({

                                    Title =
                                        "Teleport",

                                    Content =
                                        "تم نقلك إلى نقطة البداية.",

                                    Duration = 2
                                })

                            else

                                HaroonWindUI:Notify({

                                    Title =
                                        "Error",

                                    Content =
                                        "لم يتم العثور على الشخصية.",

                                    Duration = 3
                                })
                            end
                        end
                    )

                    MainTab:CreateToggle(
                        "Infinite Jump",
                        true,
                        function(value)

                            print(
                                "Infinite Jump:",
                                value
                            )

                            local character =
                                LocalPlayer.Character

                            local humanoid =
                                character
                                and character:
                                FindFirstChildOfClass(
                                    "Humanoid"
                                )

                            if humanoid then

                                humanoid.JumpPower =
                                    value
                                    and 100
                                    or 50
                            end
                        end
                    )

                    MainTab:CreateSlider(
                        "WalkSpeed",
                        16,
                        250,
                        50,
                        function(value)

                            local character =
                                LocalPlayer.Character

                            local humanoid =
                                character
                                and character:
                                FindFirstChildOfClass(
                                    "Humanoid"
                                )

                            if humanoid then
                                humanoid.WalkSpeed =
                                    value
                            end
                        end
                    )

                    --==================================
                    -- SETTINGS TAB
                    --==================================

                    local SettingsTab =
                        Window:CreateTab(
                            "Settings"
                        )

                    SettingsTab:CreateSection(
                        "UI Customization"
                    )

                    -- IMPORTANT:
                    -- Correct argument order:
                    -- Text, Options, Default,
                    -- MultiSelect, Callback

                    SettingsTab:CreateDropdown(
                        "Select Theme",

                        {
                            "Dark",
                            "Light",
                            "Custom"
                        },

                        "Dark",

                        false,

                        function(selected)

                            print(
                                "Selected Theme:",
                                selected
                            )

                            HaroonWindUI:Notify({

                                Title =
                                    "Theme Change",

                                Content =
                                    "تم اختيار: "
                                    .. tostring(
                                        selected
                                    ),

                                Duration = 2
                            })
                        end
                    )

                    SettingsTab:CreateDropdown(
                        "Select Features",

                        {
                            "Aimbot",
                            "ESP",
                            "Fly",
                            "NoClip",
                            "SpeedHack"
                        },

                        {
                            "Aimbot",
                            "Fly"
                        },

                        true,

                        function(states)

                            print(
                                "Selected Features:"
                            )

                            for feature, enabled in
                                pairs(states) do

                                print(
                                    feature,
                                    enabled
                                )
                            end
                        end
                    )

                    SettingsTab:CreateButton(
                        "Destroy UI Engine",
                        function()

                            Window:Destroy()
                        end
                    )
                end
            )
        end
    )
end
