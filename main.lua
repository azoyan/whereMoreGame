require 'colors'

function love.load()
  math.randomseed(os.time())

  width         = love.graphics.getWidth()
  height        = love.graphics.getHeight()

  centerHeight  = height / 2
  criticalTime  = height

  centerWidth   = love.graphics.getWidth() / 2
  highscoreFont = love.graphics.newFont(centerHeight / 6)
  endFont       = love.graphics.newFont(18)

  love.graphics.setFont(highscoreFont)
  highscoreWidth = highscoreFont:getWidth("12")

  yourScore     = "YOUR SCORE: "
  tapToRestart  = "TAP TO RESTART"


  maxHorizontalCount = 9
  newGame()
end

function newGame()
  timeline      = 0
  speed         = 1
  gameOver      = false
  highscore     = 0
  highscoreText = "00"
  pause         = false
  userChoice    = nil
  offset        = 10
  level         = 1
  sides         = createSides()
end

function love.update(dt)
  gameOver = timeline > criticalTime
  if gameOver or pause then return end

  timeline = timeline + speed

  if userChoice ~= nil then
    if isCorrectAnswer(userChoice)
    then
      timeline = timeline / speed
      increaseSpeed(dt)
      increaseScore(dt)
      sides = createSides(dt)
    else decreaseTime(dt)
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

  if key == "n" or timeline > criticalTime then newGame()         end
  if key == "escape"        then love.event.quit() end

  if key == "left"
  or key == "right"
  then
    userChoice = key
  end

end

function isCorrectAnswer(userChoice)
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

function increaseScore(dt)
  highscore = highscore + 1
  if highscore > 0 and highscore < 10
  then
    highscoreText = "0" .. highscore
  else
    highscoreText = "" .. highscore
  end
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

  leftTimelineColor = lumiance(left.color) < 0.5 and {0, 00, 00} or {255, 255, 255}

  right.x       = centerWidth
  right.y       = 0
  right.color   = randomColor()
  right.figures = createFigures(right.color)

  rightTimelineColor = lumiance(right.color) < 0.5 and {0, 00, 00} or {255, 255, 255}

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


function createFigures(color)
  local figures  = {}
  figures.count  = math.random(1, maxHorizontalCount)
  figures.color  = contrastColor(color)
  figures.width  = (centerWidth / maxHorizontalCount / 2)
  figures.height = figures.width
  return figures
end

function love.draw()
  drawSide(sides.left)
  drawSide(sides.right)
  drawTimeline()
  drawScore()
  if timeline > criticalTime then
    drawGameOverScreen()
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
  local thickness = highscoreWidth /2
  local leftX   = centerWidth - thickness
  local rightX  = centerWidth + thickness
  local centerY = timeline / 2
  drawLine(leftX, rightX, thickness, centerY)
end

function drawLine(leftX, rightX, thickness, centerY, color)
  local color = {0, 0, 0, 4 }

  love.graphics.setColor(leftTimelineColor)
  love.graphics.line(leftX, 0, leftX,        timeline / 2)
  love.graphics.line(leftX, height, leftX,   height - timeline / 2)

  love.graphics.setColor(rightTimelineColor)
  love.graphics.line(rightX, 0, rightX,      timeline / 2)
  love.graphics.line(rightX, height, rightX, height - timeline / 2)
end

function drawScore()
  local width = highscoreFont:getWidth(highscoreText)


  local c1 = { rightTimelineColor[1], leftTimelineColor[2], leftTimelineColor[3], 32 }
  love.graphics.setColor(c1)

  -- love.graphics.rectangle("fill", centerWidth - width / 2, centerHeight - width / 2 - 30, width / 2, width)

  c2 = { leftTimelineColor[1], rightTimelineColor[2], rightTimelineColor[3], 32 }
  love.graphics.setColor(c2)
  -- love.graphics.rectangle("fill", centerWidth, centerHeight - width / 2 - 30, width / 2, width)

  love.graphics.setColor(leftTimelineColor)
  love.graphics.printf(highscoreText:sub(1, 1), -width/4, centerHeight - width / 2 - 30, love.graphics.getWidth(), 'center')

  love.graphics.setColor(rightTimelineColor)
  love.graphics.printf(highscoreText:sub(2, 2), width/4, centerHeight - width / 2 - 30, love.graphics.getWidth(), 'center')
end

function drawGameOverScreen()
  love.graphics.setColor(0, 0, 0, 225)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(yourScore .. highscore, 0, centerHeight - 64, love.graphics.getWidth(), 'center')
  love.graphics.setColor(255, 255, 255, 122)
  love.graphics.printf(tapToRestart, 0, centerHeight + 64, love.graphics.getWidth(), 'center')
end
