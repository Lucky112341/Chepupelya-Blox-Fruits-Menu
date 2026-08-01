local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Color theme
local PURPLE_BORDER = Color3.fromRGB(157, 0, 255)
local PURPLE_TEXT = Color3.fromRGB(153, 0, 255)
local GREEN = Color3.fromRGB(0, 255, 0)
local BLACK = Color3.new(0, 0, 0)
local FONT = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)

local ANIM_DURATION = 0.25
local ANIM_EASE = Enum.EasingStyle.Quad
local ANIM_DIRECTION = Enum.EasingDirection.Out

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChepupelyaMenu"
screenGui.ResetOnSpawn = false 
screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
screenGui.Parent = PlayerGui

-- MainFrame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.8967, 0, 0.4382, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 346)
mainFrame.BackgroundColor3 = BLACK
mainFrame.BorderColor3 = PURPLE_BORDER
mainFrame.BorderSizePixel = 2
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Close/Open"
toggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
toggleBtn.Position = UDim2.new(0.8967, 0, 0.4382, -189)
toggleBtn.Size = UDim2.new(0, 300, 0, 27)
toggleBtn.BackgroundColor3 = BLACK
toggleBtn.BorderColor3 = PURPLE_BORDER
toggleBtn.BorderSizePixel = 2
toggleBtn.Text = "Chepupelya BF"
toggleBtn.TextColor3 = PURPLE_BORDER
toggleBtn.TextStrokeColor3 = PURPLE_BORDER
toggleBtn.TextStrokeTransparency = 1
toggleBtn.TextScaled = true
toggleBtn.FontFace = FONT
toggleBtn.AutoButtonColor = true
toggleBtn.Active = true
toggleBtn.Parent = screenGui

-- Helper: create section label
local function createSectionLabel(name, text, posY)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.new(0.5, 0, posY, 0)
	label.Size = UDim2.new(0, 300, 0, 29)
	label.BackgroundColor3 = BLACK
	label.BorderColor3 = PURPLE_BORDER
	label.BorderSizePixel = 2
	label.Text = text
	label.TextColor3 = PURPLE_BORDER
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 1
	label.TextScaled = true
	label.FontFace = FONT
	label.Parent = mainFrame
	return label
end

