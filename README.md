# DDW-Light-Effects
Dual Universe Light Effects

# Description
Simple script to provide lighting effects for a series of connected lights.  The script will auto-discover all connected lights. **Do not rename the slots.**  The order of connection will determine the cycle order for future effects.  The colors used by effects are defined by a two dimensional array called **colorList** defined in unit.tick().  The first index, called the colorListIndex, represents a specific array of colors to use. The second index is the color in this array.  In this way, you can define as many color lists as you like.  Most effects take the colorListIndex as their first parameter.

## Modes
### 1 - StaticUnified
All lights set to a static color defined by the first color of colorList[1]
### 2 - StaticIndividual
All lights individually set to the colors defined by colorList[1].  Make sure you have a color definded for each connected light.
### 3 - RandomUnified
All lights set to the same random color
### 4 - RandomIndividual
All lights individually set to a random color
### 5 - BreathUified
All lights fade and brighten like breathing.  The minimum and maximum brightness of the breath is determined by overall brightness and the breathmin/breathmax values. A speed value of around 0.01 is needed to notice this effect.  The color used is defined by the first color of colorList[1]
### 6 - ColorListCycle
All lights cycle between the colors specified by colorList[2].
### 7 - ColorListRandomUnified
All lights set to the same color randomly picked from colorList[2]
### 8 - ColorListRandomIndividual
All lights individually set to a color randomly picked from colorList[2]
### 9 - Race
A set number of lights specified by raceSize will race around the lights in the order of connection.  The OFF/ON colors are set by first two colors defined by colorList[2].
### 10 - Animate
Animate the light colors.  Modify the animateColor() function to return the color for a light at a specific step.

# Installation
## Requirements
1. 1xProgramming board
2. Up to 10 lights to control
3. The code will auto-discover the connected lights

## Using the Export
Copy the export file to your clipboard. This file can be found in this Github repo under Releases->\<version\>->Assets and has the filename format: DDW-Light-Effects-Export-\<version\>.json.  Right click your programming board and select Advanced -> Paste Lua configuration from Clipboard.

# Manual installation
Connect the programming board to the lights in the order you would have them cycle. **Do not rename the slots**

On your Programming Board:
1. create a unit.start() filter and paste the code from unit-start.lua
2. Create a unit.stop() filter and paste the code from unit-stop.lua
3. Create a unit.tick() filter named "Live" and paste the code from DDW-Light-Effects.lua
4. Create a Library.start() filter and paste the code from library-start.lua


# Lua Parameters
* seed: Random number seed
* speed: Speed of timer in Sec
* stepDelta: Step increment for time based effects (i.e. Breath). Higher values equal chunkier steps.
* mode: Light effects mode: 1=StaticUnified, 2=StaticIndividual, 3=RandomUnified, 4=RandomIndividual, 5=BreathUnified (good with speed 0.01), 6=ColorListCycle, 7=ColorListRandomUnified, 8=ColorListRandomIndividual, 9=Race, 10=Animate
* brighness: Brightness multiplier for lights (0-1)
* breathmin: Minimum breath multiplier (0-1). Works in conjunction with brighness.
* breathmax: Maximum breath multiplier (0-1). Works in conjunction with brighness.
* raceSize: Number of lights for race mode