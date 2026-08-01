local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ==========================================
-- COLOR THEME & SETTINGS
-- ==========================================
local PURPLE_BORDER = Color3.fromRGB(157, 0, 255)
local PURPLE_TEXT = Color3.fromRGB(153, 0, 255)
local GREEN = Color3.fromRGB(0, 255, 0)
local BLACK = Color3.new(0, 0, 0)
local FONT = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
local ANIM_DURATION = 0.25
local ANIM_EASE = Enum.EasingStyle.Quad
local ANIM_DIRECTION = Enum.EasingDirection.Out

-- ==========================================
-- UI CREATION
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChepupelyaMenu"
screenGui.ResetOnSpawn = false 
screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
screenGui.Parent = PlayerGui

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

local text1 = createSectionLabel("Text1", "FARM", 0.028)
local chestFarmBtn = createFeatureButton("ChestFarm", "Chest Farm", 0.1531)
local mobFarmBtn = createFeatureButton("MobFarm", "Mob Farm", 0.2665)
local seaBeastFarmBtn = createFeatureButton("SeaBeastFarm", "Sea Beast Farm", 0.3778)
local text2 = createSectionLabel("Text2", "OTHERS", 0.5143)
local godModeBtn = createFeatureButton("GodMode", "God Water", 0.6241)
local hitboxBtn = createFeatureButton("HitboxAccurate", "Hitbox Accurate", 0.7299)
local fastAttackBtn = createFeatureButton("FastAttack", "FastAttack", 0.8357)

-- ==========================================
-- UI ANIMATIONS
-- ==========================================
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
				if playing == 0 and callback then callback() end
			end)
		end
	end
end

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
		tweenTransparency(targets, 0, 0, true, function() isAnimating = false end)
	else
		tweenTransparency(targets, 1, 1, false, function()
			mainFrame.Visible = false
			isAnimating = false
		end)
	end
end)

