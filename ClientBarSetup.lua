-- ClientBarSetup.lua
-- Place this in StarterPlayer > StarterPlayerScripts
-- This script runs on the CLIENT and creates the bars for each player

local BarManager = require(game.ReplicatedStorage:WaitForChild("BarSystem"):WaitForChild("BarManager"))

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

print("Creating bars for player: " .. player.Name)
print("Character: " .. character.Name)

-- Create the bar manager
local barManager = BarManager.new(character)

print("Bars created successfully!")

-- Optional: Test the bars
wait(2)
barManager:TakeDamage(10)
print("Took 10 damage!")

wait(2)
barManager:Feed(20)
print("Fed 20 hunger!")

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	print("Character respawned, creating new bars...")
	barManager = BarManager.new(character)
end)