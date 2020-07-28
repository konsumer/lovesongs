-- this is the primary state, the pattern editor

local playing = {}

-- where is the cursor?
local currentRow = 0
local currentColumn = 0
local currentTrack = 0
currentPattern = 1

-- track current state of various buttons being up/down for modality
local inputModals = {
  a = false,
  b = false,
  x = false,
  y = false
}

-- holds array of tracks with { note, instrument, volume, effects }
-- this set initial value, so view doesn't crash
song = { patterns = {} }
for t=1,4 do
  song.patterns[t] = {}
  for n=1,16 do
    song.patterns[t][n] = {0, 0, 0, 0}
  end
end

-- show 1 screen of pattern
function displayPattern(pattern, offset, length)
  if offset == nil then
    offset = 1
  end
  if length == nil then
    length = 15
  end

  for n=0,(length-1),1 do
    -- line number
    local line = showHex(n % 16, 1)

    for t in pairs(pattern) do
      if t == 1 then
        line = line .. " "
      else
        line = line .. "|"
      end
      
      local currentNote = pattern[t][n+1][1]
      local currentInstrument = pattern[t][n+1][2]

      -- if the instrument is 0, then it's a flow-control message
      if currentInstrument == 0 then
        -- 0 note is "nothing here"
        if currentNote == 0 then
          line = line .. "-----" .. " -- ---"
        -- 1 note is "stop playback on this track"
        elseif currentNote == 1 then
          line = line .. "•••••" .. " -- ---"
        end
      else
        line = line .. showNote(currentNote) .. showHex(currentInstrument) .. " -- ---"
      end      
    end

    love.graphics.print(line, 0, (offset + n) * 10)
  end
end

-- called once every draw
function playing:draw()
  love.graphics.setColor(colors.background)
  love.graphics.rectangle("fill", 0, 0, 320, 240 )
  
  love.graphics.setColor(colors.leftBar)
  love.graphics.rectangle("fill", 0, 0, 6, 240 )

  -- draw quarter-marks
  love.graphics.setColor(colors.leftBarQuarter)
  love.graphics.rectangle("fill", 0, 0, 6, 10 )
  love.graphics.rectangle("fill", 0, 40, 6, 10 )
  love.graphics.rectangle("fill", 0, 80, 6, 10 )
  love.graphics.rectangle("fill", 0, 120, 6, 10 )
  love.graphics.rectangle("fill", 0, 160, 6, 10 )
  love.graphics.rectangle("fill", 0, 200, 6, 10 )

  if not currentlyPlaying then
      -- mark current track
    love.graphics.setColor(colors.currentTrack)
    love.graphics.rectangle("fill", 12 + (currentTrack * 78), 0, 74, 240 )
  end

  -- mark current row
  love.graphics.setColor(colors.currentRow)
  love.graphics.rectangle("fill", 0, (currentRow + 4) * 10, 320, 10 )

  -- mark current item
  if not currentlyPlaying then
    love.graphics.setColor(colors.currentItem)
    if currentColumn%3 == 0 then
      love.graphics.rectangle("fill", 10+ (currentTrack * 78), (currentRow + 4) * 10, 34, 10 )
    end
    if currentColumn%3 == 1 then
      love.graphics.rectangle("fill", 45+ (currentTrack * 78), (currentRow + 4) * 10, 18, 10 )
    end
    if currentColumn%3 == 2 then
      love.graphics.rectangle("fill", 65+ (currentTrack * 78), (currentRow + 4) * 10, 22, 10 )
    end
  end  

  love.graphics.setColor(colors.textNotCurrent)
  displayPattern(song.patterns[ ((currentPattern - 1) % #song.patterns) + 1 ], 0, 4)
  
  love.graphics.setColor(colors.text)
  displayPattern(song.patterns[currentPattern], 4, 16)
  
  love.graphics.setColor(colors.textNotCurrent)
  displayPattern(song.patterns[ (currentPattern + 1) % #song.patterns ], 20, 4)
end

-- called to update the logical representation of things
function playing:update(dt)
  -- increment cursor if playing
  if currentlyPlaying then
    currentRow = currentRow + 1
    if currentRow > 0xf then
      currentRow = 0
    end
  end
end

-- handle input
function playing:pressed(button)
  -- handle modals
  if inputModals[button] ~= nil then
    inputModals[button] = true
  end

  if button == "start" then
    if inputModals.a then
    elseif inputModals.b then
    elseif inputModals.x then
    elseif inputModals.y then
    else
      currentlyPlaying = not currentlyPlaying
    end
  end

  if button == 'left' then
    if inputModals.a then
      patternData[currentTrack+1][currentRow+1][1] =  (patternData[currentTrack+1][currentRow+1][1] - 1) % 127
    elseif inputModals.b then
    elseif inputModals.x then
    elseif inputModals.y then
    else
      if currentColumn ~= 0 then
        currentColumn = currentColumn - 1
      else
        currentColumn = 11
      end
    end
  end
  
  if button == 'right' then
    if inputModals.a then
      patternData[currentTrack+1][currentRow+1][1] =  (patternData[currentTrack+1][currentRow+1][1] + 1) % 127
    elseif inputModals.b then
    elseif inputModals.x then
    elseif inputModals.y then
    else
      if currentColumn ~= 11 then
        currentColumn = currentColumn + 1
      else
        currentColumn = 0
      end
    end
  end
  
  if button == 'up' then
    if inputModals.a then
    elseif inputModals.b then
    elseif inputModals.x then
    elseif inputModals.y then
    else
      if currentRow ~= 0 then
        currentRow = currentRow - 1
      else
        currentRow = 0xf
      end
    end
  end
  
  if button == 'down' then
    if inputModals.a then
    elseif inputModals.b then
    elseif inputModals.x then
    elseif inputModals.y then
    else
      if currentRow ~= 0xf then
        currentRow = currentRow + 1
      else
        currentRow = 0
      end
    end
  end

  currentTrack = math.floor(currentColumn/3)
end

function playing:released(button)
  -- handle modals
  if inputModals[button] ~= nil then
    inputModals[button] = false
  end
end

return playing
