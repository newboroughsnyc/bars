-- HealthBar.lua
-- Health Bar System for Roblox

local HealthBar = {}
HealthBar.__index = HealthBar

-- Constructor
function HealthBar.new(character, maxHealth)
	local self = setmetatable({}, HealthBar)
	
	self.character = character
	self.maxHealth = maxHealth or 100
	self.currentHealth = self.maxHealth
	self.isAlive = true
	
	-- Create the GUI
	self:CreateGui()
	
	-- Connect to humanoid death
	if character:FindFirstChild("Humanoid") then
		local humanoid = character.Humanoid
		humanoid.Died:Connect(function()
			self.isAlive = false
			self:UpdateBar()
		end)
	end
	
	return self
end

-- Create the health bar GUI
function HealthBar:CreateGui()
	local player = game:GetService("Players"):GetPlayerFromCharacter(self.character)
	if not player then return end
	
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HealthBarGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Create background frame
	local bgFrame = Instance.new("Frame")
	bgFrame.Name = "HealthBarBackground"
	bgFrame.Size = UDim2.new(0, 200, 0, 25)
	bgFrame.Position = UDim2.new(0.5, -100, 0, 10)
	bgFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	bgFrame.BorderSizePixel = 2
	bgFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	bgFrame.Parent = screenGui
	
	-- Create health bar
	local healthBar = Instance.new("Frame")
	healthBar.Name = "HealthBar"
	healthBar.Size = UDim2.new(1, 0, 1, 0)
	healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = bgFrame
	
	-- Create text label
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "HealthText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = self.currentHealth .. "/" .. self.maxHealth
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = bgFrame
	
	self.gui = {
		screenGui = screenGui,
		bgFrame = bgFrame,
		healthBar = healthBar,
		textLabel = textLabel
	}
end

-- Damage the player
function HealthBar:Damage(amount)
	if not self.isAlive then return end
	
	self.currentHealth = math.max(0, self.currentHealth - amount)
	
	if self.currentHealth <= 0 then
		self.isAlive = false
		if self.character:FindFirstChild("Humanoid") then
			self.character.Humanoid:TakeDamage(self.character.Humanoid.Health)
		end
	end
	
	self:UpdateBar()
end

-- Heal the player
function HealthBar:Heal(amount)
	if not self.isAlive then return end
	
	self.currentHealth = math.min(self.maxHealth, self.currentHealth + amount)
	self:UpdateBar()
end

-- Update the bar visually
function HealthBar:UpdateBar()
	if not self.gui then return end
	
	local healthPercentage = self.currentHealth / self.maxHealth
	self.gui.healthBar.Size = UDim2.new(healthPercentage, 0, 1, 0)
	
	-- Change color based on health
	if healthPercentage > 0.5 then
		self.gui.healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
	elseif healthPercentage > 0.25 then
		self.gui.healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
	else
		self.gui.healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
	end
	
	self.gui.textLabel.Text = math.floor(self.currentHealth) .. "/" .. self.maxHealth
end

-- Get current health
function HealthBar:GetHealth()
	return self.currentHealth
end

-- Set maximum health
function HealthBar:SetMaxHealth(amount)
	self.maxHealth = amount
	self.currentHealth = amount
	self:UpdateBar()
end

-- Destroy the bar
function HealthBar:Destroy()
	if self.gui and self.gui.screenGui then
		self.gui.screenGui:Destroy()
	end
end

return HealthBar