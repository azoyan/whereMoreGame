local Side     = require 'actors/side'
local State    = require 'states/state'

require 'colors'
require 'buttons'

local Menu = {}

for k, v in pairs(State) do Menu[k] = v end
Menu.__index = Menu

setmetatable(Menu, {
    __index = State,
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Menu:_new(x, y, width, height, colorLeft, colorRight, font)
  State._new(self, x, y, width, height, "menu")
  self.centerWidth    = width / 2
  self.centerHeight   = height / 2
  self.leftTextColor  = grayscaleContrastColor(colorLeft, 166)
  self.rightTextColor = grayscaleContrastColor(colorRight, 166)
  self.font           = font
  self.labels         = { left = "NEW GAME", right = "SETTINGS" }
  self.sides          = { 
    left  = Side(0,                0, self.centerWidth, self.height, colorLeft),
    right = Side(self.centerWidth, 0, self.centerWidth, self.height, colorRight)
  }
  self.choice = nil
end

function Menu:update(dt)
  if     self.choice == GlobalStates.settings then self:setNext(GlobalStates.settings)
  elseif self.choice == GlobalStates.game     then self:setNext(GlobalStates.game)
  end
end

function Menu:mousepressed(x, y, button, isTouch)
  if button == 1 then
    if     x < self.centerWidth then self.choice = GlobalStates.game
    elseif x > self.centerWidth then self.choice = GlobalStates.settings
    end
  end
end

function Menu:changeColors()
  self.sides.left.color  = randomColor()
  self.sides.right.color = randomColor()
  self.leftTextColor     = grayscaleContrastColor(self.sides.left.color,  166)
  self.rightTextColor    = grayscaleContrastColor(self.sides.right.color, 166)
end

function Menu:draw()
  love.graphics.setFont(self.font)
  self.sides.left:draw()
  self.sides.right:draw()
  love.graphics.setColor(self.leftTextColor)
  love.graphics.printf("NEW GAME", self.x, self.centerHeight - self.font:getHeight() / 2, self.centerWidth, "center")
  love.graphics.setColor(self.rightTextColor)
  love.graphics.printf("SETTINGS", self.centerWidth, self.centerHeight - self.font:getHeight() / 2, self.centerWidth, "center")
end

return Menu
