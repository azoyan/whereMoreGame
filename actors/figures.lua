local Figure = require 'actors/figure'

local Figures = {}
Figures.__index = Figures

setmetatable(Figures, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Figures:_new(x, y, width, height, color, figuresCount, maxHorizontalCount, padding, direction, type)
  self.x 			            = x
  self.y 			            = y
  self.width 		          = width
  self.height 			      = height
  self.color 		          = color
  self.maxHorizontalCount = maxHorizontalCount
  self.direction          = direction
  self.padding            = padding
  self.figuresCount 	    = figuresCount
  self.figures  	        = self:createFigures(figuresCount)
  self.type               = type
end

function Figures:createFigures(count)
  local figures  = {}

  local x        = self.x
  local y        = self.height / 2
  local radius   = (self.width - self.padding) / self.padding
  local diameter = radius * 2;
  local color    = randomContrastColor(self.color)

  for i = 1, self.figuresCount, 1
  do
    x = self.x + i * diameter * 2 + self.padding
    if self.direction == "left" then x = self.width - x  end
    local figure = self:createFigure(x, y, radius, diameter, color)
    table.insert(figures, figure)
  end

  return figures
end

function Figures:createFigure(x, y, radius, diameter, color)
  figure = {}

  figure.x        = x
  figure.y        = y
  figure.radius   = radius
  figure.diameter = diameter
  figure.color    = color

  return figure;
end

function Figures:draw()
  self:drawBackground()
  self:drawFigures(self.x, self.figures)
end

function Figures:drawBackground()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Figures:drawFigures(figures)
  for _, figure in pairs(self.figures) do figure:draw() end
end

function Figures:calculateFiguresCount()
  local count = (self.width - self.padding) / self.padding

  return count
end

return Figures