-- ==========================================
-- CORE FUNCTIONS (NOCLIP & FLY)
-- ==========================================
local noclipConnection = nil
local function toggleNoclip(state)
	if state then
		if not noclipConnection then
			noclipConnection = RunService.Stepped:Connect(function()
				if Player.Character then
					for _, v in pairs(Player.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide then
							v.CanCollide = false
						end
					end
				end
			end)
		end
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
	end
end

local function flyTo(targetCFrame, speed, conditionFunc, stopDistance)
	stopDistance = stopDistance or 3
	local char = Player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	local antiGravity = hrp:FindFirstChild("FarmAntiGravity")
	if not antiGravity then
		antiGravity = Instance.new("BodyVelocity")
		antiGravity.Name = "FarmAntiGravity"
		antiGravity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		antiGravity.Velocity = Vector3.new(0, 0, 0)
		antiGravity.Parent = hrp
	end

	while conditionFunc() and (hrp.Position - targetCFrame.Position).Magnitude > stopDistance do
		local dt = RunService.Heartbeat:Wait()
		if not char:FindFirstChild("HumanoidRootPart") then break end
		
		local direction = (targetCFrame.Position - hrp.Position).Unit
		local step = direction * (speed * dt)

		if (hrp.Position - targetCFrame.Position).Magnitude <= stopDistance then
			break
		else
			hrp.CFrame = CFrame.lookAt(hrp.Position + step, targetCFrame.Position)
		end
	end
end

local function stopFlying()
	if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local bv = Player.Character.HumanoidRootPart:FindFirstChild("FarmAntiGravity")
		if bv then bv:Destroy() end
	end
end

-- ==========================================
-- AUTO ATTACK & WEAPON HITBOX SPAM
-- ==========================================
local autoAttackActive = false
local fastAttackActiveUI = false

local function toggleAutoAttack(state)
	autoAttackActive = state
	if state then
		task.spawn(function()
			while autoAttackActive do
				task.wait(0.1)
				local char = Player.Character
				if char then
					local tool = char:FindFirstChildOfClass("Tool")
					if tool then
						pcall(function() tool:Activate() end)
					end
					pcall(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton1(Vector2.new(50, 50))
					end)
					pcall(function()
						VirtualInputManager:SendMouseButtonEvent(50, 50, 0, true, game, 1)
						VirtualInputManager:SendMouseButtonEvent(50, 50, 0, false, game, 1)
					end)
				end
			end
		end)
	end
end

fastAttackBtn.MouseButton1Click:Connect(function()
	fastAttackActiveUI = not fastAttackActiveUI
	if fastAttackActiveUI then
		fastAttackBtn.Text = "FastAttack ON"
		fastAttackBtn.TextColor3 = GREEN
		fastAttackBtn.BorderColor3 = GREEN
		toggleAutoAttack(true)
	else
		fastAttackBtn.Text = "FastAttack"
		fastAttackBtn.TextColor3 = PURPLE_TEXT
		fastAttackBtn.BorderColor3 = PURPLE_BORDER
		if not mobFarmActive then
			toggleAutoAttack(false)
		end
	end
end)

local function equipWeapon()
	if not Player.Character then return end
	local hasTool = Player.Character:FindFirstChildOfClass("Tool")
	if not hasTool then
		for _, tool in pairs(Player.Backpack:GetChildren()) do
			if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit") then
				Player.Character.Humanoid:EquipTool(tool)
				break
			end
		end
	end
end

-- ==========================================
-- CHEST FARM LOGIC
-- ==========================================
local chestFarmActive = false
local function isChest(obj)
	if obj:IsA("Model") or obj:IsA("Part") then
		if string.find(string.lower(obj.Name), "chest") then
			for _, child in pairs(obj:GetDescendants()) do
				if child:IsA("TouchTransmitter") then return true end
			end
		end
	end
	return false
end

local function startChestFarm()
	task.spawn(function()
		while chestFarmActive do
			task.wait()
			local char = Player.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
			local hrp = char.HumanoidRootPart
			local nearestChest, targetPartToTouch = nil, nil
			local shortestDistance = math.huge

			for _, obj in pairs(workspace:GetDescendants()) do
				if isChest(obj) then
					local touchPart = obj:IsA("BasePart") and obj:FindFirstChildWhichIsA("TouchTransmitter") and obj or nil
					if not touchPart then
						for _, child in pairs(obj:GetDescendants()) do
							if child:IsA("BasePart") and child:FindFirstChildWhichIsA("TouchTransmitter") then
								touchPart = child
								break
							end
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

			if nearestChest and targetPartToTouch then
				flyTo(targetPartToTouch.CFrame, 300, function() 
					return chestFarmActive and nearestChest.Parent ~= nil
				end, 3)
				if chestFarmActive and nearestChest.Parent and (hrp.Position - targetPartToTouch.Position).Magnitude <= 10 then
					if firetouchinterest then
						firetouchinterest(hrp, targetPartToTouch, 0)
						task.wait(0.05)
						firetouchinterest(hrp, targetPartToTouch, 1)
					else
						hrp.CFrame = targetPartToTouch.CFrame
					end
					task.wait(0.5)
				end
			else
				stopFlying()
				task.wait(1)
			end
		end
		stopFlying()
	end)
end

chestFarmBtn.MouseButton1Click:Connect(function()
	chestFarmActive = not chestFarmActive
	if chestFarmActive then
		mobFarmActive = false 
		mobFarmBtn.Text = "Mob Farm"
		mobFarmBtn.TextColor3 = PURPLE_TEXT
		mobFarmBtn.BorderColor3 = PURPLE_BORDER
		if not fastAttackActiveUI then toggleAutoAttack(false) end
		
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
		stopFlying()
	end
end)

-- ==========================================
-- MOB FARM LOGIC (FIXED QUESTS & NPC SEARCH)
-- ==========================================
mobFarmActive = false
local QuestList = {
	{LevelReq = 1500, MaxLevel = 1524, NPCName = "Pirate Port Quest Giver", QuestId = "PiratePortQuest", QuestNum = 1},
	{LevelReq = 1525, MaxLevel = 1574, NPCName = "Pirate Port Quest Giver", QuestId = "PiratePortQuest", QuestNum = 2},
	{LevelReq = 1575, MaxLevel = 1599, NPCName = "Amazon Quest Giver", QuestId = "AmazonQuest", QuestNum = 1},
	{LevelReq = 1600, MaxLevel = 1624, NPCName = "Amazon Quest Giver", QuestId = "AmazonQuest", QuestNum = 2},
	{LevelReq = 1625, MaxLevel = 1649, NPCName = "Amazon Quest Giver 2", QuestId = "AmazonQuest2", QuestNum = 1},
	{LevelReq = 1650, MaxLevel = 1699, NPCName = "Amazon Quest Giver 2", QuestId = "AmazonQuest2", QuestNum = 2},
	{LevelReq = 1700, MaxLevel = 1724, NPCName = "Marine Tree Island Quest Giver", QuestId = "MarineTreeIsland", QuestNum = 1},
	{LevelReq = 1725, MaxLevel = 1774, NPCName = "Marine Tree Island Quest Giver", QuestId = "MarineTreeIsland", QuestNum = 2},
	{LevelReq = 1775, MaxLevel = 1799, NPCName = "Deep Forest Island Quest Giver", QuestId = "DeepForestIsland", QuestNum = 1},
	{LevelReq = 1800, MaxLevel = 1849, NPCName = "Deep Forest Island Quest Giver", QuestId = "DeepForestIsland", QuestNum = 2},
	{LevelReq = 1850, MaxLevel = 1899, NPCName = "Deep Forest Island Quest Giver 2", QuestId = "DeepForestIsland2", QuestNum = 1},
	{LevelReq = 1900, MaxLevel = 1974, NPCName = "Deep Forest Island Quest Giver 2", QuestId = "DeepForestIsland2", QuestNum = 2},
	{LevelReq = 1975, MaxLevel = 1999, NPCName = "Deep Forest Island Quest Giver 3", QuestId = "DeepForestIsland3", QuestNum = 1},
	{LevelReq = 2000, MaxLevel = 2074, NPCName = "Deep Forest Island Quest Giver 3", QuestId = "DeepForestIsland3", QuestNum = 2},
	{LevelReq = 2075, MaxLevel = 2099, NPCName = "Haunted Quest Giver 1", QuestId = "HauntedQuest1", QuestNum = 1},
	{LevelReq = 2100, MaxLevel = 2124, NPCName = "Haunted Quest Giver 1", QuestId = "HauntedQuest1", QuestNum = 2},
	{LevelReq = 2125, MaxLevel = 2149, NPCName = "Haunted Quest Giver 2", QuestId = "HauntedQuest2", QuestNum = 1},
	{LevelReq = 2150, MaxLevel = 2199, NPCName = "Haunted Quest Giver 2", QuestId = "HauntedQuest2", QuestNum = 2},
	{LevelReq = 2200, MaxLevel = 2224, NPCName = "Peanut Island Quest Giver", QuestId = "NutsIslandQuest", QuestNum = 1},
	{LevelReq = 2225, MaxLevel = 2274, NPCName = "Peanut Island Quest Giver", QuestId = "NutsIslandQuest", QuestNum = 2},
	{LevelReq = 2275, MaxLevel = 2299, NPCName = "Ice Cream Island Quest Giver", QuestId = "IceCreamIslandQuest", QuestNum = 1},
	{LevelReq = 2300, MaxLevel = 2349, NPCName = "Ice Cream Island Quest Giver", QuestId = "IceCreamIslandQuest", QuestNum = 2},
	{LevelReq = 2350, MaxLevel = 2374, NPCName = "Cake Quest Giver 1", QuestId = "CakeQuest1", QuestNum = 1},
	{LevelReq = 2375, MaxLevel = 2399, NPCName = "Cake Quest Giver 1", QuestId = "CakeQuest1", QuestNum = 2},
	{LevelReq = 2400, MaxLevel = 2424, NPCName = "Cake Quest Giver 2", QuestId = "CakeQuest2", QuestNum = 1},
	{LevelReq = 2425, MaxLevel = 2449, NPCName = "Cake Quest Giver 2", QuestId = "CakeQuest2", QuestNum = 2},
	{LevelReq = 2450, MaxLevel = 2474, NPCName = "Choc Quest Giver 1", QuestId = "ChocQuest1", QuestNum = 1},
	{LevelReq = 2475, MaxLevel = 2499, NPCName = "Choc Quest Giver 1", QuestId = "ChocQuest1", QuestNum = 2},
	{LevelReq = 2500, MaxLevel = 2524, NPCName = "Choc Quest Giver 2", QuestId = "ChocQuest2", QuestNum = 1},
	{LevelReq = 2525, MaxLevel = 2549, NPCName = "Choc Quest Giver 2", QuestId = "ChocQuest2", QuestNum = 2},
	{LevelReq = 2550, MaxLevel = 2574, NPCName = "Tiki Quest Giver 1", QuestId = "TikiIslandQuest1", QuestNum = 1},
	{LevelReq = 2575, MaxLevel = 2599, NPCName = "Tiki Quest Giver 1", QuestId = "TikiIslandQuest1", QuestNum = 2},
	{LevelReq = 2600, MaxLevel = 3000, NPCName = "Tiki Quest Giver 2", QuestId = "TikiIslandQuest2", QuestNum = 1},
}

local function getQuestDataForLevel(playerLevel)
	local bestQuest = QuestList[1]
	for _, quest in ipairs(QuestList) do
		if playerLevel >= quest.LevelReq and playerLevel <= quest.MaxLevel then
			bestQuest = quest
		end
	end
	return bestQuest
end

local function findNPC(npcName)
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == npcName and obj:FindFirstChild("HumanoidRootPart") then
			return obj
		end
	end
	return nil
end

local function startMobFarm()
	task.spawn(function()
		while mobFarmActive do
			task.wait()
			local char = Player.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
			
			local playerLevel = 1
			if Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Level") then
				playerLevel = Player.Data.Level.Value
			end

			local questGui = PlayerGui.Main:FindFirstChild("Quest")
			
			if not questGui or not questGui.Visible then
				local targetQuest = getQuestDataForLevel(playerLevel)
				local npc = findNPC(targetQuest.NPCName)
				
				if npc and npc:FindFirstChild("HumanoidRootPart") then
					flyTo(npc.HumanoidRootPart.CFrame, 300, function()
						return mobFarmActive and (not questGui or not questGui.Visible)
					end, 4)
					
					if mobFarmActive and (not questGui or not questGui.Visible) then
						pcall(function()
							ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", targetQuest.QuestId, targetQuest.QuestNum)
						end)
						task.wait(1)
					end
				else
					task.wait(0.5)
				end
			else
				local success, questTitle = pcall(function() return string.lower(questGui.Container.QuestTitle.Title.Text) end)
				if not success then continue end
				
				local targetEnemy = nil
				local shortestDist = math.huge
				
				if workspace:FindFirstChild("Enemies") then
					for _, enemy in pairs(workspace.Enemies:GetChildren()) do
						if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
							local cleanName = string.lower(enemy.Name):gsub(" %[%w+%. %d+%]", "")
							if string.find(questTitle, cleanName) then
								local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
								if dist < shortestDist then
									shortestDist = dist
									targetEnemy = enemy
								end
							end
						end
					end
				end
				
				if targetEnemy then
					local farmCFrame = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
					
					flyTo(farmCFrame, 300, function()
						return mobFarmActive and targetEnemy and targetEnemy:FindFirstChild("Humanoid") and targetEnemy.Humanoid.Health > 0
					end, 3)
					
					if targetEnemy and targetEnemy:FindFirstChild("Humanoid") and targetEnemy.Humanoid.Health > 0 then
						equipWeapon()
						char.HumanoidRootPart.CFrame = farmCFrame * CFrame.Angles(-math.rad(80), 0, 0)
					end
				else
					stopFlying()
					task.wait(1)
				end
			end
		end
		stopFlying()
	end)
end

mobFarmBtn.MouseButton1Click:Connect(function()
	mobFarmActive = not mobFarmActive
	if mobFarmActive then
		chestFarmActive = false 
		chestFarmBtn.Text = "Chest Farm"
		chestFarmBtn.TextColor3 = PURPLE_TEXT
		chestFarmBtn.BorderColor3 = PURPLE_BORDER
		
		mobFarmBtn.Text = "Mob Farm ON"
		mobFarmBtn.TextColor3 = GREEN
		mobFarmBtn.BorderColor3 = GREEN
		
		toggleNoclip(true)
		toggleAutoAttack(true)
		startMobFarm()
	else
		mobFarmBtn.Text = "Mob Farm"
		mobFarmBtn.TextColor3 = PURPLE_TEXT
		mobFarmBtn.BorderColor3 = PURPLE_BORDER
		
		toggleNoclip(false)
		if not fastAttackActiveUI then
			toggleAutoAttack(false)
		end
		stopFlying()
	end
end)

-- ==========================================
-- WEAPON HITBOX ACCURATE LOGIC
-- ==========================================
local hitboxActive = false
local HITBOX_SIZE = Vector3.new(30, 30, 30)

local function startHitboxLoop()
	task.spawn(function()
		while hitboxActive do
			local char = Player.Character
			if char then
				local tool = char:FindFirstChildOfClass("Tool")
				if tool then
					for _, part in pairs(tool:GetDescendants()) do
						if part:IsA("BasePart") then
							part.Size = HITBOX_SIZE
							part.Transparency = 0.8
							part.CanCollide = false
							part.Massless = true
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end

hitboxBtn.MouseButton1Click:Connect(function()
	hitboxActive = not hitboxActive
	if hitboxActive then
		hitboxBtn.Text = "Hitbox Accurate ON"
		hitboxBtn.TextColor3 = GREEN
		hitboxBtn.BorderColor3 = GREEN
		startHitboxLoop()
	else
		hitboxBtn.Text = "Hitbox Accurate"
		hitboxBtn.TextColor3 = PURPLE_TEXT
		hitboxBtn.BorderColor3 = PURPLE_BORDER
	end
end)
