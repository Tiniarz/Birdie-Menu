local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://7024233823"
Sound.Looped = true
Sound.Volume = 1
Sound.Parent = game.Workspace
Sound:Play()

local Window = Rayfield:CreateWindow({
Name = "Birdie Menu V4",
LoadingTitle = "Birdie Menu V4",
LoadingSubtitle = "Best VERSION YET!",
ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Flight Settings", nil)
local UtilityTab = Window:CreateTab("Utility", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local TrollingTab = Window:CreateTab("Trolling", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local SettingsTab = Window:CreateTab("Settings", nil)
local CreditsTab = Window:CreateTab("Credits", nil)

local startPos, endPos = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
local isRunning = false
local speedMultiplier = 1.0
local infJumpEnabled = false
local noclipEnabled = false
local antiRagdollEnabled = false
local antiFlingEnabled = false
local autoClickerEnabled = false
local spinBotEnabled = false
local speedHackEnabled = false

CreditsTab:CreateLabel("Creator/Developer - @squidgames456heart")
CreditsTab:CreateLabel("Alr bro that was not the wind - Beta Tester")
CreditsTab:CreateLabel("You! - For using Birdie Menu!")

SettingsTab:CreateToggle({Name = "Theme Song", CurrentValue = true, Callback = function(V) if V then Sound:Resume() else Sound:Pause() end end})

Tab:CreateButton({Name = "Set Start Position", Callback = function() startPos = LocalPlayer.Character.HumanoidRootPart.Position; Rayfield:Notify({Title = "Set", Content = "Start Pos Updated"}) end})
Tab:CreateButton({Name = "Set End Position", Callback = function() endPos = LocalPlayer.Character.HumanoidRootPart.Position; Rayfield:Notify({Title = "Set", Content = "End Pos Updated"}) end})
Tab:CreateLabel("Speed Configuration")
for _, speed in ipairs({0.5, 1.0, 1.5, 2.0, 2.5}) do
Tab:CreateButton({Name = "Speed: " .. tostring(speed) .. "x", Callback = function() speedMultiplier = speed; Rayfield:Notify({Title = "Speed Updated", Content = "Speed set to " .. tostring(speed) .. "x"}) end})
end
Tab:CreateToggle({Name = "Start Birding", Callback = function(V) isRunning = V end})

UtilityTab:CreateToggle({Name = "Infinite Jump", Callback = function(V) infJumpEnabled = V end})
UtilityTab:CreateToggle({Name = "Anti Ragdoll", Callback = function(V) antiRagdollEnabled = V end})
UtilityTab:CreateToggle({Name = "Anti Fling", Callback = function(V) antiFlingEnabled = V end})
UtilityTab:CreateSlider({Name = "Player Size", Range = {1, 600}, Increment = 1, CurrentValue = 10, Callback = function(V) for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.Size = Vector3.new(V/10, V/10, V/10) end end end})
UtilityTab:CreateButton({Name = "Destroy Door/Glass", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Part") and (v.Name == "Door" or v.Name == "Glass") then v:Destroy() end end end})
UtilityTab:CreateButton({Name = "Instant Respawn", Callback = function() LocalPlayer.Character.Humanoid.Health = 0 end})

CombatTab:CreateToggle({Name = "Auto Clicker", Callback = function(V) autoClickerEnabled = V end})
CombatTab:CreateToggle({Name = "Spin Bot", Callback = function(V) spinBotEnabled = V end})
CombatTab:CreateButton({Name = "Teleport to Random Player", Callback = function() local p = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]; if p and p.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end})
CombatTab:CreateButton({Name = "Kill All (If Possible)", Callback = function() for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then p.Character.Humanoid.Health = 0 end end end})

TrollingTab:CreateButton({Name = "Lag Server (Heavy)", Callback = function() for i=1, 5000 do Instance.new("Part", workspace) end end})
TrollingTab:CreateToggle({Name = "Fling Aura", Callback = function(V) _G.FlingAura = V end})
TrollingTab:CreateButton({Name = "Randomize Part Sizes", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Size = Vector3.new(math.random(1,10), math.random(1,10), math.random(1,10)) end end end})

MovementTab:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, CurrentValue = 16, Callback = function(V) LocalPlayer.Character.Humanoid.WalkSpeed = V end})
MovementTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, CurrentValue = 50, Callback = function(V) LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = V end})
MovementTab:CreateToggle({Name = "Noclip", Callback = function(V) noclipEnabled = V end})
MovementTab:CreateToggle({Name = "Speed Hack (Loop)", Callback = function(V) speedHackEnabled = V end})

VisualsTab:CreateToggle({Name = "ESP Highlight", Callback = function(V) for _,p in pairs(Players:GetPlayers()) do if p.Character then if V then Instance.new("Highlight", p.Character) else if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end end end end})
VisualsTab:CreateToggle({Name = "Full Bright", Callback = function(V) Lighting.Ambient = V and Color3.new(1,1,1) or Color3.new(0,0,0) end})
VisualsTab:CreateToggle({Name = "Night Mode", Callback = function(V) Lighting.ClockTime = V and 0 or 14 end})
VisualsTab:CreateButton({Name = "Remove Fog", Callback = function() Lighting.FogEnd = 999999 end})
VisualsTab:CreateButton({Name = "FOV Changer (120)", Callback = function() workspace.CurrentCamera.FieldOfView = 120 end})

RunService.Stepped:Connect(function()
if noclipEnabled and LocalPlayer.Character then for _,p in pairs(LocalPlayer.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
if antiRagdollEnabled and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then local r = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("RagdollConstraint") if r then r:Destroy() end end
if antiFlingEnabled and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local root = LocalPlayer.Character.HumanoidRootPart
root.Velocity = Vector3.new(0, 0, 0)
root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end
if spinBotEnabled and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(20), 0) end
if autoClickerEnabled then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0) end
if speedHackEnabled and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = 100 end
if _G.FlingAura and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for _,p in pairs(Players:GetPlayers()) do
if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
p.Character.HumanoidRootPart.Velocity = Vector3.new(9999, 9999, 9999)
end
end
end
end)

UserInputService.JumpRequest:Connect(function() if infJumpEnabled then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

task.spawn(function()
while true do
if isRunning and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local dur = (endPos - startPos).Magnitude / (20 * speedMultiplier)
local t1 = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = CFrame.new(endPos)})
t1:Play(); t1.Completed:Wait()
local t2 = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = CFrame.new(startPos)})
t2:Play(); t2.Completed:Wait()
end
task.wait()
end
end)