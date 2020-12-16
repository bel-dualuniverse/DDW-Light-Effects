-- Code for unit.start()
local seed  = 17  --export: random number seed
local speed = 0.5 --export: speed of timer in Sec

-- globals
step = 0
lights = {}
keys = {}
numLights = 0

math.randomseed(seed)

unit.setTimer("Live", speed)

function tablelen(t)
    -- # does not work for nonsequential tables
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function sort(a, b)
    -- numerical sort on slots
    -- alpha sort does not work as that results in slot1, slot10, slot2, etc
    numa = tonumber(string.sub(a, 5, -1))
    numb = tonumber(string.sub(b, 5, -1))
    return numa < numb
end

function init()
    -- Discover the lights
    for key, slot in pairs(unit) do
        if type(slot) == "table" and type(slot.export) == "table" then
            if slot.setRGBColor then
                lights[key] = slot
                table.insert(keys, key)
            end
        end
    end
    table.sort(keys, sort)
    numLights = tablelen(lights)
end

init()
