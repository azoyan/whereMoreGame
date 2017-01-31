require 'colors'

local Side = require 'actors/side'

function love.load()
  math.randomseed(os.time())

  --love.window.setMode(320, 240, flags)
  --love.window.setMode(640, 480, flags)
  -- love.window.setMode(1024, 768, flags)
   love.window.setMode(1280, 720, {resizable = true})


  newGame()
end

function love.resize(w, h)
  newGame()
end

function newGame()
  width         = love.graphics.getWidth()
  centerWidth   = width / 2

  height        = love.graphics.getHeight()
  centerHeight  = height / 2
  criticalTime  = height

  timelineWidth = centerWidth / 8
  highscoreFont = love.graphics.newFont("origap__.ttf",centerWidth / 16)
  endFont       = love.graphics.newFont(18)

  love.graphics.setFont(highscoreFont)
  --highscoreWidth = highscoreFont:getWidth("12")
  highscoreWidth = timelineWidth
  print(highscoreFont:getWidth("12"), highscoreFont:getWidth("1"), highscoreFont:getWidth("666"), centerWidth / 8)

  yourScore     = "YOUR SCORE: "
  tapToRestart  = "TAP TO RESTART"

  maxHorizontalCount = math.floor(centerWidth / highscoreWidth)
  timeline              = 0
  speed                 = 1
  gameOver              = false
  highscore             = 00
  highscoreText         = ""
  highscoreLeft         = "0"
  highscoreRight        = "0"
  highscoreLength       = highscoreText:len()
  highscoreMiddleLength = 0
  pause                 = false
  userChoice            = nil
  offset                = 10
  level                 = 1
  sides                 = createSides()
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
      changeHighscoreText(dt, highscore)
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

function changeHighscoreText(dt, highscore)
  highscoreText   = "" .. highscore
  highscoreLength = highscoreText:len()
  if highscoreLength % 2 ~= 0 then highscoreText = "0" .. highscoreText end
  highscoreLength = highscoreText:len()

  highscoreMiddleLength = highscoreLength / 2
  highscoreLeft  = highscoreText:sub(1, highscoreMiddleLength)
  highscoreRight = highscoreText:sub(highscoreMiddleLength + 1, highscoreLength)
end

function isCorrectAnswer(userChoice)
  return userChoice == "left" and shouldLeft() or userChoice == "right" and shouldRight()
end

function shouldLeft()  return sides.left.figuresCount > sides.right.figuresCount end
function shouldRight() return sides.left.figuresCount < sides.right.figuresCount end

function decreaseTime()
  timeline = timeline + height / 2
end

function increaseScore(dt)
  highscore = highscore + 1
end

function increaseSpeed(dt)
  if 0 == highscore % 5 then offset = offset + 1 end
  speed = speed + dt * offset
end

function createSides()
  local sides = {}
  local pair = pairOfCounts()
  local leftCount =  pair.left
  local rightCount = pair.right
  sides.left  = Side(0,           0, centerWidth, height, randomColor(), leftCount,  maxHorizontalCount, timelineWidth / 2, "left", "rect")
  sides.right = Side(centerWidth, 0, centerWidth, height, randomColor(), rightCount, maxHorizontalCount, timelineWidth / 2, "right", "rect")
  leftTimelineColor = lumiance(sides.left.color) < 0.5 and BLACK or WHITE
  rightTimelineColor = lumiance(sides.right.color) < 0.5 and BLACK or WHITE

  return sides;
end

function pairOfCounts()
  local left  = math.random(1, maxHorizontalCount)
  local right = math.random(1, maxHorizontalCount)

  local panicLimit   = 10
  local currentSteps = 0

  while left == right
  do
    right = math.random(1, maxHorizontalCount)

    currentSteps = currentSteps + 1
    if currentSteps > panicLimit then
      assert(false, "to long generation of unique values of figures count")
    end
  end
  return { left = left, right = right }
end


function createFigures(color)
  local figures  = {}
  figures.count  = math.random(1, maxHorizontalCount)
  figures.color  = contrastColor(color)
  figures.width  = highscoreWidth
  figures.height = figures.width
  return figures
end

function love.draw()
  sides.left:draw()
  sides.right:draw()
  drawTimeline()
  drawScore()
  if gameOver then
    drawGameOverScreen()
  end
end

function drawBackground(side)
  love.graphics.setColor(side.color)
  love.graphics.rectangle("fill", side.x, side.y, centerWidth, height)
end

function drawTimeline()
  local thickness = highscoreWidth / 2
  local leftX     = centerWidth - thickness
  local rightX    =  centerWidth + thickness
  local centerY   = timeline / 2
  drawLine(leftX, rightX, thickness, centerY)
end

function drawLine(leftX, rightX, thickness, centerY, color)
    love.graphics.setColor(leftTimelineColor[1], leftTimelineColor[2], leftTimelineColor[3], 32)
    love.graphics.rectangle("fill", leftX,      0, thickness,   centerY)
    love.graphics.rectangle("fill", leftX, height, thickness, - centerY)

    love.graphics.setColor(rightTimelineColor[1], rightTimelineColor[2], rightTimelineColor[3], 32)
    love.graphics.rectangle("fill", centerWidth,      0, thickness,   centerY)
    love.graphics.rectangle("fill", centerWidth, height, thickness, - centerY)
end

function drawScore()
  love.graphics.setColor(255, 255, 255, 255)

  local leftc  = { leftTimelineColor[1] , leftTimelineColor[2]  , leftTimelineColor[3] , 225}
  local rightc = { rightTimelineColor[1] , rightTimelineColor[2]  , rightTimelineColor[3], 225 }

  love.graphics.printf( { leftc, highscoreLeft, rightc, highscoreRight }
                         ,0
                         ,centerHeight - (highscoreFont:getHeight(highscoreText) / 2)
                         ,width
                         ,'center')
end

function drawGameOverScreen()
  love.graphics.setColor(0, 0, 0, 225)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(yourScore .. highscore, 0, centerHeight - 64, love.graphics.getWidth(), 'center')
  love.graphics.setColor(255, 255, 255, 122)
  love.graphics.printf(tapToRestart, 0, centerHeight + 64, love.graphics.getWidth(), 'center')
end
