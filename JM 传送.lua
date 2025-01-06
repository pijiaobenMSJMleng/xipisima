if getgenv().ED_AntiKick then
	return
end

getgenv().ED_AntiKick = {
	Enabled = true, -- Set to false if you want to disable the Anti-Kick.
	SendNotifications = true, -- Set to true if you want to get notified for every event
	CheckCaller = true -- Set to true if you want to disable kicking by other executed scripts
}

local dropdown = {}
local playernamedied = ""
local teleportConnection

for i, player in pairs(game.Players:GetPlayers()) do
    dropdown[i] = player.Name
end

function Notify(top, text, ico, dur)
  game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = top,
    Text = text,
    Icon = ico,
    Duration = dur,
  })
end

local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))()     
local win = ui:new("JM")
--

local UITab1 = win:Tab("『通用』",'87437251671184')

local about = UITab1:section("『通用』",true)

about:Dropdown("选择玩家", 'Dropdown', dropdown, function(v)
    playernamedied = v
end)

game.Players.ChildAdded:Connect(function(player)
    dropdown[player.UserId] = player.Name
    Players:AddOption(player.Name)
end)

game.Players.ChildRemoved:Connect(function(player)
    Players:RemoveOption(player.Name)
    for k, v in pairs(dropdown) do
        if v == player.Name then
            dropdown[k] = nil
        end
    end
end)

about:Button("传送到玩家旁边一次", function()
    local HumRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
    local tp_player = game.Players:FindFirstChild(playernamedied)
    if tp_player and tp_player.Character and tp_player.Character.HumanoidRootPart then
        HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        Notify("JM", "成功", "rbxassetid://", 5)
    else
        Notify("JM", "没有目标", "rbxassetid://", 5)
    end
end)

about:Button("把玩家传送过来", function()
    local HumRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
    local tp_player = game.Players:FindFirstChild(playernamedied)
    if tp_player and tp_player.Character and tp_player.Character.HumanoidRootPart then
        tp_player.Character.HumanoidRootPart.CFrame = HumRoot.CFrame + Vector3.new(0, 3, 0)
        Notify("JM", "已传送过来", "rbxassetid://", 5)
    else
        Notify("JM", "没有目标", "rbxassetid://", 5)
    end
end)

about:Toggle("查看玩家", 'Toggleflag', false, function(state)
    if state then
        game:GetService('Workspace').CurrentCamera.CameraSubject =
            game:GetService('Players'):FindFirstChild(playernamedied).Character.Humanoid
            Notify("JM", "已查看", "rbxassetid://", 5)
    else
        Notify("JM", "已关闭", "rbxassetid://", 5)
        local lp = game.Players.LocalPlayer
        game:GetService('Workspace').CurrentCamera.CameraSubject = lp.Character.Humanoid
    end
end)

about:Toggle("循环传送玩家", "Toggle", false, function(Value)
    if Value then
        local localPlayer = game.Players.LocalPlayer
        local targetPlayer = game.Players:FindFirstChild(playernamedied)
        if localPlayer and targetPlayer and localPlayer.Character and targetPlayer.Character then
            local function doTeleport()
                local HumRoot = localPlayer.Character.HumanoidRootPart
                local tp_player = targetPlayer.Character.HumanoidRootPart
                HumRoot.CFrame = tp_player.CFrame + Vector3.new(0, 3, 0)
            end
            
            local RunService = game:GetService("RunService")
            local teleportTimer = 0
            local teleportInterval = 0.01  
            teleportConnection = RunService.Heartbeat:Connect(function(dt)
                teleportTimer = teleportTimer + dt
                if teleportTimer >= teleportInterval then
                    doTeleport()
                    teleportTimer = 0
                end
            end)
            
        else
            Notify("JM", "玩家或角色不存在，无法启动循环传送", "rbxassetid://", 5)
        end
    else
        
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
        Notify("JM", "已停止循环传送玩家", "rbxassetid://", 5)
    end
end)

about:Toggle("脚本框架变小一点", "", false, function(state)
        if state then
        game:GetService("CoreGui")["frosty"].Main.Style = "DropShadow"
        else
            game:GetService("CoreGui")["frosty"].Main.Style = "Custom"
        end
    end)
    about:Button("关闭脚本",function()
        game:GetService("CoreGui")["frosty"]:Destroy()
    end)
