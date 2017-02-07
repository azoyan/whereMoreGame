require 'colors'

local PushButton = {}
PushButton.__index = PushButton

setmetatable(PushButton, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function PushButton:_new(text, x, y, width, height, color, backgroundColor, font)
  self.text 	         = text
  self.x               = x
  self.y               = y
  self.width           = width
  self.height          = height
  self.color           = color
  self.backgroundColor = backgroundColor
  self.font            = font
  self.isClicked       = false
end

function PushButton:clicked()
  return self.isClicked
end

function PushButton:mousepressed(x, y)
  self.isClicked = self.x < x and self.y < y and self.width > x and self.height > y
end

function PushButton:draw()
  love.graphics.setColor(self.backgroundColor)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(self.color)
  love.graphics.printf(self.text,       self.x, self.y + self.font:getHeight() / 2, self.width, "center")
end

return PushButton
