# DDW-Light-Effects
Dual Universe Light Effects

# Description
Simple script to provide lighting effects for a series of connected lights.  The script will auto-discover all connected lights. **Do not rename the slots.**  The order of connection will determine the cycle order for future effects.

## Modes
### 1 - Static
All lights set to a static color defined by r, g, and b Lua parameters.
### 2 - Random
All lights individually set to a random color
### 3 - RandomUnified
All lights set to the same random color
### 4 - Breath
All lights fade and brighten like breathing.  The minimum and maximum brightness of the breath is determined by overall brightness and the breathmin/breathmax values. A speed value of around 0.01 is needed to notice this effect.
### 5 - ColorListCycle
All lights cycle between the colors specified in the colorList table in the Lua code located under unit.tick().
### 6 - ColorListRandom
All lights individually set to a color randomly picked from the colorList table located in the Lua code under unit.tick()
### 7 - ColorListRandomUnified
All lights set to the same color randomly picked from the colorList table located in the Lua code under unit.tick()
### 8 - Race
A set number of lights specified by raceSize will race around the lights in the order of connection.  The OFF/ON colors are set by colorList[0] and colorList[1].
### 9 - Animate
Animate the light colors.  Modify the animateColor() function to return the color for a light at a specific step.

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
3. Create a unit.tick() filter named "Live" and paste the code from DDW-Light-Effects.lua
4. Create a Library.start() filter and paste the code from library-start.lua


# Lua Parameters
* seed: Random number seed
* speed: Speed of timer in Sec
* stepDelta: Step increment for time based effects (i.e. Breath). Higher values equal chunkier steps.
* mode: Light effects mode: 1=Static, 2=Random, 3=RandomUnified, 4=Breath (good with speed 0.01), 5=ColorListCycle, 6=ColorListRandom, 7=ColorListRandomUnified, 8=Race, 9=Animate
* brighness: Brightness multiplier for lights (0-1)
* red: Light Red value
* green: Light Green value
* blue: Light Blue value
* breathmin: Minimum breath multiplier (0-1). Works in conjunction with brighness.
* breathmax: Maximum breath multiplier (0-1). Works in conjunction with brighness.
* raceSize: Number of lights for race mode