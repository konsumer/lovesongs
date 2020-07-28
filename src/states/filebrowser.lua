-- this is the state for the file-browse dialog

local filebrowser = {}

local currentDirectory = fs.home
local currentFiles = {}
local currentDirs = {}
local currentTotal = 0
local currentSelection = 1

local camera = Camera(160, 120)

function filebrowser:updateFiles()
  currentFiles = {}
  currentDirs = {}
  local f
  for f in fs:ls(currentDirectory) do
    if string.sub(f, -1) == '/' then
      table.insert(currentDirs, f)
    else
      table.insert(currentFiles, f)
    end
  end
  if currentDirectory ~= "/" then
    table.insert(currentDirs, 1, "../")
  end
  currentTotal = #currentFiles + #currentDirs
end

-- called every time this state is entered
function filebrowser:enter()
  currentSelection = 1
  filebrowser:updateFiles()
end

-- called to update the logical representation of things
function filebrowser:update(dt)
  -- start scrolling at the middle of the screen
  if currentSelection > 11 then
    camera:move(0, 10 + (10 * currentSelection) - camera.y)
  end
end

-- called once every draw
function filebrowser:draw()
  love.graphics.setColor(colors.background)
  love.graphics.rectangle("fill", 0, 0, 320, 240 )

  -- draw this part inside scrolling camera
  camera:attach()
    
  -- mark current row
  love.graphics.setColor(colors.currentRow)
  love.graphics.rectangle("fill", 0, (currentSelection + 1) * 10, 320, 10 )

  love.graphics.setColor(colors.text)
  for d,dir in pairs(currentDirs) do
    love.graphics.print(dir, 15, (d * 10) + 10)
  end
  for f,file in pairs(currentFiles) do
    love.graphics.print(file, 15, ((f + #currentDirs) * 10) + 10)
  end

  camera:detach()

  love.graphics.setColor(colors.background)
  love.graphics.rectangle("fill", 0, 0, 320, 10 )
  love.graphics.setColor(colors.text)
  love.graphics.print(fbrowse.title, 10, 0)
end

-- handle input
function filebrowser:pressed(button)
  if button == 'up' and currentSelection > 1 then
    currentSelection = currentSelection - 1
  end
  if button == 'down' and currentSelection < currentTotal then
    currentSelection = currentSelection + 1
  end
  if button == 'a' or button == 'start' then
    if currentSelection > #currentDirs then
      fbrowse.onEnd(currentDirectory .. '/' .. currentFiles[currentSelection-#currentDirs])
    else
      currentDirectory = currentDirectory .. '/' .. currentDirs[currentSelection]
      currentSelection = 1
      filebrowser:updateFiles()
    end
  end
  if button == 'b' then
  end
end

return filebrowser