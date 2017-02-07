local Side         = require 'actors/side'
local Timeline     = require 'actors/timeline'
local State        = require 'states/state'
local ToggleButton = require 'actors/toggleButton'
local PushButton   = require 'actors/pushButton'

require 'colors'

local Settings = {}

for k, v in pairs(State) do Settings[k] = v end
Settings.__index = Settings

setmetatable(Settings, {
    __index = State,
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Settings:_new(x, y, width, height, colorLeft, colorRight, font)
  State._new(self, x, y, width, height, "Settings")
  self.centerWidth    = width / 2
  self.centerHeight   = height / 2
  self.leftTextColor  = grayscaleContrastColor(colorLeft, 166)
  self.rightTextColor = grayscaleContrastColor(colorRight, 166)
  self.font           = font
  self.sides          = {
    left  = Side(0,                0, self.centerWidth, self.height, colorLeft),
    right = Side(self.centerWidth, 0, self.centerWidth, self.height, colorRight)
  }
  self.timeline = Timeline(self.centerWidth, self.y, self.width /16, self.height, self.leftTextColor, self.rightTextColor, 1)
  self.sound    = { isEnabled = true,  status = "ON" }
  self.music    = { isEnabled = false, status = "OFF"}
  self.mouse    = { x = nil, y = nil }
  self.clicked  = false
  self.buttons  = {
    soundButton = ToggleButton("SOUND"
                        ,self.x
                        ,self.centerHeight / 2 - self.font:getHeight()
                        ,self.x + self.centerWidth
                        ,self.y + self.centerHeight / 2 + self.font:getHeight()
                        ,self.leftTextColor
                        ,TRANSPARENT
                        ,self.font)

    , musicButton = ToggleButton("MUSIC"
                        ,self.x
                        ,self.centerHeight - self.font:getHeight()
                        ,self.x + self.centerWidth
                        ,self.y + self.centerHeight + self.font:getHeight()
                        ,self.leftTextColor
                        , {0,0,0,0}
                        ,self.font)

    , infoButton = PushButton("INFO"
                        ,self.x
                        ,self.centerHeight * 1.5 - self.font:getHeight()
                        ,self.x + self.centerWidth
                        ,self.y + self.centerHeight * 1.5 + self.font:getHeight()
                        ,self.leftTextColor
                        ,TRANSPARENT
                        ,self.font)
  }
end

function Settings:mousepressed(x, y, button, isTouch)
  self.mouse.x = x
  self.mouse.y = y

  local b = true
  for _, button in pairs(self.buttons) do
    if button:mousepressed(self.mouse.x, self.mouse.y) then b = false end
  end
  self.clicked = b
end

function Settings:update(dt)
  self.timeline:update(dt)
  if self.timeline:isTimeOver()
  then
    self.timeline:setTime(0)
    self:setNext(GlobalStates.menu)
  end

  self.sound.isEnabled = self.buttons.soundButton:toggledOn()
  self.music.isEnabled = self.buttons.musicButton:toggledOn()

  if self.buttons.infoButton.isClicked then self:setNext(GlobalStates.info) end

  if self.clicked then
    local time = (self.timeline.elapsedTime < (self.timeline.criticalTime / 2))
                and self.timeline.criticalTime - self.timeline.elapsedTime
                 or self.timeline.elapsedTime * 1.5
    self.timeline:setTime(time)
  end

  self.clicked = false

  self.mouse.x = nil
  self.mouse.y = nil
end

function Settings:draw()
  love.graphics.setColor(self.sides.left.color)
  love.graphics.rectangle("fill", self.x, self.y, self.centerWidth, self.height)
  love.graphics.setColor(self.sides.right.color)
  love.graphics.rectangle("fill", self.centerWidth, self.y, self.centerWidth, self.height)

  love.graphics.setColor(self.rightTextColor)
  love.graphics.printf("BEST: 100", self.centerWidth + self.font:getHeight() / 2, self.centerHeight  / 2 - self.font:getHeight() / 2, self.centerWidth, "left")
  for _, button in pairs(self.buttons) do button:draw() end
  self.timeline:draw()
end

return Settings
