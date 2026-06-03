local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")

local Window = Rayfield:CreateWindow({
Name = "Birdie Menu V1",
LoadingTitle = "Birdie Menu V1",
LoadingSubtitle = "Good for trolling and more!",
ConfigurationSaving = {
Enabled = false
}
})

local Tab = Window:CreateTab("Flight Settings", nil)
local CreditsTab = Window:CreateTab("Credits", nil)

local startPos, endPos = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
local isRunning = false
local speedMultiplier = 1.0

CreditsTab:CreateLabel("Creator/Developer - @squidgames456heart (Jay Programmer on Tiktok)")
CreditsTab:CreateLabel("Alr bro that was not the wind - Beta Tester")

Tab:CreateButton({
Name = "Set Start Position",
Callback = function()
startPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
Rayfield:Notify({Title = "Position Set", Content = "Start position updated!"})
end,
})

Tab:CreateButton({
Name = "Set End Position",
Callback = function()
endPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
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
end,9
})
end

Tab:CreateToggle({
Name = "Start Birding",
Callback = function(Value)
isRunning = Value
end,
})

task.spawn(function()
while true do
if isRunning then
local character = game.Players.LocalPlayer.Character
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