function love.load()
  math.randomseed(os.time())

  --love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=800, minheight=600})
  width         = love.graphics.getWidth()
  height        = love.graphics.getHeight()
  centerHeight  = height / 2
  centerWidth   = love.graphics.getWidth() / 2
  highscoreFont = love.graphics.newFont(32)
  endFont       = love.graphics.newFont(48)

  love.graphics.setFont(highscoreFont)
  higscoreWidth = highscoreFont:getWidth("12")

  yourScore     = "Your score "
  tapToRestart  = "tap to restart"


  maxHorizontalCount = 9
  newGame()
end

function newGame()
  timeline = 0
  speed = 1
  gameOver = false
  highscore = 0
  highscoreText = "00"
  pause = false
  userChoice = nil
  offset = 10

  sides = createSides()
end

function randomColor()
  return { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
end

function love.update(dt)
  if pause then return end

  gameOver = timeline > height
  timeline = timeline + speed
  if not gameOver and userChoice then
    if checkChoice(userChoice) then
      newSides(dt)
    else
      decreaseTime()
    end
  userChoice = nil
  end
end

function love.mousepressed(x, y, button, isTouch)
  if gameOver then newGame() return end
  if button == 1 then
    if     x < centerWidth then userChoice = "left"
    elseif x > centerWidth then userChoice = "right"
    end
  end
end

function love.keypressed(key)
  if key == "p" then pause = not pause end
  if pause then return end

  if key == "n" or gameOver then newGame()         end
  if key == "escape"        then love.event.quit() end

  if key == "left"
  or key == "right"
  then
    userChoice = key
  end

end

function checkChoice(userChoice)
  return userChoice == "left" and shouldLeft() or userChoice == "right" and shouldRight()
end

function shouldLeft()  return sides.left.figures.count > sides.right.figures.count end
function shouldRight() return sides.left.figures.count < sides.right.figures.count end

function decreaseTime()
  timeline = timeline + height / 2
end

function newSides(dt)
  highscore = highscore + 1
  timeline = timeline / speed
  increaseSpeed(dt)
  if highscore > 0 and highscore < 10 then highscoreText = "0" .. highscore end
  sides = createSides()
end

function increaseSpeed(dt)
  if 0 == highscore % 5 then offset = offset + 1 end
  speed = speed + dt * offset
end

function createSides()
  local sides = {}
  local left  = {}
  local right = {}

  left.x       = 0
  left.y       = 0
  left.color   = randomColor()
  left.figures = createFigures(left.color)

  right.x       = centerWidth
  right.y       = 0
  right.color   = randomColor()
  right.figures = createFigures(right.color)

  local panicLimit = 10
  local currentSteps = 0

  while left.figures.count == right.figures.count do
    right.figures = createFigures(right.color)

    currentSteps = currentSteps + 1
    if currentSteps > panicLimit then
      assert(false, "to long generation of unique values of figures count")
    end
  end

  sides.left  = left
  sides.right = right

  return sides
end

function inverseColor(color)
  local r, g, b = color[1], color[2], color[3]
  return { 255 - r, 255 - g, 255 - b }
end

function createFigures(color)
  local figures  = {}
  figures.count  = math.random(1, maxHorizontalCount)
  figures.color  = inverseColor(color)
  figures.width  = (centerWidth / maxHorizontalCount / 2)
  figures.height = figures.width
  return figures
end

function love.draw()
  drawSide(sides.left)
  drawSide(sides.right)
  drawTimeline()
  drawScore()
  if gameOver then
    love.graphics.setColor(0, 0, 0, 225)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(yourScore .. highscore, 0, centerHeight - 64, love.graphics.getWidth(), 'center')
    love.graphics.setColor(255, 255, 255, 122)
    love.graphics.printf(tapToRestart, 0, centerHeight + 64, love.graphics.getWidth(), 'center')
  end
end

function drawBackground(side)
  love.graphics.setColor(side.color)
  love.graphics.rectangle("fill", side.x, side.y, centerWidth, height)
end

function drawSide(side)
  drawBackground(side)
  drawFigures(side.x, side.figures)
end

function drawFigures(startPosition, figures)
  love.graphics.setColor(figures.color)
  for i = 0, figures.count - 1 do
    --love.graphics.rectangle("fill", startPosition + i * figures.width, centerHeight, figures.width / 2, figures.height / 2)
    love.graphics.rectangle("fill",
      startPosition + figures.width / 2 + i * figures.width * 2, centerHeight
      , figures.width, figures.height
      ,figures.width / 8)
  end
end

function drawTimeline()
  local thickness = highscoreFont:getWidth(highscore) / 4
  local leftX   = centerWidth - thickness
  local rightX  = centerWidth + thickness
  local centerY = timeline / 2

  local white = { 255, 255, 255 }
  local black = { 145, 145, 145 }

  drawLine(leftX - 1, rightX - 1, centerY, black)
  drawLine(leftX, rightX, centerY, white)
  -- drawLine(leftX + 1, rightX + 1, centerY, black)

end

function drawLine(leftX, rightX, centerY, color)
  love.graphics.setColor(color)
  love.graphics.line(leftX, 0, leftX,        timeline / 2)
  love.graphics.line(rightX, 0, rightX,      timeline / 2)
  love.graphics.line(leftX, height, leftX,   height - timeline / 2)
  love.graphics.line(rightX, height, rightX, height - timeline / 2)
end

function drawScore()
  love.graphics.setColor(225, 225, 225,56)
  local width = highscoreFont:getWidth(highscoreText)

  love.graphics.rectangle("fill", centerWidth - width / 2, centerHeight - width / 2, width, width, width / 10)

  love.graphics.setColor(0, 0, 0, 167)
  love.graphics.printf(highscoreText, 0, centerHeight - width / 2, love.graphics.getWidth(), 'center')
end
