local State = require "states/state"

local Pause = {}
Pause.__index = Pause

setmetatable(Pause, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

for k, v in pairs(State) do Pause[k] = v end

function Pause:_new(x, y, width, height)
  State(x, y, width, height)
end

function Pause:update(dt)

end

function Pause:draw()

end

function Pause:mousepressed(x, y, button, isTouch)

end

function Pause:mousereleased(x, y, button, isTouch)

end

function Pause:keypressed(key, scancode, isrepeat)

end

return Pause
