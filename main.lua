function love.load()
  math.randomseed(os.time())
  
  --love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=800, minheight=600})
  height        = love.graphics.getHeight()
  centerHeight  = height / 2
  centerWidth   = love.graphics.getWidth() / 2
  highscoreFont = love.graphics.newFont(72)
  endFont       = love.graphics.newFont(48)

  yourScore     = "Your score "
  tapToRestart  = "tap to restart"

  love.graphics.setFont(highscoreFont)
  
  maxCount = 10
  newGame()


end

function newGame()
  sides = createSides()
  timeline = 0
  speed = 1
  gameOver = false
  highscore = "00"
  pause = false
  userChoice = nil
end

function randomColor()
  return { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
end

function love.update(dt)
  if pause then return end

  gameOver = timeline > height
  timeline = timeline + speed
  if not gameOver and userChoice then 
    if checkChoice(userChoice) then 
      newSides()
    else
      decreaseTime()
    end
  userChoice = nil
  end
end

function love.mousepressed(x, y, button, isTouch)
  if gameOver then newGame() return end
  if button == 1 then    
    if     x < centerWidth then userChoice = "left"
    elseif x > centerWidth then userChoice = "right"
    end
  end
end

function love.keypressed(key)
  if key == "p" then pause = not pause end  
  if pause then return end

  if key == "n" or gameOver then newGame()         end
  if key == "escape"        then love.event.quit() end

  if key == "left" 
  or key == "right" 
  then
    userChoice = key  
  end

end

function checkChoice(userChoice)
  return userChoice == "left"  and shouldLeft() or userChoice == "right" and shouldRight()  
end

function shouldLeft()  return sides.left.figures.count > sides.right.figures.count end
function shouldRight() return sides.left.figures.count < sides.right.figures.count end

function decreaseTime()
  timeline = timeline + height / 2
end

function newSides()
  highscore = highscore + 1
  if highscore < 10 then highscore = "0" .. highscore end
  sides = createSides()
  timeline = timeline / speed
  increaseSpeed()
end

function increaseSpeed()
  if speed < 5 then speed = speed + 1
  else speed = speed + 0.25
  end
end

function createSides()  
  local sides = {}
  local left  = {}
  local right = {}

  left.x       = 0
  left.y       = 0
  left.color   = randomColor()
  left.figures = createFigures(left.color)

  right.x       = centerWidth
  right.y       = 0
  right.color   = randomColor()
  right.figures = createFigures(right.color)


  panicLimit = 10
  currentSteps = 0

  while left.figures.count == right.figures.count do
    right.figures = createFigures(right.color)

    currentSteps = currentSteps + 1
    if currentSteps > panicLimit then
      assert(false, "to long generation of unique values of figures count")
    end
  end

  sides.left  = left
  sides.right = right  

  return sides
end

function inverseColor(color)
  local r, g, b = color[1], color[2], color[3]  
  return { 255 - r, 255 - g, 255 - b }
end

function createFigures(color)  
  local figures  = {}
  figures.count  = math.random(1, maxCount)
  figures.color  = inverseColor(color)
  figures.width  = centerWidth / maxCount / 2
  figures.height = figures.width  
  return figures
end

function love.draw()
    drawSide(sides.left)
    drawSide(sides.right)
    drawTimeline()
    drawScore()
  if gameOver then      
    love.graphics.setColor(0, 0, 0, 225)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(yourScore .. highscore, 0, centerHeight - 64, love.graphics.getWidth(), 'center')
    love.graphics.setColor(255, 255, 255, 122)
    love.graphics.printf(tapToRestart, 0, centerHeight + 64, love.graphics.getWidth(), 'center')    
  end
end

function drawBackground(side)
  love.graphics.setColor(side.color)
  love.graphics.rectangle("fill", side.x, side.y, centerWidth, height)
end

function drawSide(side)  
  drawBackground(side)
  drawFigures(side.x, side.figures)
end

function drawFigures(startPosition, figures)
  love.graphics.setColor(figures.color)
  for i = 0, figures.count - 1 do
    --love.graphics.rectangle("fill", startPosition + i * figures.width, centerHeight, figures.width / 2, figures.height / 2)
    love.graphics.rectangle("fill", 
      startPosition + figures.width / 2 + i * figures.width * 2, centerHeight
      , figures.width, figures.height
      ,figures.width / 8)
  end
end

function drawTimeline()
  love.graphics.setColor(timeline / 2, timeline / 4, timeline / 4)
  local thickness = highscoreFont:getWidth(highscore) / 4
  local x         = centerWidth - thickness / 2
  local y         = height  

  love.graphics.rectangle("fill", x, 0, thickness,   timeline / 2)
  love.graphics.rectangle("fill", x, y, thickness, - timeline / 2)
end

function drawScore()
  love.graphics.setColor(225, 225, 225) 
  local width = highscoreFont:getWidth(highscore);
  love.graphics.rectangle("fill", centerWidth - width / 2, 0 + width / 2, width, width, width / 10)
  love.graphics.setColor(0, 0, 0, 127)  
  love.graphics.printf(highscore, 0, 0 + width / 2, love.graphics.getWidth(), 'center')
end
