-- Code for unit.tick("Live")
-- Exports
local mode       = 3      --export: Light mode. 1=Static, 2=Random Unified, 3=Random Individual, 4=Breath
local brightness = 1      --export: brightness of lights (0-1)
local red        = 255    --export: Red
local green      = 255    --export: Green
local blue       = 255    --export: Blue
local breathmin  = 0.25    --export: min breath multiplier (0-1)
local breathmax  = 1      --export: max breath multiplier (0-1)

step = step + 0.012

-- Build the call table
local c_tbl =
{
	[1] = static,
    [2] = randomUnified,
    [3] = randomIndividual,
    [4] = breath,
}

-- Find the lights
lights={}
for key, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" then
        if slot.setRGBColor then
            table.insert(lights, slot)
        end
    end
end

-- Call the function based on mode
local func = c_tbl[mode]
if (func) then
    func()
end

function static()
    for i = 1, #lights do
        lights[i].setRGBColor(red*brightness, green*brightness, blue*brightness)
    end
end

function randomUnified()
    rndR = math.random(0, math.floor(255*brightness))
    rndG = math.random(0, math.floor(255*brightness))
    rndB = math.random(0, math.floor(255*brightness))
    for i = 1, #lights do
        lights[i].setRGBColor(rndR, rndG, rndB)
    end
end

function randomIndividual()
    for i = 1, #lights do
        rndR = math.random(0, math.floor(255*brightness))
        rndG = math.random(0, math.floor(255*brightness))
        rndB = math.random(0, math.floor(255*brightness))
        lights[i].setRGBColor(rndR, rndG, rndB)
    end

    
end

function breath()
    mag = math.abs(math.sin(math.pi * step))
    mul = breathmin + (breathmax - breathmin) * mag
    for i = 1, #lights do
        r = red*brightness*mul
        g = green*brightness*mul
        b = blue*brightness*mul
        lights[i].setRGBColor(r, g, b)
    end
end