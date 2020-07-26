-- this is the primary state, the pattern editor

local playing = {}

-- theme
local colors = {
  leftBar = { 0.4, 0.4, 0.4 },
  leftBarQuarter = { 0.2, 0.2, 0.2 },
  text = { 1, 1, 1 },
  textNotCurrent = { 0.5, 0.5, 0.5 },
  currentTrack = { 0.1, 0.1, 0.1 },
  currentItem = { 0.2, 0, 0 },
  currentRow = { 0.2, 0.2, 0.2 }
}

local currentRow = 0
local currentColumn = 0
local currentTrack = 0
local currentlyPlaying = false

function playing:draw()
  love.graphics.setColor(colors.leftBar)
  love.graphics.rectangle("fill", 0, 0, 12, 240 )

  -- draw quarter-marks
  love.graphics.setColor(colors.leftBarQuarter)
  love.graphics.rectangle("fill", 0, 0, 12, 10 )
  love.graphics.rectangle("fill", 0, 40, 12, 10 )
  love.graphics.rectangle("fill", 0, 80, 12, 10 )
  love.graphics.rectangle("fill", 0, 120, 12, 10 )
  love.graphics.rectangle("fill", 0, 160, 12, 10 )
  love.graphics.rectangle("fill", 0, 200, 12, 10 )

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

  -- currently just draws a mock-up

  love.graphics.setFont(songfont)

  -- previous pattern text
  love.graphics.setColor(colors.textNotCurrent)
  love.graphics.print("0C----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 0)
  love.graphics.print("0D----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 10)
  love.graphics.print("0E----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 20)
  love.graphics.print("0F----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 30)


  -- current pattern text
  love.graphics.setColor(colors.text)
  love.graphics.print("00C-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 40)
  love.graphics.print("01----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 50)
  love.graphics.print("02----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 60)
  love.graphics.print("03----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 70)
  love.graphics.print("04••••• -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 80)
  love.graphics.print("05----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 90)
  love.graphics.print("06----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 100)
  love.graphics.print("07----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 110)
  love.graphics.print("08D-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 120)
  love.graphics.print("09----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 130)
  love.graphics.print("0A----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 140)
  love.graphics.print("0B----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 150)
  love.graphics.print("0C••••• -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 160)
  love.graphics.print("0D----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 170)
  love.graphics.print("0E----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 180)
  love.graphics.print("0F----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 190)
  
  -- next pattern text
  love.graphics.setColor(colors.textNotCurrent)
  love.graphics.print("00C-401 -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 200)
  love.graphics.print("01----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 210)
  love.graphics.print("02----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 220)
  love.graphics.print("03----- -- ---|----- -- ---|----- -- ---|----- -- ---|----- -- ---", 0, 230)
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