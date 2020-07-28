-- global util
local StateFileBrowser = require "states.filebrowser"

-- print a table, for debugging
function tprint (t, s)
  for k, v in pairs(t) do
      local kfmt = '["' .. tostring(k) ..'"]'
      if type(k) ~= 'string' then
          kfmt = '[' .. k .. ']'
      end
      local vfmt = '"'.. tostring(v) ..'"'
      if type(v) == 'table' then
          tprint(v, (s or '')..kfmt)
      else
          if type(v) ~= 'string' then
              vfmt = tostring(v)
          end
          print(type(t)..(s or '')..kfmt..' = '..vfmt)
      end
  end
end

-- print JSON, for debugging
function jprint(o)
  print(json.encode(o))
end

-- check if a table has a value
local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- display hex-value of number
function showHex(n, pad)
  if pad == nil then
    pad = 2
  end
  return string.upper(string.format("%0"..pad.."x", n))
end

-- show a note-name of a MIDI number
function showNote(n)
  local notes = {"C-", "C#", "D-", "D#", "E-", "F-", "F#", "G-", "G#", "A-", "A#", "B-"}
  local octave = math.floor(n / 12) - 1
  return string.format("%s%d", notes[(n % 12)+1], octave)
end

-- TODO: move these into fs?

-- mounts a real file-location of a zip-file to a save-dir
-- https://love2d.org/wiki/love.filesystem.mount
function mountZip(filename, mountpoint)
  if mountpoint == nil then
    mountpoint = 'zip'
  end
  -- using luajit io, so I can open files outside of love save-dirs
  local f = io.open(filename, 'r')
  local filedata = love.filesystem.newFileData(f:read("*all"), filename)
  f:close()
  return love.filesystem.mount(filedata, mountpoint)
end

-- wrapper to show a file dialog
function showFileBrowser(onOk, onCancel, title, filter)
  local callingState = Gamestate.current()
  if filter then
    fbrowse.filter = filter
  else
    fbrowse.filter = "*.*"
  end
  fbrowse.onOk = onOk or print
  fbrowse.title = title or "Choose a file"
  fbrowse.onCancel = onCancel or function() Gamestate.switch(callingState) end
  Gamestate.switch(StateFileBrowser)
end

-- load a lovesong
function loadSong(filename)
  if not mountZip(filename, "song") then
    print("error opening "..filenam)
  end

  song = json.decode(love.filesystem.read("song/song.json"))
  print('Loading "'..song.name..'" by '..song.author)

  local patternCache = {}

  -- unroll the song
  for p,pattern in pairs(song.patterns) do
    song.patterns[p] = patternCache[pattern] or json.decode(love.filesystem.read("song/patterns/" .. pattern .. ".json"))
    patternCache[pattern] = song.patterns[p]
  end
  song.instruments = {}
  for p,pattern in pairs(patternCache) do
    for t, track in pairs(pattern) do
      for n, note in pairs(track) do
        if not song.instruments[ note[2] ] then
          if note[2] ~= 0 then
            song.instruments[ note[2] ] = json.decode(love.filesystem.read("song/instruments/" .. note[2] .. ".json"))
          end
        end
      end
    end
  end
  -- TODO: load samples
  currentPattern = 1
end