-- Helper: create feature button
local function createFeatureButton(name, text, posY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.Position = UDim2.new(0.5, 0, posY, 0)
	btn.Size = UDim2.new(0, 250, 0, 24)
	btn.BackgroundColor3 = BLACK
	btn.BorderColor3 = PURPLE_BORDER
	btn.BorderSizePixel = 2
	btn.Text = text
	btn.TextColor3 = PURPLE_TEXT
	btn.TextStrokeColor3 = Color3.new(0, 0, 0)
	btn.TextStrokeTransparency = 1
	btn.TextScaled = true
	btn.FontFace = FONT
	btn.AutoButtonColor = true
	btn.Active = true
	btn.Parent = mainFrame
	return btn
end

-- Build the menu
local text1 = createSectionLabel("Text1", "FARM", 0.028)
local chestFarmBtn = createFeatureButton("ChestFarm", "Chest Farm", 0.1531)
local mobFarmBtn = createFeatureButton("MobFarm", "Mob Farm", 0.2665)
local seaBeastFarmBtn = createFeatureButton("SeaBeastFarm", "Sea Beast Farm", 0.3778)
local text2 = createSectionLabel("Text2", "OTHERS", 0.5143)
local godModeBtn = createFeatureButton("GodMode", "God Water", 0.6241)
local hitboxBtn = createFeatureButton("HitboxAccurate", "Hitbox Accurate", 0.7299)
local fastAttackBtn = createFeatureButton("FastAttack", "FastAttack", 0.8357)

-- Tween all transparencies
local function getFadeTargets()
	local targets = {mainFrame}
	for _, child in mainFrame:GetDescendants() do
		if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("Frame") then
			table.insert(targets, child)
		end
	end
	return targets
end

local function tweenTransparency(targets, goalBg, goalText, goalBorder, callback)
	local info = TweenInfo.new(ANIM_DURATION, ANIM_EASE, ANIM_DIRECTION)
	local playing = 0

	for _, obj in targets do
		if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") then
			local goals = {BackgroundTransparency = goalBg}
			if obj:IsA("TextLabel") or obj:IsA("TextButton") then
				goals.TextTransparency = goalText
				goals.TextStrokeTransparency = goalText
			end
			if goalBorder ~= nil then
				goals.BorderSizePixel = if goalBorder then 2 else 0
			end
			local tween = TweenService:Create(obj, info, goals)
			playing = playing + 1
			tween:Play()
			tween.Completed:Connect(function()
				playing = playing - 1
				if playing == 0 and callback then
					callback()
				end
			end)
		end
	end
end

-- Toggle GUI logic
local menuOpen = true
local isAnimating = false

toggleBtn.MouseButton1Click:Connect(function()
	if isAnimating then return end
	isAnimating = true
	menuOpen = not menuOpen

	local targets = getFadeTargets()

	if menuOpen then
		for _, obj in targets do
			if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") then
				obj.BackgroundTransparency = 1
				obj.BorderSizePixel = 0
				if obj:IsA("TextLabel") or obj:IsA("TextButton") then
					obj.TextTransparency = 1
					obj.TextStrokeTransparency = 1
				end
			end
		end
		mainFrame.Visible = true
		tweenTransparency(targets, 0, 0, true, function()
			isAnimating = false
		end)
	else
		tweenTransparency(targets, 1, 1, false, function()
			mainFrame.Visible = false
			isAnimating = false
		end)
	end
end)


-- ==========================================
-- CHEST FARM LOGIC (PERFECTED FOR BLOX FRUITS)
-- ==========================================

local chestFarmActive = false
local noclipConnection = nil

-- Noclip
local function toggleNoclip(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			if Player.Character then
				for _, v in pairs(Player.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
	end
end

-- Функція для перевірки, чи є об'єкт скринею у Blox Fruits
local function isChest(obj)
	-- Blox Fruits використовує назви на кшталт "Chest1", "Chest2", "Chest3" тощо.
	-- Іноді вони лежать у workspace.Map або інших папках.
	if obj:IsA("Model") or obj:IsA("Part") then
		local name = string.lower(obj.Name)
		-- Перевіряємо, чи містить назва "chest"
		if string.find(name, "chest") then
			-- Додаткова перевірка: якщо це модель, чи є всередині TouchInterest
			-- (саме через TouchInterest гравець збирає скриню)
			local hasTouchInterest = false
			for _, child in pairs(obj:GetDescendants()) do
				if child:IsA("TouchTransmitter") then
					hasTouchInterest = true
					break
				end
			end
			return hasTouchInterest
		end
	end
	return false
end

-- Основний цикл ферми
local function startChestFarm()
	task.spawn(function()
		local antiGravity = Instance.new("BodyVelocity")
		antiGravity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		antiGravity.Velocity = Vector3.new(0, 0, 0)

		while chestFarmActive do
			task.wait()
			local char = Player.Character
			if not char then continue end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end

			-- Пошук найближчої скрині серед УСІХ об'єктів у workspace
			local nearestChest = nil
			local shortestDistance = math.huge
			local targetPartToTouch = nil

			-- Перебираємо всіх нащадків workspace, щоб знайти скрині навіть у папках
			for _, obj in pairs(workspace:GetDescendants()) do
				if isChest(obj) then
					-- Знаходимо частину (Part), до якої треба доторкнутися
					local touchPart = nil
					if obj:IsA("BasePart") and obj:FindFirstChildWhichIsA("TouchTransmitter") then
						touchPart = obj
					elseif obj:IsA("Model") then
						-- Шукаємо BasePart всередині моделі, що має TouchTransmitter
						for _, child in pairs(obj:GetDescendants()) do
							if child:IsA("BasePart") and child:FindFirstChildWhichIsA("TouchTransmitter") then
								touchPart = child
								break
							end
						end
						-- Якщо не знайшли з TouchTransmitter, беремо PrimaryPart
						if not touchPart then
							touchPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
						end
					end

					if touchPart then
						local dist = (hrp.Position - touchPart.Position).Magnitude
						if dist < shortestDistance then
							shortestDistance = dist
							nearestChest = obj
							targetPartToTouch = touchPart
						end
					end
				end
			end

			-- Якщо знайшли скриню
			if nearestChest and targetPartToTouch then
				antiGravity.Parent = hrp
				local speed = 300

				-- Летимо до скрині
				while chestFarmActive and nearestChest.Parent and (hrp.Position - targetPartToTouch.Position).Magnitude > 3 do
					local dt = RunService.Heartbeat:Wait()
					local direction = (targetPartToTouch.Position - hrp.Position).Unit
					local step = direction * (speed * dt)

					if (hrp.Position - targetPartToTouch.Position).Magnitude < step.Magnitude then
						hrp.CFrame = targetPartToTouch.CFrame
						break
					else
						hrp.CFrame = hrp.CFrame + step
					end
				end

				-- Збір скрині
				if chestFarmActive and nearestChest.Parent and (hrp.Position - targetPartToTouch.Position).Magnitude <= 10 then
					if firetouchinterest then
						firetouchinterest(hrp, targetPartToTouch, 0)
						task.wait(0.05)
						firetouchinterest(hrp, targetPartToTouch, 1)
					else
						hrp.CFrame = targetPartToTouch.CFrame
					end
					
					-- Чекаємо, поки скриня зникне, або максимум 1 секунду
					local waitTime = 0
					while nearestChest.Parent and waitTime < 1 do
						task.wait(0.1)
						waitTime = waitTime + 0.1
					end
				end
			else
				-- Якщо скринь немає (всі зібрані) - чекаємо
				antiGravity.Parent = nil
				task.wait(1)
			end
		end

		if antiGravity then
			antiGravity:Destroy()
		end
	end)
end

-- Обробка натискання кнопки
chestFarmBtn.MouseButton1Click:Connect(function()
	chestFarmActive = not chestFarmActive
	
	if chestFarmActive then
		chestFarmBtn.Text = "Chest Farm ON"
		chestFarmBtn.TextColor3 = GREEN
		chestFarmBtn.BorderColor3 = GREEN
		toggleNoclip(true)
		startChestFarm()
	else
		chestFarmBtn.Text = "Chest Farm"
		chestFarmBtn.TextColor3 = PURPLE_TEXT
		chestFarmBtn.BorderColor3 = PURPLE_BORDER
		toggleNoclip(false)
		
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
			local bv = Player.Character.HumanoidRootPart:FindFirstChildWhichIsA("BodyVelocity")
			if bv then bv:Destroy() end
		end
	end
end)
