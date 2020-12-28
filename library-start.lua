-- Library static utility methods
function toColor(red, green, blue)
    return {r = red, g = green, b = blue}
end

function printColor(color)
    system.print("(" .. color.r .. ", " .. color.g .. ", " .. color.b .. ")")
end

function adjustColor(color, multiplier)
    return {r = color.r * multiplier, g = color.g * multiplier, b = color.b * multiplier}
end

function setLightColor(light, color)
    light.setRGBColor(color.r, color.g, color.b)
end

function setAllLights(lights, keys, numLights, color)
    for i = 1, numLights do
        setLightColor(lights[keys[i]], color)
    end
end

function colorListNext(colorList, colorListIndex, lenColorList)
    counter = counter + 1
    if counter > lenColorList[colorListIndex] then
        counter = 1
    end
    return getColor(colorList, colorListIndex, counter)
end

function colorListRandom(colorList, colorListIndex, lenColorList)
    local color = math.random(1, lenColorList[colorListIndex])

    -- Prevent the same color from being selected again this step.
    -- That just looks bad.
    while color == colorLast do
        color = math.random(1, lenColorList[colorListIndex])
    end

    colorLast = color
    return getColor(colorList, colorListIndex, color)
end

function getColor(colorList, listIndex, colorIndex)
    return colorList[listIndex][colorIndex]
end
