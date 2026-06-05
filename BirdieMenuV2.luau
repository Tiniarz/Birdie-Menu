local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
Name = "Birdie Menu V2",
LoadingTitle = "Birdie Menu V2",
LoadingSubtitle = "Great for trolling and more!",
ConfigurationSaving = {
Enabled = false
}
})

local Tab = Window:CreateTab("Flight Settings", nil)
local UtilityTab = Window:CreateTab("Utility", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local CreditsTab = Window:CreateTab("Credits", nil)

local startPos, endPos = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
local isRunning = false
local speedMultiplier = 1.0
local infJumpEnabled = false
local espEnabled = false
local fullbrightEnabled = false

CreditsTab:CreateLabel("Creator/Developer - @squidgames456heart (Jay Programmer on Tiktok)")
CreditsTab:CreateLabel("Alr bro that was not the wind - Beta Tester")

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
local speeds = {0.5, 1.0, 1.5, 2.0, 2.5}
for _, speed in ipairs(speeds) do
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
Callback = function(Value)
isRunning = Value
end,
})

UtilityTab:CreateToggle({
Name = "Infinite Jump",
Callback = function(Value)
infJumpEnabled = Value
end,
})

UtilityTab:CreateSlider({
Name = "WalkSpeed",
Range = {16, 250},
Increment = 1,
Suffix = " Speed",
CurrentValue = 16,
Callback = function(Value)
LocalPlayer.Character.Humanoid.WalkSpeed = Value
end,
})

UtilityTab:CreateSlider({
Name = "JumpPower",
Range = {50, 500},
Increment = 10,
Suffix = " Power",
CurrentValue = 50,
Callback = function(Value)
LocalPlayer.Character.Humanoid.UseJumpPower = true
LocalPlayer.Character.Humanoid.JumpPower = Value
end,
})

VisualsTab:CreateToggle({
Name = "ESP (Highlight)",
Callback = function(Value)
espEnabled = Value
if espEnabled then
for _, v in pairs(Players:GetPlayers()) do
if v ~= LocalPlayer and v.Character then
local highlight = Instance.new("Highlight", v.Character)
highlight.Name = "ESP_Highlight"
highlight.FillColor = Color3.fromRGB(255, 0, 0)
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
fullbrightEnabled = Value
if fullbrightEnabled then
Lighting.Ambient = Color3.new(1, 1, 1)
Lighting.Brightness = 2
else
Lighting.Ambient = Color3.new(0, 0, 0)
Lighting.Brightness = 1
end
end,
})

VisualsTab:CreateButton({
Name = "Remove Fog",
Callback = function()
Lighting.FogEnd = 100000
end,
})

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
local distance = (endPos - startPos).Magnitude
local duration = distance / (20 * speedMultiplier)
local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
local tween1 = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(endPos)})
tween1:Play()
tween1.Completed:Wait()
if isRunning then
local tween2 = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(startPos)})
tween2:Play()
tween2.Completed:Wait()
end
end
end
task.wait()
end
end)