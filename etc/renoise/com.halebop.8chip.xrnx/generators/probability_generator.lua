-- generators/probability_generator.lua
-- Module 7: Probability & Variation
-- Three tools:
--   scatter   — inject 0Y (probability) across selected region
--   humanize  — scatter small 0Q (note delay) values for loose timing
--   fill      — mark every Nth note with 0Y 80 (50% chance)

local M = {}

local function hex2(v)
  return string.format("%02X", math.max(0, math.min(255, math.floor(v))))
end

-- Get selected pattern line range + track index.
-- Falls back to entire pattern in selected track if no selection.
local function get_region()
  local song    = renoise.song()
  local pattern = song.selected_pattern
  local ti      = song.selected_track_index
  local sel     = song.selection_in_pattern
  local ln1, ln2
  if sel and sel.start_track == ti then
    ln1 = sel.start_line
    ln2 = sel.end_line
  else
    ln1 = 1
    ln2 = pattern.number_of_lines
  end
  return pattern:track(ti), ln1, ln2
end

-- Returns true if a pattern line has at least one note.
local function line_has_note(line)
  for _, col in ipairs(line.note_columns) do
    if col.note_string ~= "---" then
      return true
    end
  end
  return false
end

-- Insert an effect into the first available effect column on a line.
-- Shifts existing content to col2 if col1 is occupied.
local function set_effect(line, cmd, amount)
  local col1 = line:effect_column(1)
  local col2 = line:effect_column(2)
  if col1.number_string ~= "00" and col1.number_string ~= "" then
    -- Col1 occupied — use col2 if free
    if col2.number_string == "00" or col2.number_string == "" then
      col2.number_string = cmd
      col2.amount_string = hex2(amount)
    end
    -- Both occupied: silently skip (don't destroy existing data)
  else
    col1.number_string = cmd
    col1.amount_string = hex2(amount)
  end
end

-- ---------------------------------------------------------------------------
-- Probability Scatter (0Y)
-- density: 0.0–1.0 — probability that any given note line gets 0Y applied
-- prob_val: the 0Y amount (0=never 80=50% 00=always treated as 0Y FF=always)
--           Pass a raw byte value. Common: 128 = 50% chance.
-- ---------------------------------------------------------------------------
function M.scatter_probability(density, prob_val)
  local track, ln1, ln2 = get_region()
  math.randomseed(os.time())
  for ln = ln1, ln2 do
    local line = track:line(ln)
    if line_has_note(line) and math.random() < density then
      set_effect(line, "0Y", prob_val)
    end
  end
end

-- ---------------------------------------------------------------------------
-- Humanize (0Q delay jitter)
-- max_delay: maximum delay ticks added per note (1–15 typical)
-- density:   0.0–1.0 — fraction of notes that get humanized
-- ---------------------------------------------------------------------------
function M.humanize(max_delay, density)
  local track, ln1, ln2 = get_region()
  math.randomseed(os.time())
  for ln = ln1, ln2 do
    local line = track:line(ln)
    if line_has_note(line) and math.random() < density then
      local delay = math.random(1, math.max(1, max_delay))
      set_effect(line, "0Q", delay)
    end
  end
end

-- ---------------------------------------------------------------------------
-- Fill Generator
-- Marks every Nth note line with 0Y 80 (50% probability).
-- nth: integer >= 1
-- prob_val: the 0Y amount to write (default 128 = 50%)
-- ---------------------------------------------------------------------------
function M.fill_nth(nth, prob_val)
  local track, ln1, ln2 = get_region()
  nth = math.max(1, math.floor(nth))
  prob_val = prob_val or 128
  local count = 0
  for ln = ln1, ln2 do
    local line = track:line(ln)
    if line_has_note(line) then
      count = count + 1
      if count % nth == 0 then
        set_effect(line, "0Y", prob_val)
      end
    end
  end
end

return M
