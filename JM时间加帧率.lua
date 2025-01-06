--二改龙叔
local LBLG = Instance.new("ScreenGui", getParent)
local LBL = Instance.new("TextLabel", getParent)
local player = game.Players.LocalPlayer

local function createGUI()
    LBLG.Name = "LBLG"
    LBLG.Parent = game.CoreGui
    LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LBLG.Enabled = true

    LBL.Name = "LBL"
    LBL.Parent = LBLG
    LBL.BackgroundColor3 = Color3.new(1, 1, 1)
    LBL.BackgroundTransparency = 1
    LBL.BorderColor3 = Color3.new(0, 0, 0)
    LBL.Position = UDim2.new(0.75, 0, 0.010, 0)
    LBL.Size = UDim2.new(0, 133, 0, 30)
    LBL.Font = Enum.Font.GothamSemibold
    LBL.Text = "Initial Text"
    LBL.TextColor3 = Color3.new(1, 1, 1)
    LBL.TextScaled = true
    LBL.TextSize = 14
    LBL.TextWrapped = true
    LBL.Visible = true

    return LBL
end

local FpsLabel = createGUI()

local Heartbeat = game:GetService("RunService").Heartbeat
local LastIteration, Start
local FrameUpdateTable = {}
local MAX_FRAME_RECORDS = 200  

local function updateFPSAndTime()
    LastIteration = tick()
    table.insert(FrameUpdateTable, LastIteration)
    while #FrameUpdateTable > MAX_FRAME_RECORDS do
        table.remove(FrameUpdateTable, 1)
    end

    local elapsedTime = LastIteration - Start
    local CurrentFPS
    if elapsedTime >= 1 then
        CurrentFPS = #FrameUpdateTable
        Start = LastIteration
    else
        CurrentFPS = #FrameUpdateTable / elapsedTime
    end
    CurrentFPS = math.floor(CurrentFPS + 0.5)

    local currentTime = os.date("%H").."时"..os.date("%M").."分"..os.date("%S")
    FpsLabel.Text = string.format("时间:%s  帧率:%d", currentTime, CurrentFPS)
end

Start = tick()
Heartbeat:Connect(updateFPSAndTime)
