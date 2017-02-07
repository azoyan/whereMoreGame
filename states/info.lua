local Side     = require 'actors/side'
local State    = require 'states/state'

require 'colors'
require 'buttons'

local Info = {}

for k, v in pairs(State) do Info[k] = v end
Info.__index = Info

setmetatable(Info, {
    __index = State,
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Info:_new(x, y, width, height, colorLeft, colorRight, font)
  State._new(self, x, y, width, height, "info")
  self.centerWidth    = width / 2
  self.centerHeight   = height / 2
  self.leftTextColor  = grayscaleContrastColor(colorLeft, 166)
  self.rightTextColor = grayscaleContrastColor(colorRight, 166)
  self.font           = font
  self.sides          = {
    left  = Side(0,                0, self.centerWidth, self.height, colorLeft),
    right = Side(self.centerWidth, 0, self.centerWidth, self.height, colorRight)
  }
  self.mouse = { x = nil, y = nil}
end

function Info:update(dt)
  if self.mouse.x ~= nil and self.mouse.y ~= nil then self:setNext(GlobalStates.settings) end
end

function Info:mousepressed(x, y, button, isTouch)
  if button == 1 then
    self.mouse.x = x
    self.mouse.y = y
  end
end

function Info:draw()
  love.graphics.setFont(self.font)
  self.sides.left:draw()
  self.sides.right:draw()
  love.graphics.setColor(0, 0, 0, 222)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(WHITE)
  love.graphics.printf("Game wrote with LOVE\nby\nIvan Azoyan\n\nivanazoyan.ru\nivanazoyan@gmail.com\n", self.x, self.y + self.centerHeight - self.font:getHeight() * 2, self.width, "center")

end

return Info
