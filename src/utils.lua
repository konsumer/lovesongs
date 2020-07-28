-- global util

local StateFileBrowser = require "states.filebrowser"

fbrowse = {
  title = "",
  onEnd = function(filename) end,
  glob = "*",

}

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

-- mounts a real file-location zip-file
-- https://love2d.org/wiki/love.filesystem.mount
function openZip(filename, mountpoint)
  if mountpoint == mil then
    mountpoint = 'zip'
  end
  filedata = io.open (filename, 'rb')
  return love.filesystem.mount(filedata, mountpoint)
end

-- wrapper to show a file dialog
function showFileBrowser(title, onEnd, glob, location)
  fbrowse.title = title
  fbrowse.onEnd = onEnd
  Gamestate.switch(StateFileBrowser)
end