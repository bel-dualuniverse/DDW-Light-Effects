-- DDW-Light-Effects
-- v0.3

-- Code for unit.tick("Live")
-- Exports
local stepDelta  = 0.012 --export: step increment for effects that happen over time (i.e. Breath)
local mode       = 1     --export: Light mode. 1=Static, 2=Random, 3=RandomUnified, 4=Breath (good with speed 0.01), 5=ColorListCycle, 6=ColorListRandom, 7=ColorListRandomUnified
local brightness = 1     --export: brightness of lights (0-1)
local red        = 255   --export: red
local green      = 255   --export: green
local blue       = 255   --export: blue
local breathmin  = 0.25  --export: min breath multiplier (0-1). Works in conjunction with brighness.
local breathmax  = 1     --export: max breath multiplier (0-1). Works in conjunction with brighness.

-- List of colors to cycle through or pick from.
-- Add any number of colors you like.
local colorList = {
    {r = 255, g = 0, b = 0},
    {r = 0, g = 255, b = 0},
    {r = 0, g = 0, b = 255}
}
local numColorList = tablelen(colorList)

step = step + stepDelta

-- Build the call table
local c_tbl = {
    [1] = static,
    [2] = randomIndividual,
    [3] = randomUnified,
    [4] = breath,
    [5] = colorListCycle,
    [6] = colorListRandomIndividual,
    [7] = colorListRandomUnified
}

-- Call the function based on mode
local func = c_tbl[mode]
if (func) then
    func()
end

function colorListNext()
    colorStep = colorStep + 1
    if colorStep > numColorList then colorStep = 1 end
    return colorList[colorStep]
end

function colorListRandom()
    local color = math.random(1, numColorList)
    
    -- Prevent the same color from being selected again this step.
    -- That just looks bad.
    while color == colorLast do
        color = math.random(1, numColorList)
    end
    
    colorLast = color
    return colorList[color]
end

function static()
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(red * brightness, green * brightness, blue * brightness)
    end
end

function randomUnified()
    local rndR = math.random(0, math.floor(255 * brightness))
    local rndG = math.random(0, math.floor(255 * brightness))
    local rndB = math.random(0, math.floor(255 * brightness))
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(rndR, rndG, rndB)
    end
end

function randomIndividual()
    for i = 1, numLights do
        local rndR = math.random(0, math.floor(255 * brightness))
        local rndG = math.random(0, math.floor(255 * brightness))
        local rndB = math.random(0, math.floor(255 * brightness))
        lights[keys[i]].setRGBColor(rndR, rndG, rndB)
    end
end

function breath()
    local mag = (math.sin(math.pi * step) + 1) * 0.5
    local mul = breathmin + (breathmax - breathmin) * mag
    for i = 1, numLights do
        local r = red * brightness * mul
        local g = green * brightness * mul
        local b = blue * brightness * mul
        lights[keys[i]].setRGBColor(r, g, b)
    end
end

function colorListCycle()
    local color = colorListNext()
    local r = color.r * brightness
    local g = color.g * brightness
    local b = color.b * brightness
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(r, g, b)
    end
end

function colorListRandomIndividual()
    for i = 1, numLights do
        local color = colorListRandom()
        local r = color.r * brightness
        local g = color.g * brightness
        local b = color.b * brightness
        lights[keys[i]].setRGBColor(r, g, b)
    end
end

function colorListRandomUnified()
    local color = colorListRandom()
    local r = color.r * brightness
    local g = color.g * brightness
    local b = color.b * brightness
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(r, g, b)
    end
end
