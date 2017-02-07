require 'colors'

local Side      = require 'actors/side'
local State     = require 'states/state'
local Menu      = require 'states/menu'
local Game      = require 'states/game'
local Settings  = require 'states/settingsMenu'
local Info      = require 'states/info'

function love.load()
  math.randomseed(os.time())
  --love.window.setMode(320, 240, flags)
  --love.window.setMode(640, 480, flags)
   --love.window.setMode(1024, 768, flags)
  love.window.setMode(800, 600, {resizable = true})
  init()
end

function love.resize(w, h)
  init()
end

function init()
  x = 0
  y = 0
  width  = love.graphics.getWidth()
  height = love.graphics.getHeight()

  centerWidth = width / 2

  timelineWidth = width / 16

  highscoreFont =
  love.graphics.newFont("assets/joystixmonospace.ttf", timelineWidth / 2)

  generalFont   =
  love.graphics.newFont("assets/origap__.ttf" ,timelineWidth)

  supportFont   =
  love.graphics.newFont("assets/arigami2.otf" ,timelineWidth / 1.5)

  local timeline = 0
  local startSpeed = 1
  local startScore = 0
  local speedIncrement = 10
  local level = 1
  highscoreWidth = timelineWidth

  userChoice = nil
  mouse = { x = nil, y = nil }
  yourScore     = "YOUR SCORE: "
  tapToRestart  = "TAP TO RESTART"

  local maxHorizontalCount = math.floor(centerWidth / highscoreWidth)
  currentState = Menu(x, y, width - 1, height, randomColor(), randomColor(), generalFont)

end

function flush()
  leftEndRectangle   = { x = -centerWidth, y = 0, width = centerWidth, height = height, color = randomColor() }
  rightEndRectangle  = { x =  width, y = 0, width = centerWidth, height = height, color = randomContrastColor(leftEndRectangle.color) }
  blinkColor         = { 160, 160, 160, 160 }
  shouldListenEvents = true
end

function love.update(dt)
  if     currentState.next == GlobalStates.settings then currentState = Settings(x, y, width, height, randomColor(), randomColor(), generalFont)
  elseif currentState.next == GlobalStates.game     then currentState = Game(x, y, width, height, maxHorizontalCount, timeline, startSpeed, startScore, highscoreFont, speedIncrement, level)
  elseif currentState.next == GlobalStates.menu     then currentState = Menu(x, y, width, height, randomColor(), randomColor(), generalFont)
  elseif currentState.next == GlobalStates.info     then currentState = Info(x, y, width, height, randomColor(), randomColor(), supportFont)
  end
  currentState:update(dt)
  print(currentState.name)
end

function love.mousepressed(x, y, button, isTouch)
  currentState:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
  currentState:mousereleased(x, y, button, isTouch)
end

function love.keypressed(key)
  currentState:keypressed(key)
end

function love.draw()
  currentState:draw()
end
