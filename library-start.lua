-- Library static utility methods
function toColor(red, green, blue)
    return {r = red, g = green, b = blue}
end

function printColor(color)
    system.print("(" .. color.r .. ", " .. color.g .. ", " .. color.b .. ")")
end

function adjustColor(color, brightness)
    return {r = color.r * brightness, g = color.g * brightness, b = color.b * brightness}
end

function setLightColor(light, color)
    light.setRGBColor(color.r, color.g, color.b)
end
