-- StaminaBar.lua
-- Stamina Bar System for Roblox

local StaminaBar = {}
StaminaBar.__index = StaminaBar

-- Constructor
function StaminaBar.new(character, maxStamina)
	local self = setmetatable({}, StaminaBar)
	
	self.character = character
	self.maxStamina = maxStamina or 100
	self.currentStamina = self.maxStamina
	self.drainRate = 15 -- Stamina drain per second when sprinting
	self.regenRate = 5 -- Stamina regen per second when idle
	self.isRunning = false
	
	-- Create the GUI
	self:CreateGui()
	
	-- Start stamina regen loop
	self:StartStaminaLoop()
	
	return self
end

-- Create the stamina bar GUI
function StaminaBar:CreateGui()
	local player = game:GetService("Players"):GetPlayerFromCharacter(self.character)
	if not player then return end
	
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Find or create container
	local screenGui = playerGui:FindFirstChild("BarContainer")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "BarContainer"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui
	end
	
	-- Create background frame - BOTTOM LEFT POSITION
	local bgFrame = Instance.new("Frame")
	bgFrame.Name = "StaminaBarBackground"
	bgFrame.Size = UDim2.new(0, 80, 0, 80)
	bgFrame.Position = UDim2.new(0, 10, 1, -270)
	bgFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
	bgFrame.BorderSizePixel = 2
	bgFrame.BorderColor3 = Color3.fromRGB(0, 100, 200)
	bgFrame.Parent = screenGui
	
	-- Create text label
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "StaminaText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "⚡"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 40
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = bgFrame
	
	self.gui = {
		screenGui = screenGui,
		bgFrame = bgFrame,
		textLabel = textLabel
	}
end

-- Start stamina regen/drain loop
function StaminaBar:StartStaminaLoop()
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
		if not self.character.Parent then
			connection:Disconnect()
			return
		end
		
		-- Check if player is moving
		local humanoidRootPart = self.character:FindFirstChild("HumanoidRootPart")
		local humanoid = self.character:FindFirstChild("Humanoid")
		
		if humanoid and humanoidRootPart then
			local currentSpeed = humanoidRootPart.Velocity.Magnitude
			
			-- Drain stamina if moving fast (sprinting)
			if currentSpeed > 20 then
				self:Drain(self.drainRate * deltaTime)
			else
				-- Regenerate stamina when idle
				self:Regenerate(self.regenRate * deltaTime)
			end
		end
		
		self:UpdateBar()
	end)
end

-- Drain stamina
function StaminaBar:Drain(amount)
	self.currentStamina = math.max(0, self.currentStamina - amount)
end

-- Regenerate stamina
function StaminaBar:Regenerate(amount)
	self.currentStamina = math.min(self.maxStamina, self.currentStamina + amount)
end

-- Use stamina (for actions like jumping)
function StaminaBar:UseStamina(amount)
	if self.currentStamina >= amount then
		self.currentStamina = self.currentStamina - amount
		self:UpdateBar()
		return true
	end
	return false
end

-- Update the bar visually
function StaminaBar:UpdateBar()
	if not self.gui then return end
	
	local staminaPercentage = self.currentStamina / self.maxStamina
	
	-- Change color based on stamina level
	if staminaPercentage > 0.5 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(0, 100, 200)
	elseif staminaPercentage > 0.25 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0) -- Yellow
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(200, 150, 0)
	else
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
	end
	
	self.gui.textLabel.Text = "⚡"
end

-- Get current stamina
function StaminaBar:GetStamina()
	return self.currentStamina
end

-- Set drain rate
function StaminaBar:SetDrainRate(rate)
	self.drainRate = rate
end

-- Set regeneration rate
function StaminaBar:SetRegenRate(rate)
	self.regenRate = rate
end

-- Destroy the bar
function StaminaBar:Destroy()
	if self.gui and self.gui.screenGui then
		self.gui.screenGui:Destroy()
	end
end

return StaminaBar