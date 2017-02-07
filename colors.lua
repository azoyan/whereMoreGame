function randomColor()
  return { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
end

function inverseColor(color)
  return { 255 - color[1], 255 - color[2], 255 - color[3] }
end


function randomContrastColor(backgroundColor)
  local result = randomColor()
  local backgroundLumiance = lumiance(backgroundColor)

  while math.abs(backgroundLumiance - lumiance(result)) < 0.4
  do
    result = randomColor()
  end
  return result
end

function grayscaleContrastColor(color, alpha)
  local result = (lumiance(color) < 0.5) and BLACK or WHITE
  result[4] = alpha or 255
  return result
end

function lumiance(color)
  return 1 -  ( 0.299 * color[1] + 0.587 * color[2] + 0.114 * color[3]) / 255
end

WHITE       = { 255, 255, 255 }
BLACK       = { 0,     0,   0 }
TRANSPARENT = { 0, 0, 0, 0 }
