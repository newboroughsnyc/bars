# Roblox Health, Hunger & Stamina Bar System

A comprehensive bar system for Roblox games featuring Health, Hunger, and Stamina bars with visual feedback.

## Features

- **Health Bar**: Green/Yellow/Red color coding based on health level
- **Hunger Bar**: Drains over time, causes health loss when empty
- **Stamina Bar**: Drains while running, regenerates when idle
- **Visual GUI**: Clean, modern bar display at top of screen
- **Easy Integration**: Simple module system for any Roblox game

## Files

- `HealthBar.lua` - Health system with damage and healing
- `HungerBar.lua` - Hunger system with automatic draining
- `StaminaBar.lua` - Stamina system with drain/regen based on movement
- `BarManager.lua` - Coordinates all three systems

## Installation - IMPORTANT: File Placement

### 📁 Step-by-Step Setup:

#### **Step 1: Create the BarSystem Folder**
1. Open **Roblox Studio**
2. In the **Explorer** window on the right, locate **ServerScriptService**
3. Right-click on **ServerScriptService** → **Insert Object** → **Folder**
4. Name the folder **BarSystem**

```
ServerScriptService
└── BarSystem
```

#### **Step 2: Add the Module Scripts**
1. Right-click on the **BarSystem** folder → **Insert Object** → **ModuleScript**
2. Create and name each file exactly as follows:

| File Name | Contents |
|-----------|----------|
| **HealthBar** | Copy contents from `HealthBar.lua` |
| **HungerBar** | Copy contents from `HungerBar.lua` |
| **StaminaBar** | Copy contents from `StaminaBar.lua` |
| **BarManager** | Copy contents from `BarManager.lua` |

Final structure:
```
ServerScriptService
└── BarSystem
    ├── HealthBar (ModuleScript)
    ├── HungerBar (ModuleScript)
    ├── StaminaBar (ModuleScript)
    └── BarManager (ModuleScript)
```

#### **Step 3: Create a LocalScript for Testing**
1. In **StarterPlayer** → **StarterPlayerScripts**, create a new **LocalScript**
2. Paste this code:

```lua
local BarManager = require(game.ServerScriptService.BarSystem.BarManager)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create bars for the player
local barManager = BarManager.new(character)

-- Test the bars
print("Bars created!")
```

3. **Play** the game - you should see three bars at the top of your screen!

### 📍 Visual Guide - Roblox Studio Explorer:

```
Explorer
├── StarterPlayer
│   ├── StarterCharacterScripts
│   ├── StarterPlayerScripts
│   │   └── LocalScript (your test script here)
│   └── ...
├── ServerScriptService
│   └── BarSystem ⭐ (CREATE THIS FOLDER)
│       ├── HealthBar ⭐ (ModuleScript)
│       ├── HungerBar ⭐ (ModuleScript)
│       ├── StaminaBar ⭐ (ModuleScript)
│       └── BarManager ⭐ (ModuleScript)
└── ...
```

## Usage

### Basic Setup in LocalScript

```lua
local BarManager = require(game.ServerScriptService.BarSystem.BarManager)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local barManager = BarManager.new(character)

-- Take damage
barManager:TakeDamage(10)

-- Heal
barManager:Heal(15)

-- Feed
barManager:Feed(20)

-- Use stamina for actions
if barManager:UseStamina(25) then
    print("Stamina used successfully!")
else
    print("Not enough stamina!")
end

-- Get all stats
local stats = barManager:GetStats()
print("Health:", stats.health)
print("Hunger:", stats.hunger)
print("Stamina:", stats.stamina)
```

### Individual Bar Usage

```lua
local HealthBar = require(game.ServerScriptService.BarSystem.HealthBar)

local healthBar = HealthBar.new(character, 100)

-- Damage player
healthBar:Damage(20)

-- Heal player
healthBar:Heal(15)

-- Get current health
print(healthBar:GetHealth())
```

## Customization

### HealthBar
```lua
healthBar:SetMaxHealth(150) -- Increase max health
```

### HungerBar
```lua
hungerBar:SetHungerRate(1.0) -- Drain faster (default 0.5)
hungerBar:Eat(30) -- Feed the player
```

### StaminaBar
```lua
staminaBar:SetDrainRate(20) -- Drain faster when running
staminaBar:SetRegenRate(8) -- Regen faster when idle
staminaBar:UseStamina(30) -- Use stamina for actions
```

## Color Coding

### Health Bar
- **Green**: Above 50% health
- **Yellow**: 25-50% health
- **Red**: Below 25% health

### Hunger Bar
- **Orange**: Above 50% hunger
- **Dark Orange**: 25-50% hunger
- **Red**: Below 25% hunger (starving)

### Stamina Bar
- **Blue**: Above 50% stamina
- **Yellow**: 25-50% stamina
- **Red**: Below 25% stamina

## Troubleshooting

**"Bars not showing up?"**
- Make sure you created the `BarSystem` folder in `ServerScriptService`
- Check that all 4 modules are inside the folder
- Verify the LocalScript is in `StarterPlayer > StarterPlayerScripts`

**"Error: Cannot find module?"**
- Double-check the file paths in your `require()` statements
- Make sure module names match exactly (case-sensitive on some systems)

**"Bars in wrong position?"**
- The bars automatically stack vertically
- Health: Top (Y=10)
- Hunger: Middle (Y=40)
- Stamina: Bottom (Y=70)

## Notes

- Bars automatically update position to avoid overlap
- Hunger affects health (starvation causes damage)
- Stamina drains based on player speed (>20 studs/sec = sprinting)
- All values are customizable for your game's balance
