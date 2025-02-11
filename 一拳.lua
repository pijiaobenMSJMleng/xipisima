local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Game = workspace.Game
local Items = workspace.ItemSpawns.items:GetChildren()
local RemoteStorage = ReplicatedStorage.devv.remoteStorage
local Hits = false
local Kills = false
local Ban = false
local Buy,Hit,Kill
local Call
Call = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if self.Parent == RemoteStorage then
        if self.Name == "meleeHit" then
            if LocalPlayer.UserId == 5537193070 then
                return
            elseif not Ban then
                Ban = true
                Instance.new("Message", workspace).Text = "bro 你不玩"
            end
        elseif #args ~= 0 then
            if args[2] ~= "Items" and table.find(Items, args[1]) then
                Buy = self
            elseif table.find({"prop", "player"}, args[1]) then
                Hit = self
            elseif typeof(args[1]) == "Instance" and args[1].ClassName == "Player" then
                if args[1].UserId == 5537193070 then
                    Kill = RemoteStorage.meleeHit
                    return
                else
                    Kill = self
                end
            end
        end
    end
    return Call(self, ...)
end)
local Player = ""
local List = {}
for _, v in pairs(Players:GetPlayers()) do
    table.insert(List, v.Name)
end
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))();        
local win = ui:new("攻击系列")
--
local UITab1 = win:Tab("仅供娱乐",'7734068321')

local about = UITab1:section("『Main』",true)

about:Textbox("快速跑步（死后重置）建议用2", "tpwalking", "输入", function(king)
local tspeed = king
local hb = game:GetService("RunService").Heartbeat
local tpwalking = true
local player = game:GetService("Players")
local lplr = player.LocalPlayer
local chr = lplr.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
while tpwalking and hb:Wait() and chr and hum and hum.Parent do
  if hum.MoveDirection.Magnitude > 0 then
    if tspeed then
      chr:TranslateBy(hum.MoveDirection * tonumber(tspeed))
    else
      chr:TranslateBy(hum.MoveDirection)
    end
  end
end
end)

about:Dropdown("玩家", "Player", List, function(value)
    Player = value
end)

about:Toggle("持续传送", "ItemTP", false, function(value)
    Teleport = value
end)

about:Toggle("打击", "Hit", false, function(value)
    Hits = value
end)

about:Toggle("杀戮", "Kill", false, function(value)
    Kills = value
end)

about:Toggle("所有","Toggle",false,function(Value)
xiaopi = Value
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player ~= "" then
            local TargetPlayer = Players:FindFirstChild(Player)
            if TargetPlayer and TargetPlayer.Character then
                local Character = TargetPlayer.Character
                local Health = Character.Humanoid.Health
                
                if Teleport then
                    LocalPlayer.Character.Humanoid.Sit = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
                end
                
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                if Distance < 35 and not Character:FindFirstChild("ForceField") then
                    if Hits and Health > 1 then
                        Hit:FireServer("player", {
                            meleeType = "meleemegapunch",
                            hitPlayerId = TargetPlayer.UserId
                        })
                    end
                    if Kills and Health == 1 then
                        Kill:FireServer(TargetPlayer)
                    end
                end
            end
        end
        
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Humanoid") then
                local Character = v.Character
                local Health = Character.Humanoid.Health
                local Head = Character:FindFirstChild("Head")
                local Distance = Head and (LocalPlayer.Character.HumanoidRootPart.Position - Head.Position).Magnitude or 9999

                if v ~= LocalPlayer and not Character:FindFirstChild("ForceField") then
                    if Distance < 35 then
                        if Hits and Health > 1 then
                            Hit:FireServer("player", {
                                meleeType = "meleemegapunch",
                                hitPlayerId = v.UserId
                            })
                        end
                        if Kills and Health == 1 then
                            Kill:FireServer(v)
                        end
                    end
                end
            end
        end
        for i, v in pairs(Players:GetPlayers()) do
            local Character = v.Character
            local Health = Character.Humanoid.Health
            local Distance = LocalPlayer:DistanceFromCharacter(Character.Head.Position)
            if v ~= LocalPlayer and not Character:FindFirstChild("ForceField") then
                if xiaopi then
                    LocalPlayer.Character.Humanoid.Sit = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
                end
                if Distance < 35 then
                    if xiaopi and Health > 1 then
                        Hit:FireServer("player", {
                            meleeType = "meleemegapunch",
                            hitPlayerId = v.UserId
                        })
                    end
                    if xiaopi and Health == 1 then
                        Kill:FireServer(v)
                    end
                end
            end
            end
    end)
end)