
local Side = {}
Side.__index = Side

setmetatable(Side, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Side:_new(x, y, width, height, color, figuresCount, maxHorizontalCount, padding, direction, type)
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

function Side:createFigures(count)
  local figures  = {}

  local x      = self.x
  local y      = self.height / 2
  local radius  = (self.width - self.padding) / self.padding
  local diameter = radius * 2;
  local color  = contrastColor(self.color)

  for i = 1, self.figuresCount, 1
  do
    x = self.x + i * diameter * 2
    if self.direction == "left" then x = x - self.padding end
    local figure = createFigure(x, y, radius, diameter, color)
    -- print(x, y, radius, diameter, self.figuresCount, self.maxHorizontalCount)
    table.insert(figures, figure)
  end

  return figures
end

function createFigure(x, y, radius, diameter, color)
  figure = {}

  figure.x        = x
  figure.y        = y
  figure.radius   = radius
  figure.diameter = diameter
  figure.color    = color

  return figure;
end

function Side:draw()
  self:drawBackground()
  self:drawFigures(self.x, self.figures)
end

function Side:drawBackground()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Side:drawFigures(figures)
  for _, figure in pairs(self.figures)
  do
    love.graphics.setColor(figure.color)
    if     self.type == "circle" then love.graphics.circle("fill", figure.x, figure.y, figure.radius)
    elseif self.type == "rect"
    then
      local width = figure.diameter --* 0.75
      local height = width
      local x = figure.x - width / 2
      local y = figure.y - height / 2
      love.graphics.rectangle("fill", x, y, width, height)
    end
  end
end

-- function Side:drawFigures(startPosition, figures)
--   love.graphics.setColor(figures.color)
--   local x      = self.x + self.padding
--   local y      = centerHeight - figures.width / 2
--   local width  = figures.width
--   local height = figures.height
--
--   for i = 0, figures.count
--   do
--     x = x + i * figures.width * 2
--     if (self.direction == "left") then x = self.x - x - self.padding  end
--     love.graphics.rectangle("fill", x, y, width, height)
--   end
-- end

function Side:calculateFiguresCount()
  local count = (self.width - self.padding) / self.padding

  return count
end

return Side
