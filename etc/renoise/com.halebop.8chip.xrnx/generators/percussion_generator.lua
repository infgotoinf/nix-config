-- generators/percussion_generator.lua
-- Module 5: Percussion Shaper
-- Writes effect-driven percussion phrases.
-- Kick:       volume step-fade + 0C cut  (pitched noise or triangle)
-- Snare:      0R retrigger burst
-- Hi-hat:     0C very short cut + optional 0Y probability
-- Noise burst: volume step-fade decay

local M = {}

local function hex2(v)
  return string.format("%02X", math.max(0, math.min(255, math.floor(v))))
end

local function note_to_string(midi_note)
  local names = {"C-","C#","D-","D#","E-","F-","F#","G-","G#","A-","A#","B-"}
  local oct  = math.floor(midi_note / 12)
  local semi = midi_note % 12
  return names[semi + 1] .. tostring(oct)
end

local function get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local new_idx = #instrument.phrases + 1
  instrument:insert_phrase_at(new_idx)
  renoise.song().selected_phrase_index = new_idx
  local phrase = instrument.phrases[new_idx]
  phrase.number_of_lines = phrase_len
  phrase.lpb = lpb
  phrase.looping = looping
  if phrase.playback_mode ~= nil then
    phrase.playback_mode = renoise.InstrumentPhrase.PLAY_PATTERN
  end
  return phrase
end

-- Kick: strike with volume fade-out over decay_lines by retriggering
-- with decreasing volume, then cutting.
function M.write_kick(instrument, note, decay_lines, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  decay_lines = math.min(decay_lines, phrase_len - 1)  -- ensure cut line fits

  for i = 1, phrase_len do
    local line = phrase:line(i)
    line:clear()
    if i <= decay_lines then
      local vol = math.max(1, math.floor(0x80 * (decay_lines - i + 1) / decay_lines))
      local ncol = line:note_column(1)
      ncol.note_string   = note_to_string(note)
      ncol.volume_string = hex2(vol)
    elseif i == decay_lines + 1 then
      local efx = line:effect_column(1)
      efx.number_string = "0C"
      efx.amount_string = "00"
    end
  end
end

-- Snare: strike + retrigger burst on first line, then silence.
-- retrigger_count controls how many rapid echoes (2–8 typical).
function M.write_snare(instrument, note, retrigger_count, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument, lpb, phrase_len, looping)

  -- 0R amount high nibble = interval ticks, low = count  (approximate)
  -- Use 0R with 01–08 retrigs at fast tick rate
  local retrig_speed = math.max(1, math.floor(16 / math.max(1, retrigger_count)))
  -- Pack: 0Rxy  x=interval (1=each tick), y=count (capped 1-F)
  local pack_x = math.max(1, math.min(15, retrig_speed))
  local pack_y = math.max(1, math.min(15, retrigger_count))
  local retrig_val = pack_x * 16 + pack_y

  for i = 1, phrase_len do
    local line = phrase:line(i)
    line:clear()
    if i == 1 then
      local ncol = line:note_column(1)
      local efx1 = line:effect_column(1)
      local efx2 = line:effect_column(2)
      ncol.note_string   = note_to_string(note)
      ncol.volume_string = "7F"
      efx1.number_string = "0R"
      efx1.amount_string = hex2(retrig_val)
      efx2.number_string = "0C"
      efx2.amount_string = "04"   -- short cut
    end
  end
end

-- Hi-hat: note + hard cut. probability controls 0Y per line.
-- cut_tick: how many ticks to let ring (1–15).
-- probability: 0–255 (0Y amount). 0 = no probability column.
function M.write_hihat(instrument, note, cut_tick, probability, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  local use_prob = (probability > 0 and probability < 255)

  for i = 1, phrase_len do
    local line = phrase:line(i)
    line:clear()
    local ncol = line:note_column(1)
    local efx1 = line:effect_column(1)
    local efx2 = line:effect_column(2)
    ncol.note_string   = note_to_string(note)
    ncol.volume_string = "60"
    efx1.number_string = "0C"
    efx1.amount_string = hex2(math.max(1, math.min(255, cut_tick)))
    if use_prob then
      efx2.number_string = "0Y"
      efx2.amount_string = hex2(probability)
    end
  end
end

-- Noise burst: single hit with volume fade-out over decay_lines.
function M.write_noise_burst(instrument, note, decay_lines, lpb, phrase_len, looping)
  local phrase = get_or_create_phrase(instrument, lpb, phrase_len, looping)
  decay_lines = math.min(decay_lines, phrase_len - 1)  -- ensure cut line fits

  for i = 1, phrase_len do
    local line = phrase:line(i)
    line:clear()
    if i <= decay_lines then
      local vol = math.max(1, math.floor(0x7F * (decay_lines - i + 1) / decay_lines))
      local ncol = line:note_column(1)
      ncol.note_string   = note_to_string(note)
      ncol.volume_string = hex2(vol)
    elseif i == decay_lines + 1 then
      local efx = line:effect_column(1)
      efx.number_string = "0C"
      efx.amount_string = "00"
    end
  end
end

return M
