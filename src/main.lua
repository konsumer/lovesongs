lurker = require "lib.lurker.lurker"
Gamestate = require "lib.hump.gamestate"

require "utils"
config = require "conf"
StatePlaying = require "states.playing"

-- setup globals for states to use
joystick = nil

-- theme
colors = {
  leftBar = { 0.4, 0.4, 0.4 },
  leftBarQuarter = { 0.2, 0.2, 0.2 },
  text = { 1, 1, 1 },
  textNotCurrent = { 0.5, 0.5, 0.5 },
  currentTrack = { 0.1, 0.1, 0.1 },
  currentItem = { 0.2, 0, 0 },
  currentRow = { 0.2, 0.2, 0.2 }
}

-- is it playing?
currentlyPlaying = false

function love.load()
  -- only 1 font is currently used
  love.graphics.setFont(love.graphics.newFont("assets/monoid.ttf", 10))
    
  love.keyboard.setKeyRepeat(true)
  love.mouse.setVisible(false)
  local joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  Gamestate.registerEvents()
  Gamestate.switch(StatePlaying)
end

-- this simplifies input into a single callback for keys & gamepad
function love.gamepadpressed(joystick, button)
   -- global full-exit on retropie is start+select
  if joystick and joystick:isGamepadDown('start') and joystick:isGamepadDown('back') then
    love.event.quit()
  end

  local gs = Gamestate.current()
  if gs.pressed then
    if button == 'dpup' then
      gs:pressed('up')
    end
    if button == 'dpdown' then
      gs:pressed('down')
    end
    if button == 'dpleft' then
      gs:pressed('left')
    end
    if button == 'dpright' then
      gs:pressed('right')
    end
    if button == 'a' then
      gs:pressed('a')
    end
    if button == 'b' then
      gs:pressed('b')
    end
    if button == 'x' then
      gs:pressed('x')
    end
    if button == 'y' then
      gs:pressed('y')
    end
    if button == 'start' then
      gs:pressed('start')
    end
    if button == 'back' then
      gs:pressed('back')
    end
    if button == 'leftshoulder' then
      gs:pressed('l')
    end
    if button == 'rightshoulder' then
      gs:pressed('r')
    end
  end
end

function love.keypressed(key, code)
  -- global full-exit on retropie is start+select
  if love.keyboard.isDown('return') and love.keyboard.isDown('escape') then
    love.event.quit()
  end

  local gs = Gamestate.current()
  if gs.pressed then
    if key == 'up' then
      gs:pressed('up')
    end
    if key == 'down' then
      gs:pressed('down')
    end
    if key == 'left' then
      gs:pressed('left')
    end
    if key == 'right' then
      gs:pressed('right')
    end
    if key == 'z' then
      gs:pressed('a')
    end
    if key == 'x' then
      gs:pressed('b')
    end
    if key == 'a' then
      gs:pressed('x')
    end
    if key == 's' then
      gs:pressed('y')
    end
    if key == 'return' then
      gs:pressed('start')
    end
    if key == 'escape' then
      gs:pressed('back')
    end
    if key == 'pageup' then
      gs:pressed('l')
    end
    if key == 'pagedown' then
      gs:pressed('r')
    end
  end
end

function love.gamepadreleased(joystick, button)
  local gs = Gamestate.current()
  if gs.released then
    if button == 'dpup' then
      gs:released('up')
    end
    if button == 'dpdown' then
      gs:released('down')
    end
    if button == 'dpleft' then
      gs:released('left')
    end
    if button == 'dpright' then
      gs:released('right')
    end
    if button == 'a' then
      gs:released('a')
    end
    if button == 'b' then
      gs:released('b')
    end
    if button == 'x' then
      gs:released('x')
    end
    if button == 'y' then
      gs:released('y')
    end
    if button == 'start' then
      gs:released('start')
    end
    if button == 'back' then
      gs:released('back')
    end
    if button == 'leftshoulder' then
      gs:released('l')
    end
    if button == 'rightshoulder' then
      gs:released('r')
    end
  end
end

function love.keyreleased(key, code)
  local gs = Gamestate.current()
  if gs.released then
    if key == 'up' then
      gs:released('up')
    end
    if key == 'down' then
      gs:released('down')
    end
    if key == 'left' then
      gs:released('left')
    end
    if key == 'right' then
      gs:released('right')
    end
    if key == 'z' then
      gs:released('a')
    end
    if key == 'x' then
      gs:released('b')
    end
    if key == 'a' then
      gs:released('x')
    end
    if key == 's' then
      gs:released('y')
    end
    if key == 'return' then
      gs:released('start')
    end
    if key == 'escape' then
      gs:released('back')
    end
    if key == 'pageup' then
      gs:released('l')
    end
    if key == 'pagedown' then
      gs:released('r')
    end
  end
end

function love.update(dt)  
  -- hot-reloading
  if config.hot_reload then
    lurker.update()
  end
end
