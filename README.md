# DDW-Light-Effects
Dual Universe Light Effects

# Description
Simple script to provide lighting effects for a series of connected lights.  The script will auto-discover all connected lights. **Do not rename the slots.**  The order of connection will determine the cycle order for future effects.

# Installation
## Requirements
1. 1xProgramming board
2. Up to 10 lights to control
3. The code will auto-discover the connected lights

## Using the Export
Copy the export file to your clipboard. Right click your programming board an select Advanced -> Paste Lua configuration from Clipboard.

# Manual installation
Connect the programming board to the lights in the order you would have them cycle (not yet implemented).

On your Programming Board:
1. create a unit.start() filter and paste the code from unit-start.lua
2. Create a unit.stop() filter and paste the code from unit-stop.lua
3. Create a unit.tick() filter named "Live" and paste the contents of DDW-Light-Effects.lua


# Lua Parameters
* seed: Random number seed
* speed: Speed of timer in Sec
* stepDelta: Step increment for effects that happen over time (i.e. Breath). Higher values equal chunkier steps.
* mode: Light effects mode: 1=Static, 2=RandomUnified, 3=RandomIndividual, 4=Breath (good with speed 0.01)
* brighness: Brightness of lights (0-1)
* red: Light Red value
* green: Light Green value
* blue: Light Blue value
* breathmin: Minimum breath multiplier (0-1). Works in conjunction with brighness.
* breathmax: Maximum breath multiplier (0-1). Works in conjunction with brighness.
