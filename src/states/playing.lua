-- this is the primary state, the pattern editor

local playing = {}

-- where is the cursor?
local currentRow = 0
local currentColumn = 0
local currentTrack = 0

-- dummy pattern for testing
-- note, instrument, effects
local patternData = {
  {
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil
  },
  {
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil
  },
  {
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil
  },
  {
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xC, 0x01, 0 },
    nil,
    nil,
    nil,
    { 0xD, 0x01, 0 },
    nil,
    nil,
    nil
  }
}

-- show 1 screen of pattern
function displayPattern(pattern, offset)
  if offset == nil then
    offset = 0
  end
  love.graphics.setFont(songfont)
  
  -- previous pattern text
  love.graphics.setColor(colors.textNotCurrent)
  love.graphics.print("C ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 0)
  love.graphics.print("D ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 10)
  love.graphics.print("E ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 20)
  love.graphics.print("F ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 30)

  local track
  local t
  local note
  local n

  -- TODO: need to work out this loop
  -- for t,track in pairs(patternData) do
  --   for n,note in pairs(track) do
  --     if note ~= nil then
  --       print('track:' .. t .. ' note (' .. n .. '): ' .. note[1] .. ' ' .. note[2] .. ' ' .. note[3])
  --     else
  --       print('---')
  --     end
  --   end
  -- end


  -- current pattern text
  love.graphics.setColor(colors.text)
  love.graphics.print("0 C-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 40)
  love.graphics.print("1 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 50)
  love.graphics.print("2 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 60)
  love.graphics.print("3 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 70)
  love.graphics.print("4 ••••• -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 80)
  love.graphics.print("5 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 90)
  love.graphics.print("6 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 100)
  love.graphics.print("7 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 110)
  love.graphics.print("8 D-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 120)
  love.graphics.print("9 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 130)
  love.graphics.print("A ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 140)
  love.graphics.print("B ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 150)
  love.graphics.print("C ••••• -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 160)
  love.graphics.print("D ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 170)
  love.graphics.print("E ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 180)
  love.graphics.print("F ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 190)

  -- next pattern text
  love.graphics.setColor(colors.textNotCurrent)
  love.graphics.print("0 C-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 200)
  love.graphics.print("1 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 210)
  love.graphics.print("2 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 220)
  love.graphics.print("3 ----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 230)
end


function playing:draw()
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

  displayPattern(patternData)
end

function playing:update(dt)
  if currentlyPlaying then
    currentRow = currentRow + 1
    if currentRow > 0xf then
      currentRow = 0
    end
  end
end

-- handle input
function playing:pressed(button)
  if button == "start" then
    currentlyPlaying = not currentlyPlaying
  end

  if button == 'left' then
    if currentColumn ~= 0 then
    currentColumn = currentColumn - 1
    else
      currentColumn = 11
    end
  end
  
  if button == 'right' then
    if currentColumn ~= 11 then
      currentColumn = currentColumn + 1
    else
      currentColumn = 0
    end
  end
  
  if button == 'up' then
    if currentRow ~= 0 then
      currentRow = currentRow - 1
    else
      currentRow = 0xf
    end
  end
  
  if button == 'down' then
    if currentRow ~= 0xf then
      currentRow = currentRow + 1
    else
      currentRow = 0
    end
  end
  currentTrack = math.floor(currentColumn/3)
end

return playing