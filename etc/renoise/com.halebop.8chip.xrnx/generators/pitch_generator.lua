-- generators/pitch_generator.lua
-- Module 4: Pitch & Glide
-- Writes pitch slide (0U/0D) and portamento/glide (0G) effects into phrases.

local M = {}

local NOTE_NAMES = {
  "C-","C#","D-","D#","E-","F-","F#","G-","G#","A-","A#","B-"
}
local function note_to_string(note)
  local octave  = math.floor(note / 12)
  local semi    = note % 12
  return NOTE_NAMES[semi + 1] .. tostring(octave)
end

-- ---------------------------------------------------------------------------
-- Shared: get or create a phrase; configure basic settings
-- ---------------------------------------------------------------------------
local function get_or_create_phrase(instrument)
  local new_idx = #instrument.phrases + 1
  instrument:insert_phrase_at(new_idx)
  renoise.song().selected_phrase_index = new_idx
  return instrument.phrases[new_idx]
end

local function configure_phrase(phrase, lpb, phrase_len, looping)
  phrase.lpb             = lpb
  phrase.number_of_lines = phrase_len
  phrase.looping         = looping
end

-- ---------------------------------------------------------------------------
-- Helper: hex string for effect amount 0–255
-- ---------------------------------------------------------------------------
local function hex2(v)
  return string.format("%02X", math.max(0, math.min(255, math.floor(v))))
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

-- ---------------------------------------------------------------------------
-- Laser zap: sharp upward pitch sweep then cut
-- note       : base note (MIDI 0–119)
-- speed      : 0A effect amount per line (0–FF)
-- rise_lines : how many lines the pitch sweeps up
-- lpb / phrase_len / looping for phrase config
-- ---------------------------------------------------------------------------
function M.write_laser_zap(instrument, note, speed, rise_lines, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument)
  configure_phrase(phrase, lpb, phrase_len, looping)

  local spd_str = hex2(speed)
  local ecol    = pick_efx_col(phrase, phrase_len)

  for line_idx = 1, phrase_len do
    local pline = phrase:line(line_idx)
    local ncol  = pline:note_column(1)
    local efx   = pline:effect_column(ecol)

    if line_idx == 1 then
      ncol.note_string   = note_to_string(math.max(0, math.min(119, note)))
      ncol.volume_string = ".."
    else
      ncol.note_string = "---"
    end

    if line_idx <= rise_lines then
      efx.number_string = "0U"
      efx.amount_string = spd_str
    elseif line_idx == rise_lines + 1 then
      efx.number_string = "0C"
      efx.amount_string = "00"
    else
      efx.number_string = ".."
      efx.amount_string = ".."
    end
  end

  phrase.name = "8chip Pitch  -  Laser Zap"
end

-- ---------------------------------------------------------------------------
-- Kick drop: downward pitch sweep (drum-style)
-- ---------------------------------------------------------------------------
function M.write_kick_drop(instrument, note, speed, drop_lines, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument)
  configure_phrase(phrase, lpb, phrase_len, looping)

  local spd_str = hex2(speed)
  local ecol    = pick_efx_col(phrase, phrase_len)

  for line_idx = 1, phrase_len do
    local pline = phrase:line(line_idx)
    local ncol  = pline:note_column(1)
    local efx   = pline:effect_column(ecol)

    if line_idx == 1 then
      ncol.note_string   = note_to_string(math.max(0, math.min(119, note)))
      ncol.volume_string = ".."
    else
      ncol.note_string = "---"
    end

    if line_idx <= drop_lines then
      efx.number_string = "0D"
      efx.amount_string = spd_str
    else
      efx.number_string = ".."
      efx.amount_string = ".."
    end
  end

  phrase.name = "8chip Pitch  -  Kick Drop"
end

-- ---------------------------------------------------------------------------
-- Bass glide: portamento from note_start to note_end over glide_lines lines
-- Uses 0G (glide to note) — writes the start note then a target note with 0G
-- ---------------------------------------------------------------------------
function M.write_glide(instrument, note_start, note_end, glide_speed, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument)
  configure_phrase(phrase, lpb, phrase_len, looping)

  local spd_str = hex2(glide_speed)
  local ns      = note_to_string(math.max(0, math.min(119, note_start)))
  local ne      = note_to_string(math.max(0, math.min(119, note_end)))
  local ecol    = pick_efx_col(phrase, phrase_len)

  for line_idx = 1, phrase_len do
    local pline = phrase:line(line_idx)
    local ncol  = pline:note_column(1)
    local efx   = pline:effect_column(ecol)

    if line_idx == 1 then
      ncol.note_string   = ns
      ncol.volume_string = ".."
      efx.number_string  = ".."
      efx.amount_string  = ".."
    elseif line_idx == 2 then
      ncol.note_string   = ne
      ncol.volume_string = ".."
      efx.number_string  = "0G"
      efx.amount_string  = spd_str
    else
      ncol.note_string   = "---"
      efx.number_string  = ".."
      efx.amount_string  = ".."
    end
  end

  phrase.name = "8chip Pitch  -  Glide"
end

-- ---------------------------------------------------------------------------
-- Portamento bass: 0G on every note change — good for bass lines
-- Writes alternating root/fifth with continuous glide
-- ---------------------------------------------------------------------------
function M.write_portamento_bass(instrument, root_note, glide_speed, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument)
  configure_phrase(phrase, lpb, phrase_len, looping)

  local spd_str = hex2(glide_speed)
  local pattern  = { 0, 7, 5, 7 }
  local ecol     = pick_efx_col(phrase, phrase_len)

  for line_idx = 1, phrase_len do
    local pline    = phrase:line(line_idx)
    local ncol     = pline:note_column(1)
    local efx      = pline:effect_column(ecol)
    local interval = pattern[((line_idx - 1) % #pattern) + 1]
    local note_val = math.max(0, math.min(119, root_note + interval))

    ncol.note_string   = note_to_string(note_val)
    ncol.volume_string = ".."
    efx.number_string  = (line_idx > 1) and "0G" or ".."
    efx.amount_string  = (line_idx > 1) and spd_str or ".."
  end

  phrase.name = "8chip Pitch  -  Portamento Bass"
end

return M
