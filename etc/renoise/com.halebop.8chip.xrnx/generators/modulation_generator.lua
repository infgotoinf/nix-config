-- generators/modulation_generator.lua
-- Module 6: Modulation Injector
-- Writes 0V (vibrato), 0T (tremolo), 0N (auto-pan) into phrases.

local M = {}

local NOTE_NAMES = {"C-","C#","D-","D#","E-","F-","F#","G-","G#","A-","A#","B-"}
local function note_to_string(midi_note)
  local oct  = math.floor(midi_note / 12)
  local semi = midi_note % 12
  return NOTE_NAMES[semi + 1] .. tostring(oct)
end

local function hex2(v)
  return string.format("%02X", math.max(0, math.min(255, math.floor(v))))
end

-- Pack two nibbles (0–15 each) into a single byte string for 0V / 0T / 0N.
-- High nibble = speed, low nibble = depth.
local function pack_nibbles(speed, depth)
  local s = math.max(0, math.min(15, math.floor(speed)))
  local d = math.max(0, math.min(15, math.floor(depth)))
  return hex2(s * 16 + d)
end

-- Pick the first effect column that is empty on every line of the phrase.
local function pick_efx_col(phrase, phrase_len)
  local num_cols = #phrase:line(1).effect_columns
  for ec = 1, num_cols do
    local free = true
    for i = 1, phrase_len do
      local col = phrase:line(i):effect_column(ec)
      if col.number_string ~= "00" and col.number_string ~= "" and col.number_string ~= ".." then
        free = false
        break
      end
    end
    if free then return ec end
  end
  return num_cols  -- all occupied; use last column
end

local function get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local new_idx = #instrument.phrases + 1
  instrument:insert_phrase_at(new_idx)
  renoise.song().selected_phrase_index = new_idx
  local phrase = instrument.phrases[new_idx]
  phrase.number_of_lines = phrase_len
  phrase.lpb     = lpb
  phrase.looping = looping
  if phrase.playback_mode ~= nil then
    phrase.playback_mode = renoise.InstrumentPhrase.PLAY_PATTERN
  end
  return phrase
end

-- ---------------------------------------------------------------------------
-- Vibrato (0V)
-- Writes a held note on line 1 with 0V on every line.
-- speed : high nibble 0–15
-- depth : low nibble 0–15
-- ---------------------------------------------------------------------------
function M.write_vibrato(instrument, note, speed, depth, lpb, phrase_len, looping)
  local effect_str = pack_nibbles(speed, depth)
  local phrase     = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local note_str   = note_to_string(note)
  local ecol       = pick_efx_col(phrase, phrase_len)

  for i = 1, phrase_len do
    local line = phrase:line(i)
    local efx  = line:effect_column(ecol)
    efx.number_string = "0V"
    efx.amount_string = effect_str
    -- Write trigger note on line 1 (phrase is always fresh/empty)
    if i == 1 then
      local ncol = line:note_column(1)
      ncol.note_string   = note_str
      ncol.volume_string = "7F"
    end
  end
end

-- ---------------------------------------------------------------------------
-- Tremolo (0T)
-- Writes a held note with 0T on every line.
-- ---------------------------------------------------------------------------
function M.write_tremolo(instrument, note, speed, depth, lpb, phrase_len, looping)
  local effect_str = pack_nibbles(speed, depth)
  local phrase     = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local note_str   = note_to_string(note)
  local ecol       = pick_efx_col(phrase, phrase_len)

  for i = 1, phrase_len do
    local line = phrase:line(i)
    local efx  = line:effect_column(ecol)
    efx.number_string = "0T"
    efx.amount_string = effect_str
    -- Write trigger note on line 1 (phrase is always fresh/empty)
    if i == 1 then
      local ncol = line:note_column(1)
      ncol.note_string   = note_str
      ncol.volume_string = "7F"
    end
  end
end

-- ---------------------------------------------------------------------------
-- Auto-pan (0N)
-- Writes a held note with 0N on every line.
-- ---------------------------------------------------------------------------
function M.write_autopan(instrument, note, speed, depth, lpb, phrase_len, looping)
  local effect_str = pack_nibbles(speed, depth)
  local phrase     = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local note_str   = note_to_string(note)
  local ecol       = pick_efx_col(phrase, phrase_len)

  for i = 1, phrase_len do
    local line = phrase:line(i)
    local efx  = line:effect_column(ecol)
    efx.number_string = "0N"
    efx.amount_string = effect_str
    -- Write trigger note on line 1 (phrase is always fresh/empty)
    if i == 1 then
      local ncol = line:note_column(1)
      ncol.note_string   = note_str
      ncol.volume_string = "7F"
    end
  end
end

-- ---------------------------------------------------------------------------
-- Inject modulation into the CURRENTLY SELECTED PATTERN region.
-- Uses renoise.song().selection_in_pattern (if given) or current track/line.
-- effect_cmd: "0V", "0T", or "0N"
-- packed_val: two-nibble hex string e.g. "37"
-- ---------------------------------------------------------------------------
function M.inject_into_pattern(effect_cmd, packed_val)
  local song    = renoise.song()
  local pattern = song.selected_pattern
  local track   = song.selected_track
  local ti      = song.selected_track_index

  -- Get selection bounds (fall back to full pattern in selected track)
  local sel = song.selection_in_pattern
  local line_start, line_end
  if sel and sel.start_track == ti then
    line_start = sel.start_line
    line_end   = sel.end_line
  else
    line_start = 1
    line_end   = pattern.number_of_lines
  end

  local pt = pattern:track(ti)
  for ln = line_start, line_end do
    local line = pt:line(ln)
    -- Find first empty effect column or first column
    local ncol = line:note_column(1)
    if ncol.note_string ~= "---" then
      -- There's a note on this line — apply the effect
      local col = line:effect_column(1)
      -- Shift existing effect to col 2 if col 1 is occupied
      local col2 = line:effect_column(2)
      if col.number_string ~= "00" and col.number_string ~= "" then
        if col2.number_string == "00" or col2.number_string == "" then
          col2.number_string = col.number_string
          col2.amount_string = col.amount_string
        end
      end
      col.number_string = effect_cmd
      col.amount_string = packed_val
    end
  end
end

return M
