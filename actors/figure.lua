
local Figure = {}
Figure.__index = Figure

setmetatable(Figure, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Figure:_new(x, y, radius, color, type)
  self.x 			  = x
  self.y 			  = y
  self.radius 	= radius
  self.diameter = self.radius * 2;
  self.color 		= color
  self.type     = type or "rect"
end

function Figure:draw()
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

return Figure
