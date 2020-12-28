-- DDW-Light-Effects
-- v1.0

-- Code for unit.tick("Live")
-- Exports
local stepDelta = 0.012 --export: step increment time based effects (i.e. Breath)
local mode = 1 --export: Light mode. 1=StaticUnified, 2=StaticIndividual, 3=RandomUnified, 4=RandomIndividual, 5=BreathUnified (good with speed 0.01), 6=ColorListCycle, 7=ColorListRandomUnified, 8=ColorListRandomIndividual, 9=Race, 10=Animate
local brightness = 1 --export: brightness of lights (0-1)
local breathmin = 0.25 --export: min breath multiplier (0-1). Works in conjunction with brighness.
local breathmax = 1 --export: max breath multiplier (0-1). Works in conjunction with brighness.
local raceSize = 1 --export: number of lights for race mode

-- Array of Lists of colors to cycle through or pick from
-- The first index, called colorListIndex, corresponds to what is passed to the functions in c_tbl
local colorList = {
    [1] = {
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255),
        toColor(255, 255, 255)
    },
    [2] = {
        toColor(255, 0, 0),
        toColor(0, 255, 0),
        toColor(0, 0, 255)
    }
}
local lenColorList = {}
for i = 1, tablelen(colorList) do
    lenColorList[i] = tablelen(colorList[i])
end

-- step for time based effects (i.e Breath)
step = step + stepDelta

-- Build the call table
-- Format: {function, parameters}
-- See individual functions for parameter definitions
local c_tbl = {
    [1] = {staticUnified, {1}},
    [2] = {staticIndividual, {1}},
    [3] = {randomUnified, {}},
    [4] = {randomIndividual, {}},
    [5] = {breathUnified, {1}},
    [6] = {colorListCycle, {2}},
    [7] = {colorListRandomUnified, {2}},
    [8] = {colorListRandomIndividual, {2}},
    [9] = {race, {2}},
    [10] = {animate, {2}}
}

-- Call the function based on mode
local func = c_tbl[mode][1]
local params = c_tbl[mode][2]

if (func) then
    func(params)
end

-- simple function to animate light color
-- lightNum (int): light number for color (1-10). Cannot be greater than the number of connected lights.
-- step (int): animation step
function animateColor(colorListIndex, lightNum, step)
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
    return getColor(colorList, colorListIndex, tenLightSequence[index][lightNum])
end

-- Light Effect methods
function staticUnified(params)
    colorListIndex = params[1]
    setAllLights(lights, keys, numLights, adjustColor(getColor(colorList, colorListIndex, 1), brightness))
end

function staticIndividual(params)
    colorListIndex = params[1]
    for i = 1, numLights do
        setLightColor(lights[keys[i]], adjustColor(getColor(colorList, colorListIndex, i), brightness))
    end
end

function randomUnified(params)
    setAllLights(
        lights,
        keys,
        numLights,
        adjustColor(
            toColor(math.random(0, math.floor(255)), math.random(0, math.floor(255)), math.random(0, math.floor(255))),
            brightness
        )
    )
end

function randomIndividual(params)
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

function breathUnified(params)
    colorListIndex = params[1]

    -- use a simple sin() wave transfomred to [0, 1]
    local mag = (math.sin(math.pi * step) + 1) * 0.5
    local mul = breathmin + (breathmax - breathmin) * mag
    setAllLights(lights, keys, numLights, adjustColor(getColor(colorList, colorListIndex, 1), brightness * mul))
end

function colorListCycle(params)
    colorListIndex = params[1]
    setAllLights(
        lights,
        keys,
        numLights,
        adjustColor(colorListNext(colorList, colorListIndex, lenColorList), brightness)
    )
end

function colorListRandomIndividual(params)
    colorListIndex = params[1]
    for i = 1, numLights do
        setLightColor(
            lights[keys[i]],
            adjustColor(colorListRandom(colorList, colorListIndex, lenColorList), brightness)
        )
    end
end

function colorListRandomUnified(params)
    colorListIndex = params[1]
    setAllLights(
        lights,
        keys,
        numLights,
        adjustColor(colorListRandom(colorList, colorListIndex, lenColorList), brightness)
    )
end

function race(params)
    colorListIndex = params[1]

    -- raceSize cannot be larger than the number of lights
    if raceSize > numLights then
        raceSize = numLights
    end

    local colorOff = adjustColor(getColor(colorList, colorListIndex, 1), brightness)
    local colorOn = adjustColor(getColor(colorList, colorListIndex, 2), brightness)

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
    setAllLights(lights, keys, numLights, colorOff)

    -- advance the race
    for i = raceSize, 1, -1 do
        -- advance state
        slashTmp[i] = (slashTmp[i]) % numLights + 1

        -- set current state to on
        setLightColor(lights[keys[slashTmp[i]]], colorOn)
    end
end

function animate(params)
    colorListIndex = params[1]

    counter = counter + 1
    for i = 1, numLights do
        setLightColor(lights[keys[i]], animateColor(colorListIndex, i, counter))
    end
end
