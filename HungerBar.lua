-- HungerBar.lua
-- Hunger Bar System for Roblox

local HungerBar = {}
HungerBar.__index = HungerBar

-- Constructor
function HungerBar.new(character, maxHunger)
	local self = setmetatable({}, HungerBar)
	
	self.character = character
	self.maxHunger = maxHunger or 100
	self.currentHunger = self.maxHunger
	self.hungerRate = 0.02 -- MUCH SLOWER - Hunger decreases over time
	self.lastUpdateTime = tick()
	
	-- Create the GUI
	self:CreateGui()
	
	-- Start hunger drain
	self:StartHungerDrain()
	
	-- Update bar on creation
	self:UpdateBar()
	
	return self
end

-- Create the hunger bar GUI
function HungerBar:CreateGui()
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
	bgFrame.Name = "HungerBarBackground"
	bgFrame.Size = UDim2.new(0, 80, 0, 80)
	bgFrame.Position = UDim2.new(0, 10, 1, -90)
	bgFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange
	bgFrame.BorderSizePixel = 2
	bgFrame.BorderColor3 = Color3.fromRGB(255, 100, 0)
	bgFrame.Parent = screenGui
	
	-- Create text label
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "HungerText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "🍖"
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

-- Start hunger draining over time
function HungerBar:StartHungerDrain()
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
		if not self.character.Parent then
			connection:Disconnect()
			return
		end
		
		self.currentHunger = math.max(0, self.currentHunger - (self.hungerRate * deltaTime))
		self:UpdateBar()
	end)
end

-- Eat food
function HungerBar:Eat(amount)
	self.currentHunger = math.min(self.maxHunger, self.currentHunger + amount)
	self:UpdateBar()
end

-- Take hunger damage (starvation)
function HungerBar:Starve()
	if self.currentHunger <= 0 then
		if self.character:FindFirstChild("Humanoid") then
			self.character.Humanoid:TakeDamage(5)
		end
	end
end

-- Update the bar visually
function HungerBar:UpdateBar()
	if not self.gui then return end
	
	local hungerPercentage = self.currentHunger / self.maxHunger
	
	-- Change color and border based on hunger level
	if hungerPercentage > 0.5 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange - Full
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(255, 100, 0)
	elseif hungerPercentage > 0.25 then
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 0) -- Dark Orange - Medium
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(255, 50, 0)
	else
		self.gui.bgFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red - Low
		self.gui.bgFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
	end
	
	self.gui.textLabel.Text = "🍖"
end

-- Get current hunger
function HungerBar:GetHunger()
	return self.currentHunger
end

-- Set hunger rate (how fast it drains)
function HungerBar:SetHungerRate(rate)
	self.hungerRate = rate
end

-- Destroy the bar
function HungerBar:Destroy()
	if self.gui and self.gui.screenGui then
		self.gui.screenGui:Destroy()
	end
end

return HungerBar