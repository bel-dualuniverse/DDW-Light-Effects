-- Code for unit.tick("Live")
-- Exports
local stepDelta  = 0.012 --export: step increment for effects that happen over time (i.e. Breath)
local mode       = 3     --export: Light mode. 1=Static, 2=Random Unified, 3=Random Individual, 4=Breath (good with speed 0.01)
local brightness = 1     --export: brightness of lights (0-1)
local red        = 255   --export: red
local green      = 255   --export: green
local blue       = 255   --export: blue
local breathmin  = 0.25  --export: min breath multiplier (0-1). Works in conjunction with brighness.
local breathmax  = 1     --export: max breath multiplier (0-1). Works in conjunction with brighness.

step = step + stepDelta

-- Build the call table
local c_tbl = {
    [1] = static,
    [2] = randomUnified,
    [3] = randomIndividual,
    [4] = breath
}

-- Call the function based on mode
local func = c_tbl[mode]
if (func) then
    func()
end

function static()
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(red * brightness, green * brightness, blue * brightness)
    end
end

function randomUnified()
    rndR = math.random(0, math.floor(255 * brightness))
    rndG = math.random(0, math.floor(255 * brightness))
    rndB = math.random(0, math.floor(255 * brightness))
    for i = 1, numLights do
        lights[keys[i]].setRGBColor(rndR, rndG, rndB)
    end
end

function randomIndividual()
    for i = 1, numLights do
        rndR = math.random(0, math.floor(255 * brightness))
        rndG = math.random(0, math.floor(255 * brightness))
        rndB = math.random(0, math.floor(255 * brightness))
        lights[keys[i]].setRGBColor(rndR, rndG, rndB)
    end
end

function breath()
    mag = (math.sin(math.pi * step) + 1) * 0.5
    mul = breathmin + (breathmax - breathmin) * mag
    for i = 1, numLights do
        r = red * brightness * mul
        g = green * brightness * mul
        b = blue * brightness * mul
        lights[keys[i]].setRGBColor(r, g, b)
    end
end
