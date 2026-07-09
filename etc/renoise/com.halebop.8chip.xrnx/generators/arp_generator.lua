-- generators/arp_generator.lua
-- Arp Generator: three modes for writing arpeggios into instrument phrases.
--
-- Mode 1 — Hardware (0A effect): one note per line cycling chord intervals
--           via the 0A XY effect command. Most authentic to NES/C64 hardware.
-- Mode 2 — Explicit notes: each chord note on a separate phrase line.
--           Full per-note control over velocity, probability etc.
-- Mode 3 — Script (pattrns): writes a pattrns Lua script into a
--           PLAY_SCRIPT phrase. Algorithmic, real-time, parameterized.

local chords = require("data.chords")

local M = {}

-- ---------------------------------------------------------------------------
-- Note name helpers
-- ---------------------------------------------------------------------------

local NOTE_NAMES = {
  "C-", "C#", "D-", "D#", "E-", "F-", "F#", "G-", "G#", "A-", "A#", "B-"
}

-- Convert MIDI note number (0–119) to Renoise note string, e.g. 48 → "C-4"
local function note_to_string(note)
  local octave  = math.floor(note / 12)
  local semitone = note % 12
  return NOTE_NAMES[semitone + 1] .. tostring(octave)
end

-- ---------------------------------------------------------------------------
-- Arp pattern builders
-- Each returns a flat sequence of interval indices (into a chord's interval list).
-- The sequence is then repeated to fill the phrase.
-- ---------------------------------------------------------------------------

local function make_pattern(intervals, pattern_type, octave_span)
  -- Build the full note pool across octave_span octaves
  local pool = {}
  for oct = 0, octave_span - 1 do
    for _, iv in ipairs(intervals) do
      pool[#pool + 1] = iv + oct * 12
    end
  end

  local n   = #pool
  local seq = {}

  if pattern_type == 1 then       -- Ascending
    seq = pool

  elseif pattern_type == 2 then   -- Descending
    for i = n, 1, -1 do
      seq[#seq + 1] = pool[i]
    end

  elseif pattern_type == 3 then   -- Ping-pong (up then down, no repeat of ends)
    for i = 1, n do seq[#seq + 1] = pool[i]   end
    for i = n - 1, 2, -1 do seq[#seq + 1] = pool[i] end

  elseif pattern_type == 4 then   -- Down-up (down then up)
    for i = n, 1, -1 do seq[#seq + 1] = pool[i]   end
    for i = 2, n - 1 do seq[#seq + 1] = pool[i] end

  elseif pattern_type == 5 then   -- Skip (1-3-2-4 interleaved pattern)
    local odds, evens = {}, {}
    for i = 1, n do
      if i % 2 == 1 then odds[#odds + 1] = pool[i]
      else evens[#evens + 1] = pool[i] end
    end
    for _, v in ipairs(odds)  do seq[#seq + 1] = v end
    for _, v in ipairs(evens) do seq[#seq + 1] = v end

  elseif pattern_type == 6 then   -- Random shuffle (seeded for reproducibility in session)
    seq = {}
    for _, v in ipairs(pool) do seq[#seq + 1] = v end
    for i = #seq, 2, -1 do
      local j = math.random(1, i)
      seq[i], seq[j] = seq[j], seq[i]
    end
  end

  return seq
end

-- ---------------------------------------------------------------------------
-- Shared: get or create a phrase in the selected instrument
-- Respects renoise.song().selected_phrase_index if a phrase is already selected.
-- ---------------------------------------------------------------------------
-- get_or_create_phrase: always inserts a fresh phrase (for Write button).
local function get_or_create_phrase(instrument)
  local new_idx = #instrument.phrases + 1
  instrument:insert_phrase_at(new_idx)
  renoise.song().selected_phrase_index = new_idx
  return instrument.phrases[new_idx]
end

-- get_or_reuse_phrase: reuses the currently selected phrase (for Live mode).
local function get_or_reuse_phrase(instrument)
  if #instrument.phrases == 0 then
    instrument:insert_phrase_at(1)
    renoise.song().selected_phrase_index = 1
  end
  local idx = renoise.song().selected_phrase_index
  if idx and idx >= 1 and idx <= #instrument.phrases then
    return instrument.phrases[idx]
  end
  return instrument.phrases[1]
end

-- ---------------------------------------------------------------------------
-- Mode 1: Hardware (0A effect)
-- Renoise 0A effect: "0A XY" where X = semitones up for tick 1,
-- Y = semitones up for tick 2 (both relative to the base note).
-- Only 3-note chords fit cleanly into 0A; 4-note chords lose one note.
-- ---------------------------------------------------------------------------

local function encode_0A(intervals)
  -- intervals: list of additional semitones relative to root, e.g. {0,4,7}
  -- For 0A: X = intervals[2], Y = intervals[3] (root is played automatically)
  local x = intervals[2] or 0
  local y = intervals[3] or 0
  -- Clamp to 0-15 semitones (nibble max = F = 15)
  x = math.min(15, math.max(0, x))
  y = math.min(15, math.max(0, y))
  return string.format("%X%X", x, y)
end

function M.write_hardware_mode(instrument, root_note, chord_idx, octave_span,
                               pattern_type, lpb, phrase_len, do_loop)
  local intervals = chords.get_intervals(chord_idx)
  local seq       = make_pattern(intervals, pattern_type, octave_span)
  local phrase    = get_or_create_phrase(instrument)

  -- Configure phrase
  phrase.lpb             = lpb
  phrase.number_of_lines = phrase_len
  phrase.looping         = do_loop
  if phrase.playback_mode ~= nil then
    phrase.playback_mode = renoise.InstrumentPhrase.PLAY_PATTERN
  end

  -- Ensure at least 1 effect column is visible
  if phrase.visible_effect_columns < 1 then
    phrase.visible_effect_columns = 1
  end

  -- Compute the 0A effect value (same for all lines — chord doesn't change)
  local fx_value = encode_0A(intervals)

  -- Write notes: in Hardware mode the root stays constant on every line.
  -- The 0A XY effect cycles through the chord intervals at tick level.
  local root_str = note_to_string(math.max(0, math.min(119, root_note)))
  for line_idx = 1, phrase_len do
    local pline = phrase:line(line_idx)
    local ncol  = pline:note_column(1)
    local efx   = pline:effect_column(1)

    ncol.note_string   = root_str
    ncol.volume_string = ".."

    efx.number_string = "0A"
    efx.amount_string = fx_value
  end

  phrase.name = "8chip Arp  -  HW  -  " .. chords.chords[chord_idx].name
end

-- ---------------------------------------------------------------------------
-- Mode 2: Explicit notes
-- Each chord note occupies its own line, rotating through arp pattern.
-- ---------------------------------------------------------------------------

function M.write_explicit_mode(instrument, root_note, chord_idx, octave_span,
                                pattern_type, lpb, phrase_len, do_loop)
  local intervals = chords.get_intervals(chord_idx)
  local seq       = make_pattern(intervals, pattern_type, octave_span)
  local phrase    = get_or_create_phrase(instrument)

  phrase.lpb             = lpb
  phrase.number_of_lines = phrase_len
  phrase.looping         = do_loop
  if phrase.playback_mode ~= nil then
    phrase.playback_mode = renoise.InstrumentPhrase.PLAY_PATTERN
  end

  local seq_len = #seq
  for line_idx = 1, phrase_len do
    local pline    = phrase:line(line_idx)
    local ncol     = pline:note_column(1)
    local interval = seq[((line_idx - 1) % seq_len) + 1]
    local note_val = math.max(0, math.min(119, root_note + interval))

    ncol.note_string  = note_to_string(note_val)
    ncol.volume_string = ".."
    -- Clear any leftover effects
    pline:effect_column(1).number_string = ".."
    pline:effect_column(1).amount_string = ".."
  end

  phrase.name = "8chip Arp  -  Exp  -  " .. chords.chords[chord_idx].name
end

-- ---------------------------------------------------------------------------
-- Mode 3: Script (pattrns — Renoise 3.5 PLAY_SCRIPT phrases)
-- Writes a pattrns Lua script into the phrase's script content.
-- The script generates the arp algorithmically during playback.
-- ---------------------------------------------------------------------------

-- Map pattern_type index to a pattrns-compatible ordering description
local PATTERN_DESCRIPTIONS = {
  [1] = "ascending",
  [2] = "descending",
  [3] = "ping-pong",
  [4] = "down-up",
  [5] = "skip",
  [6] = "random",
}

-- Build a pattrns note list string from root + intervals
-- e.g. root=48 (C4), intervals={0,4,7} → "c4 e4 g4"
local PATTRNS_NAMES = {
  "c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"
}
local function note_to_pattrns(note)
  local oct  = math.floor(note / 12)
  local semi = note % 12
  return PATTRNS_NAMES[semi + 1] .. tostring(oct)
end

local function build_pattrns_note_list(root_note, intervals, octave_span, pattern_type)
  -- Collect notes across octave span
  local all = {}
  for oct = 0, octave_span - 1 do
    for _, iv in ipairs(intervals) do
      all[#all + 1] = note_to_pattrns(root_note + iv + oct * 12)
    end
  end

  -- Reorder according to pattern type
  local ordered = {}
  local n = #all
  if pattern_type == 1 then     -- Ascending
    ordered = all
  elseif pattern_type == 2 then -- Descending
    for i = n, 1, -1 do ordered[#ordered + 1] = all[i] end
  elseif pattern_type == 3 then -- Ping-pong
    for i = 1, n do ordered[#ordered + 1] = all[i] end
    for i = n - 1, 2, -1 do ordered[#ordered + 1] = all[i] end
  elseif pattern_type == 4 then -- Down-up
    for i = n, 1, -1 do ordered[#ordered + 1] = all[i] end
    for i = 2, n - 1 do ordered[#ordered + 1] = all[i] end
  else                          -- Skip and random: just ascending for script mode
    ordered = all
  end

  return table.concat(ordered, " ")
end

-- Calculate a unit string for pattrns from LPB
-- pattrns "1/N" maps to N subdivisions per beat
local function lpb_to_unit(lpb)
  return "1/" .. tostring(lpb)
end

function M.write_script_mode(instrument, root_note, chord_idx, octave_span,
                              pattern_type, lpb, do_loop, reuse_phrase)
  local intervals  = chords.get_intervals(chord_idx)
  local note_list  = build_pattrns_note_list(root_note, intervals, octave_span, pattern_type)
  local unit       = lpb_to_unit(lpb)
  local chord_name = chords.chords[chord_idx].name

  local phrase = reuse_phrase and get_or_reuse_phrase(instrument)
                               or get_or_create_phrase(instrument)

  -- Switch to PLAY_SCRIPT mode (Renoise 3.5+)
  if phrase.playback_mode ~= nil then
    phrase.playback_mode = renoise.InstrumentPhrase.PLAY_SCRIPT
  else
    -- Fallback: API not available (pre-3.5) — write explicit mode instead
    renoise.app():show_warning(
      "8chip: Script mode requires Renoise 3.5. Falling back to Explicit mode.")
    return M.write_explicit_mode(instrument, root_note, chord_idx, octave_span,
                                 pattern_type, lpb, 32, do_loop)
  end

  -- Build the pattrns script
  local looping_str = do_loop and "" or "\n  repeats = 1,"
  local script_text = string.format(
    [[-- 8chip Arp: %s (%s)
-- Generated by 8chip Chiptune Toolbox
return pattern {
  unit = "%s",%s
  event = cycle("%s"),
}
]],
    chord_name,
    PATTERN_DESCRIPTIONS[pattern_type] or "ascending",
    unit,
    looping_str,
    note_list
  )

  local ps = phrase.script
  -- paragraphs is a string[] (one element per line)
  local lines = {}
  for line in script_text:gmatch("([^\n]*)\n?") do
    lines[#lines + 1] = line
  end
  ps.paragraphs = lines
  ps:commit()

  phrase.name = "8chip Arp  -  Script  -  " .. chord_name
end

-- Expose the pattern builder so the UI can synthesise preview audio.
M.make_arp_sequence = make_pattern

return M
