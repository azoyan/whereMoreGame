require 'colors'

local ToggleButton = {}
ToggleButton.__index = ToggleButton

setmetatable(ToggleButton, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function ToggleButton:_new(text, x, y, width, height, color, backgroundColor, font, toggle, toggleText)
  self.text 	         = text
  self.x               = x
  self.y               = y
  self.width           = width
  self.height          = height
  self.color           = color
  self.backgroundColor = backgroundColor
  self.font            = font
  self.isToggled       = toggle or false
  self.toggleText      = toggleText or "OFF"
end

function ToggleButton:mousepressed(x, y)
  if x == nil or y == nil then return false end
  if self.x < x and self.y < y and self.width > x and self.height > y
  then
    self.isToggled = not self.isToggled
    self.toggleText = self.isToggled and "ON" or "OFF"
    return true
  else
    return false
  end
end

function ToggleButton:toggledOn()
  return self.isToggled
end

function ToggleButton:draw()
  love.graphics.setColor(self.backgroundColor)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(self.color)
  love.graphics.printf(self.text,       self.x + self.font:getHeight() / 2, self.y + self.font:getHeight() / 2, self.width - self.font:getHeight(), "left")
  love.graphics.printf(self.toggleText, self.x + self.font:getHeight() / 2, self.y + self.font:getHeight() / 2, self.width - self.font:getHeight(), "right")
end

return ToggleButton
