local State = {}
State.__index = State

setmetatable(State, {
  	__call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_new(...)
    return self
  end,
})

GlobalStates = { menu = "menu", game = "game", settings = "settings", gameOver = "gameOver", pause = "pause", info = "info" }

function State:_new(x, y, width, height, name)
  self.x 			= x
  self.y 			= y
  self.width 	= width
  self.height = height
  self.next   = nil
  self.name   = name
end

function State:update(dt)

end

function State:draw()
  love.graphics.print("DERIVE STATE")
end

function State:mousepressed(x, y, button, isTouch)

end

function State:mousereleased(x, y, button, isTouch)

end

function State:keypressed(key, scancode, isrepeat)

end

function State:next()
  return self.next
end

function State:setNext(state)
  self.next = state
end

return State
