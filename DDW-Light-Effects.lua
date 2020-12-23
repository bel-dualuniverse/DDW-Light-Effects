-- DDW-Light-Effects
-- v0.7

-- Code for unit.tick("Live")
-- Exports
local stepDelta = 0.012 --export: step increment time based effects (i.e. Breath)
local mode = 2 --export: Light mode. 1=Static, 2=Random, 3=RandomUnified, 4=Breath (good with speed 0.01), 5=ColorListCycle, 6=ColorListRandom, 7=ColorListRandomUnified, 8=Race, 9=Animate
local brightness = 1 --export: brightness of lights (0-1)
local red = 255 --export: red
local green = 255 --export: green
local blue = 255 --export: blue
local breathmin = 0.25 --export: min breath multiplier (0-1). Works in conjunction with brighness.
local breathmax = 1 --export: max breath multiplier (0-1). Works in conjunction with brighness.
local raceSize = 1 --export: number of lights for race mode

-- List of colors to cycle through or pick from
local colorList = {
    toColor(255, 0, 0),
    toColor(0, 255, 0),
    toColor(0, 0, 255)
}
local numColorList = tablelen(colorList)

-- step for time based effects (i.e Breath)
step = step + stepDelta

-- Build the call table
local c_tbl = {
    [1] = static,
    [2] = randomIndividual,
    [3] = randomUnified,
    [4] = breath,
    [5] = colorListCycle,
    [6] = colorListRandomIndividual,
    [7] = colorListRandomUnified,
    [8] = race,
    [9] = animate
}

-- Call the function based on mode
local func = c_tbl[mode]
if (func) then
    func()
end

-- Unit utility methods. Others can be found in Library
function setAllLights(color)
    for i = 1, numLights do
        setLightColor(lights[keys[i]], color)
    end
end

function colorListNext()
    counter = counter + 1
    if counter > numColorList then
        counter = 1
    end
    return colorList[counter]
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

-- simple function to animate light color
-- lightNum (int): light number for color (1-10). Cannot be greater than the number of connected lights.
-- step (int): animation step
function animateColor(lightNum, step)
    -- This is just a very simple array indexing method.
    -- You are free to make this method as complex as needed.
    -- All it needs to do is return the color for lightNum at step.

    -- index into colorList
    -- each row represents a step in the animation
    -- a single row lists the colorList index values for each connected light
    local tenLightSequence = {
        {1, 2, 3, 1, 2, 3, 1, 2, 3, 1},
        {3, 1, 2, 3, 1, 2, 3, 1, 2, 3},
        {2, 3, 1, 2, 3, 1, 2, 3, 1, 2}
    }

    if lightNum > numLights then
        return toColor(0, 0, 0)
    end

    local index = (step + 2) % 3 + 1
    return colorList[tenLightSequence[index][lightNum]]
end

-- Light Effect methods
function static()
    setAllLights(adjustColor(toColor(red, green, blue), brightness))
end

function randomUnified()
    setAllLights(
        adjustColor(
            toColor(math.random(0, math.floor(255)), math.random(0, math.floor(255)), math.random(0, math.floor(255))),
            brightness
        )
    )
end

function randomIndividual()
    for i = 1, numLights do
        setLightColor(
            lights[keys[i]],
            adjustColor(
                toColor(
                    math.random(0, math.floor(255)),
                    math.random(0, math.floor(255)),
                    math.random(0, math.floor(255))
                ),
                brightness
            )
        )
    end
end

function breath()
    -- use a simple sin() wave transfomred to [0, 1]
    local mag = (math.sin(math.pi * step) + 1) * 0.5
    local mul = breathmin + (breathmax - breathmin) * mag
    setAllLights(adjustColor(toColor(red * mul, green * mul, blue * mul), brightness))
end

function colorListCycle()
    setAllLights(adjustColor(colorListNext(), brightness))
end

function colorListRandomIndividual()
    for i = 1, numLights do
        setLightColor(lights[keys[i]], adjustColor(colorListRandom(brightness)))
    end
end

function colorListRandomUnified()
    setAllLights(adjustColor(colorListRandom(), brightness))
end

function race()
    -- raceSize cannot be larger than the number of lights
    if raceSize > numLights then
        raceSize = numLights
    end

    local colorOff = adjustColor(colorList[1], brightness)
    local colorOn = adjustColor(colorList[2], brightness)

    -- set initial state
    if tablelen(slashTmp) == 0 then
        -- set initial positions of racing lights
        -- This will be the state previous to the initial state we want since
        -- the first operation is to advance the state.
        counter = numLights
        for i = 1, raceSize do
            table.insert(slashTmp, counter)
            counter = counter % numLights + 1
        end
    end

    -- reset all lights
    setAllLights(colorOff)

    -- advance the race
    for i = raceSize, 1, -1 do
        -- advance state
        slashTmp[i] = (slashTmp[i]) % numLights + 1

        -- set current state to on
        setLightColor(lights[keys[slashTmp[i]]], colorOn)
    end
end

function animate()
    counter = counter + 1
    for i = 1, numLights do
        setLightColor(lights[keys[i]], animateColor(i, counter))
    end
end
