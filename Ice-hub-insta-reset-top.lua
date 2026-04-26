-- // ICE HUB (Insta Respawn) — Reconstructed from trace + source logic //

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- // 1 (HiddenUI Container) //
local hiddenUI = Instance.new("Folder", CoreGui)
hiddenUI.Name = "HiddenUI"

local gui = Instance.new("ScreenGui", hiddenUI)
gui.Name = "IceHubGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

-- // 2 (Main Frame) //
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(200, 180)
frame.Position = UDim2.new(0.5, -100, 0.75, -90)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.6
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- // 3 (Title) //
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 26)
title.Position = UDim2.fromOffset(12, 5)
title.BackgroundTransparency = 1
title.Text = "ICE HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- // 4 (Insta Respawn Button) //
local respawnBtn = Instance.new("TextButton", frame)
respawnBtn.Size = UDim2.fromOffset(180, 40)
respawnBtn.Position = UDim2.new(0.5, -90, 0, 40)
respawnBtn.BackgroundColor3 = Color3.new(0, 0, 0)
respawnBtn.BackgroundTransparency = 0.5
respawnBtn.TextColor3 = Color3.new(1, 1, 1)
respawnBtn.Text = "INSTA RESPAWN"
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextSize = 14
respawnBtn.BorderSizePixel = 0
respawnBtn.AutoButtonColor = false
Instance.new("UICorner", respawnBtn).CornerRadius = UDim.new(0, 7)

-- // 5 (Keybind Button) //
local keybindBtn = Instance.new("TextButton", frame)
keybindBtn.Size = UDim2.fromOffset(180, 28)
keybindBtn.Position = UDim2.new(0.5, -90, 0, 88)
keybindBtn.BackgroundColor3 = Color3.new(0, 0, 0)
keybindBtn.BackgroundTransparency = 0.5
keybindBtn.TextColor3 = Color3.new(1, 1, 1)
keybindBtn.Text = "KeyBind: R"
keybindBtn.Font = Enum.Font.GothamMedium
keybindBtn.TextSize = 12
keybindBtn.BorderSizePixel = 0
keybindBtn.AutoButtonColor = false
Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 5)

-- // 6 (Reset on Balloon Button) //
local balloonBtn = Instance.new("TextButton", frame)
balloonBtn.Size = UDim2.fromOffset(180, 28)
balloonBtn.Position = UDim2.new(0.5, -90, 0, 124)
balloonBtn.BackgroundColor3 = Color3.new(0, 0, 0)
balloonBtn.BackgroundTransparency = 0.5
balloonBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
balloonBtn.Text = "Reset on Balloon: OFF"
balloonBtn.Font = Enum.Font.GothamMedium
balloonBtn.TextSize = 12
balloonBtn.BorderSizePixel = 0
balloonBtn.AutoButtonColor = false
Instance.new("UICorner", balloonBtn).CornerRadius = UDim.new(0, 5)

-- // 7 (Minimize Button) //
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.fromOffset(26, 26)
minBtn.Position = UDim2.new(1, -30, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false

-- // 8 (State Variables) //
local keybind = Enum.KeyCode.R
local balloonReset = false
local minimized = false
local rebinding = false
local FULL_H = 180
local MIN_H = 36
local deathCoords = CFrame.new(1000003.56, 999999.69, 8.17)
local lastTrigger = 0
local COOLDOWN = 3

-- // 9 (Remove Camera Blur) //
task.spawn(function()
	local cam = workspace.CurrentCamera
	if cam then
		for _, child in cam:GetChildren() do
			if child:IsA("BlurEffect") then child:Destroy() end
		end
		cam.ChildAdded:Connect(function(child)
			if child:IsA("BlurEffect") then child:Destroy() end
		end)
	end
end)

-- // 10 (Equip Carpet Helper) //
local function equipCarpet()
	local char = player.Character
	if not char then return end
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and tool.Name:lower():find("carpet") then
				char:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
				return
			end
		end
	end
end

-- // 11 (TP + Die — Real Reset Method) //
local function tpAndDie()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end
	respawnBtn.Text = "RESETTING..."
	equipCarpet()
	task.wait()
	hrp.CFrame = deathCoords
	local conn
	conn = RunService.Heartbeat:Connect(function()
		if not char or not char.Parent then conn:Disconnect() return end
		local h = char:FindFirstChild("Humanoid")
		local r = char:FindFirstChild("HumanoidRootPart")
		if not h or not r then conn:Disconnect() return end
		if h.Health <= 0 then
			conn:Disconnect()
			respawnBtn.Text = "INSTA RESPAWN"
			return
		end
		r.CFrame = deathCoords
	end)
end

-- // 12 (Respawn Button Click) //
respawnBtn.MouseButton1Click:Connect(tpAndDie)

-- // 13 (Keybind Rebind) //
keybindBtn.MouseButton1Click:Connect(function()
	rebinding = true
	keybindBtn.Text = "[...]"
	keybindBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
end)

-- // 14 (Balloon Toggle) //
balloonBtn.MouseButton1Click:Connect(function()
	balloonReset = not balloonReset
	if balloonReset then
		lastTrigger = tick()
		balloonBtn.Text = "Reset on Balloon: ON"
		balloonBtn.TextColor3 = Color3.new(1, 1, 1)
	else
		balloonBtn.Text = "Reset on Balloon: OFF"
		balloonBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	end
end)

-- // 15 (Input Handler — Keybind + Rebind) //
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if rebinding then
		keybind = input.KeyCode
		keybindBtn.Text = "KeyBind: " .. keybind.Name
		keybindBtn.TextColor3 = Color3.new(1, 1, 1)
		rebinding = false
		return
	end
	if input.KeyCode == keybind then
		tpAndDie()
	end
end)

-- // 16 (Minimize) //
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
		Size = UDim2.fromOffset(200, minimized and MIN_H or FULL_H)
	}):Play()
	minBtn.Text = minimized and "+" or "-"
	respawnBtn.Visible = not minimized
	keybindBtn.Visible = not minimized
	balloonBtn.Visible = not minimized
end)

-- // 17 (Dragging) //
do
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- // 18 (Balloon Text Detection) //
local function hasBalloon(text)
	if typeof(text) ~= "string" then return false end
	local lower = string.lower(text)
	return lower:find("balloon") ~= nil or lower:find("ballon") ~= nil
end

local function checkText(text)
	if not balloonReset then return end
	if not hasBalloon(text) then return end
	local now = tick()
	if now - lastTrigger < COOLDOWN then return end
	lastTrigger = now
	tpAndDie()
end

-- // 19 (PlayerGui Text Scanner) //
local function scanGuiObjects(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			checkText(obj.Text)
			obj:GetPropertyChangedSignal("Text"):Connect(function()
				checkText(obj.Text)
			end)
		end
	end
end

local function setupGuiWatcher(g)
	g.DescendantAdded:Connect(function(desc)
		task.wait()
		if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
			checkText(desc.Text)
			desc:GetPropertyChangedSignal("Text"):Connect(function()
				checkText(desc.Text)
			end)
		end
	end)
end

-- // 20 (Watch CoreGui) //
pcall(function()
	scanGuiObjects(CoreGui)
	setupGuiWatcher(CoreGui)
end)

-- // 21 (Watch Existing + New PlayerGui) //
for _, g in ipairs(PlayerGui:GetChildren()) do
	scanGuiObjects(g)
	setupGuiWatcher(g)
end

PlayerGui.ChildAdded:Connect(function(g)
	setupGuiWatcher(g)
	scanGuiObjects(g)
end)
