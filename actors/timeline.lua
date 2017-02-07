
local Timeline = {}
Timeline.__index = Timeline

setmetatable(Timeline, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

function Timeline:_new(x, y, width, height, leftColor, rightColor, speed)
  self.x 			      = x
  self.y 			      = y
  self.width 		    = width
  self.height 	    = height
  self.elapsedTime  = 0
  self.criticalTime = height
  


  self:setColors(leftColor, rightColor)
  self.speed        = speed
end

function Timeline:update(dt)
  self.elapsedTime = self.elapsedTime + self.speed
end

function Timeline:isTimeOver(dt)
  return self.elapsedTime > self.criticalTime
end

function Timeline:setSpeed(speed)
  self.speed = speed
end

function Timeline:setColors(left, right)
  self.leftColor  = {  left[1],  left[2],  left[3], 32 }
  self.rightColor = { right[1], right[2], right[3], 32 }
end

function Timeline:setTime(time)
  self.elapsedTime = time
end

function Timeline:draw()
  local thickness = self.width / 2
  local leftX     = self.x - thickness
  local rightX    = self.x + thickness
  local centerY   = self.elapsedTime / 2
  self:drawLine(leftX, rightX, thickness, centerY)
end

function Timeline:drawLine(leftX, rightX, thickness, centerY, color)
    love.graphics.setColor(self.leftColor)
    love.graphics.rectangle("fill", leftX,      0, thickness,   centerY)
    love.graphics.rectangle("fill", leftX, self.height, thickness, - centerY)

    love.graphics.setColor(self.rightColor)
    love.graphics.rectangle("fill", self.x,      0, thickness,   centerY)
    love.graphics.rectangle("fill", self.x, self.height, thickness, - centerY)
end


return Timeline
