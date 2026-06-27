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
		-- Update health when humanoid takes damage
		humanoid.HealthChanged:Connect(function(health)
			self.currentHealth = health
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
	bgFrame.Name = "HealthBarBackground"
	bgFrame.Size = UDim2.new(0, 80, 0, 80)
	bgFrame.Position = UDim2.new(0, 10, 1, -180)
	bgFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Green
	bgFrame.BorderSizePixel = 2
	bgFrame.BorderColor3 = Color3.fromRGB(0, 150, 0)
	bgFrame.Parent = screenGui
	
	-- Create text label
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "HealthText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "❤️"
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
	
	-- Change color based on health
	if healthPercentage > 0.5 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Green
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(0, 150, 0)
	elseif healthPercentage > 0.25 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(200, 200, 0)
	else
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
	end
	
	self.gui.textLabel.Text = "❤️"
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