function love.load()
  width, height = love.graphics.getWidth() / 2, love.graphics.getHeight()
  math.randomseed(os.time())
  newGame()
end

function newGame()
  sides = createSides()
  timeline = 0
  speed = 1
  gameOver = false
end

function randomColor()
  return { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
end

function love.update(dt)
  gameOver = timeline > height
  if not gameOver then
    timeline = timeline + speed;
  end
end

function love.mousepressed(x, y, button, isTouch)
  if button == 1 then
    if gameOver then
      newGame()
      return
     end
    if x < width and sides.left.figures.count > sides.right.figures.count
    or x > width and sides.left.figures.count < sides.right.figures.count
    then
      sides = createSides()
      timeline = 0
      speed = speed + 1
    else timeline = timeline + height / 2
    end
  end
end

function createSides()
  sides = {
    left  = { x = 0,     y = 0, color = randomColor(), figures = createFigures(math.random(1, 10)) },
    right = { x = width, y = 0, color = randomColor(), figures = createFigures(math.random(1, 10)) }
  }

  if (sides.left.figures.count == sides.right.figures.count) then
    sides.right.figures = createFigures(math.random(0, 10))
  end

  return sides
end

function love.draw()
  if not gameOver then
    drawSide(sides.left)
    drawSide(sides.right)
    drawTimeline()
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("You score: " .. speed - 1 .. "\n\ntap to restart", width - 10, height / 2)
  end
end

function createFigures(count)
  return { count = count, color = randomColor() }
end

function drawSide(side)
  love.graphics.setColor(side.color)
  love.graphics.rectangle("fill", side.x, side.y, width, height)
  drawFigures(side.x, side.figures)
end

function drawFigures(startPosition, figures)
  love.graphics.setColor(figures.color)
  for i = 1, figures.count do
    love.graphics.rectangle("fill", startPosition + 10 + i * 20, height / 2, 10, 10)
  end
end

function drawTimeline()
  love.graphics.setColor(93, 93, 93)
  local thickness = 10
  local x, y          = width - thickness / 2, height / 2
  local width, height = 10, timeline / 2

  love.graphics.rectangle("fill", x, y, thickness, height)
  love.graphics.rectangle("fill", x, y, thickness, -height)
end
