local Side = {}
Side.__index = Side

setmetatable(Side, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Side:_new(x, y, width, height, color)
  self.x 			            = x
  self.y 			            = y
  self.width 		          = width
  self.height 			      = height
  self.color 		          = color
end

function Side:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Side
