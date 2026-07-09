-- data/chords.lua
-- Semitone interval tables for all built-in chord types.
-- Intervals are relative offsets from the root note (root = 0).

local M = {}

M.chords = {
  { name = "Power",      intervals = { 0, 7 } },
  { name = "Major",      intervals = { 0, 4, 7 } },
  { name = "Minor",      intervals = { 0, 3, 7 } },
  { name = "Diminished", intervals = { 0, 3, 6 } },
  { name = "Augmented",  intervals = { 0, 4, 8 } },
  { name = "Sus2",       intervals = { 0, 2, 7 } },
  { name = "Sus4",       intervals = { 0, 5, 7 } },
  { name = "Octave",     intervals = { 0, 12 } },
  { name = "Major 7",    intervals = { 0, 4, 7, 11 } },
  { name = "Minor 7",    intervals = { 0, 3, 7, 10 } },
  { name = "Dom 7",      intervals = { 0, 4, 7, 10 } },
}

-- Returns a list of chord name strings (for popup/chooser items)
function M.get_names()
  local names = {}
  for i, c in ipairs(M.chords) do
    names[i] = c.name
  end
  return names
end

-- Returns the interval table for chord index idx (1-based)
function M.get_intervals(idx)
  return M.chords[idx] and M.chords[idx].intervals or { 0, 4, 7 }
end

return M
