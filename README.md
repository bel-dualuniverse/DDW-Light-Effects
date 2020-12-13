# DDW-Light-Effects
Dual Universe Light Effects

# Installation
## Requirements
1. 1xProgramming board
2. Up to 10 lights to control
3. The code will auto-discover the connected lights

## Using the Export
Copy the export file to your clipboard. Right click your programming board an select Advanced -> Paste Lua configuration from Clipboard.

## Manual installation
Connect the programming board to the lights.

On your Programming Board, create a unit.start() filter and add the following code:
```Lua
-- Code for unit.start()
local seed  = 17   --export: random number seed
local speed = 0.5  --export: speed of change
step = 0
math.randomseed(seed)
unit.setTimer("Live", speed)

```

Create a unit.tick() filter named "Live" and paste the contents of DDW-Light-Effects.lua

## Lua Parameters
* seed: Random number seed
* speed: Rate of light change
* mode: Light effects mode: 1=Static, 2=RandomUnified, 3=RandomIndividual, 4=Breath
* brighness: Brightness of lights (0-1)
* Red: Light Red value
* Green: Light Green value
* Blue: Light Blue value
* breathmin: Minimum breath multiplier (0-1)
* breathmax: Maximum breath multiplier (0-1)
