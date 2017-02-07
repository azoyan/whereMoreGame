









function updateGameOver(dt)
  shouldListenEvents = leftEndRectangle.x >= 0
  if shouldListenEvents and userChoice then state = states.menu return endxX

  timeline = timeline - timelineWidth

  if     leftEndRectangle.x < 0 then leftEndRectangle.x = leftEndRectangle.x + timelineWidth / 4
  elseif leftEndRectangle.x > 0 then leftEndRectangle.x = 0
  end

  if     rightEndRectangle.x > centerWidth then rightEndRectangle.x = rightEndRectangle.x - timelineWidth / 4
  elseif rightEndRectangle.x < centerWidth then rightEndRectangle.x = centerWidth
  end
end


function drawGameOverScreen()
  love.graphics.setFont(supportFont)

  love.graphics.setColor(0, 0, 0, 212)
  love.graphics.rectangle("fill", 0, 0, width, height)

  love.graphics.setColor(leftEndRectangle.color)
  love.graphics.rectangle("fill", leftEndRectangle.x, leftEndRectangle.y, leftEndRectangle.width, leftEndRectangle.height)

  love.graphics.setColor(rightEndRectangle.color)
  love.graphics.rectangle("fill", rightEndRectangle.x, rightEndRectangle.y, rightEndRectangle.width, rightEndRectangle.height)

  love.graphics.setColor(inverseColor(leftEndRectangle.color))

  love.graphics.printf(yourScore, leftEndRectangle.x, centerHeight - supportFont:getHeight() / 2, centerWidth, 'center')

  love.graphics.setColor(inverseColor(rightEndRectangle.color))
  love.graphics.printf(highscore, rightEndRectangle.x, centerHeight - supportFont:getHeight() / 2, centerWidth, 'center')

  love.graphics.setColor(blinkColor)
--  love.graphics.printf(tapToRestart, 0, centerHeight + supportFont:getHeight() / 2, love.graphics.getWidth(), 'center')
end