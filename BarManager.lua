-- BarManager.lua
-- Manages all bars (Health, Hunger, Stamina) for a player

local HealthBar = require(script.Parent.HealthBar)
local HungerBar = require(script.Parent.HungerBar)
local StaminaBar = require(script.Parent.StaminaBar)

local BarManager = {}
BarManager.__index = BarManager

-- Constructor
function BarManager.new(character)
	local self = setmetatable({}, BarManager)
	
	self.character = character
	self.healthBar = HealthBar.new(character, 100)
	self.hungerBar = HungerBar.new(character, 100)
	self.staminaBar = StaminaBar.new(character, 100)
	
	-- Start hunger affecting health
	self:StartHungerLoop()
	
	return self
end

-- Hunger affects health when starving
function BarManager:StartHungerLoop()
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		if not self.character.Parent then
			connection:Disconnect()
			return
		end
		
		-- If hunger is 0, lose health
		if self.hungerBar:GetHunger() <= 0 then
			self.healthBar:Damage(0.1)
		end
	end)
end

-- Get all bar information
function BarManager:GetStats()
	return {
		health = self.healthBar:GetHealth(),
		maxHealth = self.healthBar.maxHealth,
		hunger = self.hungerBar:GetHunger(),
		maxHunger = self.hungerBar.maxHunger,
		stamina = self.staminaBar:GetStamina(),
		maxStamina = self.staminaBar.maxStamina
	}
end

-- Damage the player
function BarManager:TakeDamage(amount)
	self.healthBar:Damage(amount)
end

-- Heal the player
function BarManager:Heal(amount)
	self.healthBar:Heal(amount)
end

-- Feed the player
function BarManager:Feed(amount)
	self.hungerBar:Eat(amount)
end

-- Use stamina
function BarManager:UseStamina(amount)
	return self.staminaBar:UseStamina(amount)
end

-- Clean up all bars
function BarManager:Destroy()
	self.healthBar:Destroy()
	self.hungerBar:Destroy()
	self.staminaBar:Destroy()
end

return BarManager