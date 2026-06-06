local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://7024233823"
Sound.Looped = true
Sound.Volume = 1
Sound.Parent = game.Workspace
Sound:Play()

local Window = Rayfield:CreateWindow({
Name = "Birdie Menu V3",
LoadingTitle = "Birdie Menu V3",
LoadingSubtitle = "Great Menu For Everything!",
ConfigurationSaving = {
Enabled = false
}
})

local Tab = Window:CreateTab("Flight Settings", nil)
local UtilityTab = Window:CreateTab("Utility", nil)
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

CreditsTab:CreateLabel("Creator/Developer - @squidgames456heart (Jay Programmer on Tiktok)")
CreditsTab:CreateLabel("Alr bro that was not the wind - Beta Tester")

SettingsTab:CreateToggle({
Name = "Theme Song",
CurrentValue = true,
Callback = function(Value)
if Value then Sound:Resume() else Sound:Pause() end
end,
})

Tab:CreateButton({
Name = "Set Start Position",
Callback = function()
startPos = LocalPlayer.Character.HumanoidRootPart.Position
Rayfield:Notify({Title = "Position Set", Content = "Start position updated!"})
end,
})

Tab:CreateButton({
Name = "Set End Position",
Callback = function()
endPos = LocalPlayer.Character.HumanoidRootPart.Position
Rayfield:Notify({Title = "Position Set", Content = "End position updated!"})
end,
})

Tab:CreateLabel("Speed Configuration")
for _, speed in ipairs({0.5, 1.0, 1.5, 2.0, 2.5}) do
Tab:CreateButton({
Name = "Speed: " .. tostring(speed) .. "x",
Callback = function()
speedMultiplier = speed
Rayfield:Notify({Title = "Speed Updated", Content = "Speed set to " .. tostring(speed) .. "x"})
end,
})
end

Tab:CreateToggle({
Name = "Start Birding",
Callback = function(Value) isRunning = Value end,
})

UtilityTab:CreateToggle({
Name = "Infinite Jump",
Callback = function(Value) infJumpEnabled = Value end,
})

UtilityTab:CreateToggle({
Name = "Sit",
Callback = function(Value) LocalPlayer.Character.Humanoid.Sit = Value end,
})

UtilityTab:CreateToggle({
Name = "Anti Ragdoll",
Callback = function(Value) antiRagdollEnabled = Value end,
})

UtilityTab:CreateToggle({
Name = "Anti Fling",
Callback = function(Value) antiFlingEnabled = Value end,
})

UtilityTab:CreateSlider({
Name = "Player Size",
Range = {1, 600},
Increment = 1,
CurrentValue = 1,
Callback = function(Value)
for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.Size = Vector3.new(Value/10, Value/10, Value/10)
end
end
end,
})

UtilityTab:CreateButton({
Name = "Destroy Door/Glass",
Callback = function()
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and (v.Name == "Door" or v.Name == "Glass") then
v:Destroy()
end
end
end,
})

MovementTab:CreateSlider({
Name = "WalkSpeed",
Range = {16, 250},
Increment = 1,
CurrentValue = 16,
Callback = function(Value) LocalPlayer.Character.Humanoid.WalkSpeed = Value end,
})

MovementTab:CreateSlider({
Name = "JumpPower",
Range = {50, 500},
Increment = 10,
CurrentValue = 50,
Callback = function(Value)
LocalPlayer.Character.Humanoid.UseJumpPower = true
LocalPlayer.Character.Humanoid.JumpPower = Value
end,
})

MovementTab:CreateToggle({
Name = "Noclip",
Callback = function(Value) noclipEnabled = Value end,
})

VisualsTab:CreateToggle({
Name = "ESP (Highlight)",
Callback = function(Value)
if Value then
for _, v in pairs(Players:GetPlayers()) do
if v ~= LocalPlayer and v.Character then
local h = Instance.new("Highlight", v.Character)
h.Name = "ESP_Highlight"
h.FillColor = Color3.fromRGB(255, 0, 0)
end
end
else
for _, v in pairs(Players:GetPlayers()) do
if v.Character and v.Character:FindFirstChild("ESP_Highlight") then
v.Character.ESP_Highlight:Destroy()
end
end
end
end,
})

VisualsTab:CreateToggle({
Name = "Full Bright",
Callback = function(Value)
Lighting.Ambient = Value and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
Lighting.Brightness = Value and 2 or 1
end,
})

VisualsTab:CreateToggle({
Name = "Night Mode",
Callback = function(Value)
Lighting.ClockTime = Value and 0 or 14
end,
})

VisualsTab:CreateButton({
Name = "Remove Fog",
Callback = function() Lighting.FogEnd = 100000 end,
})

RunService.Stepped:Connect(function()
if noclipEnabled and LocalPlayer.Character then
for _, part in pairs(LocalPlayer.Character:GetChildren()) do
if part:IsA("BasePart") then part.CanCollide = false end
end
end
if antiRagdollEnabled and LocalPlayer.Character then
local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if root and root:FindFirstChild("RagdollConstraint") then
root.RagdollConstraint:Destroy()
end
end
if antiFlingEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
end
end)

UserInputService.JumpRequest:Connect(function()
if infJumpEnabled then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end
end)

task.spawn(function()
while true do
if isRunning then
local character = LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if root then
local duration = (endPos - startPos).Magnitude / (20 * speedMultiplier)
local tInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
local t1 = TweenService:Create(root, tInfo, {CFrame = CFrame.new(endPos)})
t1:Play()
t1.Completed:Wait()
if isRunning then
local t2 = TweenService:Create(root, tInfo, {CFrame = CFrame.new(startPos)})
t2:Play()
t2.Completed:Wait()
end
end
end
task.wait()
end
end)