local Side    = require 'actors/side'
local Figures = require 'actors/figures'
local State   = require 'states/state'

local Game = {}

for k, v in pairs(State) do Game[k] = v end
Game.__index = Game

setmetatable(Game, {
    __index = State,
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Game:_new(x, y, width, height, maxHCount, timeline, speed, highscore, font, increment, level)
  State._new(self, x, y, width, height, "game")
  self.centerWidth           = width / 2
  self.centerHeight          = height / 2
  self.criticalTime          = height
  self.timelineWidth         = width / 16
  self.maxHorizontalCount    = maxHCount
  self.timeline              = 0
  self.speed                 = 1
  self.highscore             = 0
  self.scoreFont             = font
  self.highscoreLeft         = "0"
  self.highscoreRight        = "0"
  self.highscoreText         = "00"
  self.highscoreLength       = self.highscoreText:len()
  self.highscoreMiddleLength = 0
  self.userChoice            = nil
  self.offset                = increment
  self.level                 = 1
  self.sides                 = {
    left  = Side(0,                0, self.centerWidth, self.height, colorLeft),
    right = Side(self.centerWidth, 0, self.centerWidth, self.height, colorRight)
  }

  self.figires = Figures(0, 0, self.centerWidth, self.height, randomColor(), maxHorizontalCount,  maxHorizontalCount, timelineWidth / 2, "left", "circle")
end

function Game:update(dt, choice)
  self.timeline = self.timeline + self.speed
  if self.timeline > self.criticalTime then self.nextState = states.over end

  if userChoice == "left" or userChoice == "right" then
    if self:isCorrectAnswer(userChoice)
    then
      self.timeline = self.timeline / self.speed
      self:increaseSpeed(dt)
      self:increaseScore(dt)
      self:changeHighscoreText(dt, self.highscore)
      self.sides = self:createSides(dt)
    else
      self:decreaseTime(dt)
    end
  end
end

function Game:createSides()
  local sides = {}
  local pair = self:pairOfCounts()
  local leftCount =  pair.left
  local rightCount = pair.right
  sides.left  = Side(0,           0, self.centerWidth, self.height, randomColor(), leftCount,  maxHorizontalCount, timelineWidth / 2, "left", "circle")
  sides.right = Side(self.centerWidth, 0, self.centerWidth, self.height, randomColor(), rightCount, maxHorizontalCount, timelineWidth / 2, "right", "circle")
  leftTimelineColor = lumiance(sides.left.color) < 0.5 and BLACK or WHITE
  rightTimelineColor = lumiance(sides.right.color) < 0.5 and BLACK or WHITE

  return sides;
end

function Game:pairOfCounts()
  local left  = math.random(1, self.maxHorizontalCount)
  local right = math.random(1, self.maxHorizontalCount)

  local panicLimit   = 10
  local currentSteps = 0

  while left == right
  do
    right = math.random(1, self.maxHorizontalCount)
    currentSteps = currentSteps + 1
    if currentSteps > panicLimit then
      assert(false, "to long generation of unique values of figures count")
    end
  end
  return { left = left, right = right }
end

function Game:changeHighscoreText(dt, highscore)
  highscoreText   = "" .. highscore
  highscoreLength = highscoreText:len()
  if highscoreLength % 2 ~= 0 then highscoreText = "0" .. highscoreText end
  highscoreLength = highscoreText:len()

  highscoreMiddleLength = highscoreLength / 2
  highscoreLeft  = highscoreText:sub(1, highscoreMiddleLength)
  highscoreRight = highscoreText:sub(highscoreMiddleLength + 1, highscoreLength)
end

function Game:isCorrectAnswer(userChoice)
  return userChoice == "left" and self:shouldLeft()
  or userChoice == "right" and self:shouldRight()
end

function Game:shouldLeft()  return self.sides.left.figuresCount > self.sides.right.figuresCount end
function Game:shouldRight() return self.sides.left.figuresCount < self.sides.right.figuresCount end

function Game:decreaseTime()
  self.timeline = self.timeline + self.height / 2
end

function Game:increaseScore(dt)
  self.highscore = self.highscore + 1
end

function Game:increaseSpeed(dt)
  if 0 == self.highscore % 5 then self.offset = self.offset + 1 end
  self.speed = self.speed + dt * self.offset
end

function Game:draw()
  self.sides.left:draw()
  self.sides.right:draw()
  self:drawTimeline()
  self:drawScore()
end

function Game:drawTimeline()
  local thickness = highscoreWidth / 2
  local leftX     = centerWidth - thickness
  local rightX    =  centerWidth + thickness
  local centerY   = self.timeline / 2
  self:drawLine(leftX, rightX, thickness, centerY)
end

function Game:drawLine(leftX, rightX, thickness, centerY, color)
    love.graphics.setColor(leftTimelineColor[1], leftTimelineColor[2], leftTimelineColor[3], 32)
    love.graphics.rectangle("fill", leftX,      0, thickness,   centerY)
    love.graphics.rectangle("fill", leftX, self.height, thickness, - centerY)

    love.graphics.setColor(rightTimelineColor[1], rightTimelineColor[2], rightTimelineColor[3], 32)
    love.graphics.rectangle("fill", centerWidth,      0, thickness,   centerY)
    love.graphics.rectangle("fill", centerWidth, self.height, thickness, - centerY)
end

function Game:drawScore()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(highscoreFont)
  local leftc  = { leftTimelineColor[1] , leftTimelineColor[2]  , leftTimelineColor[3] , 160 }
  local rightc = { rightTimelineColor[1] , rightTimelineColor[2]  , rightTimelineColor[3], 160 }

  love.graphics.printf( { leftc, highscoreLeft, rightc, highscoreRight }
                         ,0
                         ,self.centerHeight - (highscoreFont:getHeight(highscoreText) / 2)
                         ,self.width
                         ,'center')
end


function Game:keypressed(key)
  if key == "p"                      then userChoice = key end
  if key == "n"                      then userChoice = key end
  if key == "escape"                 then userChoice = key end
  if key == "left" or key == "right" then userChoice = key end
end

return Game
