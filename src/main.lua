globtopattern = require "lib.globtopattern"
json = require "lib.json"
lurker = require "lib.lurker.lurker"
Gamestate = require "lib.hump.gamestate"
Camera = require "lib.hump.camera"

require "inputmap"
fs = require "fs"
require "utils"
config = require "conf"
StatePlaying = require "states.playing"

-- theme
colors = {
  leftBar = { 0.4, 0.4, 0.4 },
  leftBarQuarter = { 0.2, 0.2, 0.2 },
  text = { 1, 1, 1 },
  textNotCurrent = { 0.5, 0.5, 0.5 },
  currentTrack = { 0.1, 0.1, 0.1 },
  currentItem = { 0.2, 0, 0 },
  currentRow = { 0.2, 0.2, 0.2 },
  background = {0, 0, 0}
}

-- is it playing?
currentlyPlaying = false

-- track current song structure
currentSong = {}
currentPattern = {}
currentInstruments = {}

-- load the song into current memory and switch to edit view
function songChosen(filename)
  loadSong(filename)
  Gamestate.switch(StatePlaying)
end

function love.load()
  -- only 1 font is currently used
  love.graphics.setFont(love.graphics.newFont("assets/monoid.ttf", 10))
    
  love.keyboard.setKeyRepeat(true)
  love.mouse.setVisible(false)
  Gamestate.registerEvents()
  showFileBrowser(songChosen, function() print("cancelled.") end, "Please select a song", "*.lovesong")
end


function input_pressed(button)
  local gs = Gamestate.current()
  if gs.pressed then
    gs:pressed(button)
  end
end

function input_released(button)
  local gs = Gamestate.current()
  if gs.released then
    gs:released(button)
  end
end

function love.update(dt)  
  -- hot-reloading
  if config.hot_reload then
    lurker.update()
  end
end
