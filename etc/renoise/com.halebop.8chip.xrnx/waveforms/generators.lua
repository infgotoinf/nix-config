-- waveforms/generators.lua
-- Mathematical waveform generators and sample buffer writer.
-- All generators return a Lua table of float values in [-1.0, 1.0].

local TWO_PI = 2 * math.pi

local M = {}

-- ---------------------------------------------------------------------------
-- Waveform generators
-- ---------------------------------------------------------------------------

function M.generate_sine(num_frames)
  local data = table.create()
  for i = 1, num_frames do
    local x = (i - 1) / num_frames
    data[i] = math.sin(TWO_PI * x)
  end
  return data
end

function M.generate_square(num_frames)
  local data = table.create()
  for i = 1, num_frames do
    local x = (i - 1) / num_frames
    data[i] = (x < 0.5) and 1.0 or -1.0
  end
  return data
end

-- duty: 0.0..1.0 (fraction of cycle spent at +1.0)
function M.generate_pulse(num_frames, duty)
  duty = duty or 0.5
  local data = table.create()
  for i = 1, num_frames do
    local x = (i - 1) / num_frames
    data[i] = (x < duty) and 1.0 or -1.0
  end
  return data
end

function M.generate_sawtooth(num_frames)
  local data = table.create()
  for i = 1, num_frames do
    local x = (i - 1) / num_frames
    data[i] = 2.0 * x - 1.0
  end
  return data
end

function M.generate_triangle(num_frames)
  local data = table.create()
  for i = 1, num_frames do
    local x = (i - 1) / num_frames
    if x < 0.5 then
      data[i] = -1.0 + 4.0 * x
    else
      data[i] =  3.0 - 4.0 * x
    end
  end
  return data
end

function M.generate_noise(num_frames)
  local data = table.create()
  math.randomseed(os.time())
  for i = 1, num_frames do
    data[i] = math.random() * 2.0 - 1.0
  end
  return data
end

-- op_ratio   : modulator frequency = carrier frequency * op_ratio (e.g. 2.0)
-- mod_index  : modulation depth (0 = pure sine, higher = more harmonics)
-- Output is normalized so the peak is always 1.0.
function M.generate_fm(num_frames, op_ratio, mod_index)
  op_ratio  = op_ratio  or 2.0
  mod_index = mod_index or 1.0
  local data  = table.create()
  local peak  = 0.0
  for i = 1, num_frames do
    local x   = (i - 1) / num_frames
    local mod = mod_index * math.sin(TWO_PI * op_ratio * x)
    local v   = math.sin(TWO_PI * x + mod)
    data[i]   = v
    if math.abs(v) > peak then peak = math.abs(v) end
  end
  -- Normalize to prevent clipping
  if peak > 0.0 then
    for i = 1, num_frames do
      data[i] = data[i] / peak
    end
  end
  return data
end

-- ---------------------------------------------------------------------------
-- Sample buffer writer
-- ---------------------------------------------------------------------------

-- Writes a table of float values into a Renoise sample buffer.
--
-- instrument   : renoise.Instrument
-- sample_index : 1-based integer
-- sample_rate  : integer (e.g. 44100)
-- bit_depth    : integer (8, 16, or 32)
-- loop_mode    : string "forward" | "ping_pong" | "off"
-- frames       : table of numbers in [-1.0, 1.0]
--
-- Returns true on success, false on failure.
function M.write_to_buffer(instrument, sample_index, sample_rate, bit_depth, loop_mode, frames)
  local sample     = instrument.samples[sample_index]
  local buf        = sample.sample_buffer
  local num_frames = #frames

  if not buf:create_sample_data(sample_rate, bit_depth, 1, num_frames) then
    renoise.app():show_error("8chip: Out of memory while generating waveform.")
    return false
  end

  buf:prepare_sample_data_changes()
  for i = 1, num_frames do
    buf:set_sample_data(1, i, frames[i])
  end
  buf:finalize_sample_data_changes()

  -- Configure loop
  if loop_mode == "forward" then
    sample.loop_mode  = renoise.Sample.LOOP_MODE_FORWARD
    sample.loop_start = 1
    sample.loop_end   = num_frames
  elseif loop_mode == "ping_pong" then
    sample.loop_mode  = renoise.Sample.LOOP_MODE_PING_PONG
    sample.loop_start = 1
    sample.loop_end   = num_frames
  else
    sample.loop_mode = renoise.Sample.LOOP_MODE_OFF
  end

  return true
end

-- ---------------------------------------------------------------------------
-- Helper: find or create sample slot 1 in an instrument
-- ---------------------------------------------------------------------------
function M.ensure_sample_slot(instrument)
  if #instrument.samples == 0 then
    instrument:insert_sample_at(1)
  end
end

-- ---------------------------------------------------------------------------
-- Helper: find first sequencer track index (for preview note trigger)
-- ---------------------------------------------------------------------------
function M.find_sequencer_track()
  local song = renoise.song()
  for i, track in ipairs(song.tracks) do
    if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
      return i
    end
  end
  return song.selected_track_index
end

-- ---------------------------------------------------------------------------
-- NES Authentic Sample loader
-- Loads one of the bundled single-cycle NES wav files into instrument slot 1.
--
-- waveform_key must be one of:
--   "nes_square"      → AKWF_nes_square.wav      (50% pulse, real APU)
--   "nes_pulse_25"    → AKWF_nes_pulse_25.wav     (25% duty)
--   "nes_pulse_12"    → AKWF_nes_pulse_12_5.wav   (12.5% duty, thinnest)
--   "nes_triangle"    → AKWF_nes_triangle.wav     (staircase, real APU)
--   "nes_noise"       → AKSA_nes_noise.wav         (LFSR noise loop, 5 sec)
-- ---------------------------------------------------------------------------

local NES_SAMPLE_FILES = {
  nes_square     = "nes_square.wav",
  nes_pulse_25   = "nes_pulse_25.wav",
  nes_pulse_12   = "nes_pulse_12_5.wav",
  nes_triangle   = "nes_triangle.wav",
  nes_noise      = "nes_noise.wav",
}


function M.load_nes_sample(instrument, waveform_key, sample_name)
  local filename = NES_SAMPLE_FILES[waveform_key]
  if not filename then
    renoise.app():show_error("8chip: Unknown NES waveform key: " .. tostring(waveform_key))
    return false
  end

  local path = renoise.tool().bundle_path .. "data/nes_samples/" .. filename

  M.ensure_sample_slot(instrument)
  local sample = instrument.samples[1]
  sample.name  = sample_name or waveform_key

  local buf    = sample.sample_buffer
  local ok, err = buf:load_from(path)
  if not ok then
    renoise.app():show_error("8chip: Could not load NES sample.\n" .. tostring(err))
    return false
  end

  -- Single-cycle loop (noise loops over full 5-sec buffer, same result)
  sample.loop_mode  = renoise.Sample.LOOP_MODE_FORWARD
  sample.loop_start = 1
  sample.loop_end   = buf.number_of_frames
  -- base_note is not settable via the Renoise Lua API.

  return true
end

-- ---------------------------------------------------------------------------
-- Genesis Authentic Sample loader
-- Loads one of the bundled single-cycle (or one-shot) Genesis WAV files
-- processed from chipsynth MD recordings into instrument slot 1.
--
-- waveform_key must be one of:
--   "genesis_bass"    → genesis_bass.wav    (single-cycle, forward loop)
--   "genesis_epiano"  → genesis_epiano.wav  (single-cycle, forward loop)
--   "genesis_lead"    → genesis_lead.wav    (single-cycle, forward loop)
--   "genesis_bell"    → genesis_bell.wav    (single-cycle, forward loop)
--   "genesis_brass"   → genesis_brass.wav   (single-cycle, forward loop)
--   "genesis_clav"    → genesis_clav.wav    (single-cycle, forward loop)
--   "genesis_organ"   → genesis_organ.wav   (single-cycle, forward loop)
--   "genesis_kick"    → genesis_kick.wav    (one-shot, no loop)
--   "genesis_snare"   → genesis_snare.wav   (one-shot, no loop)
--   "genesis_hihat"   → genesis_hihat.wav   (one-shot, no loop)
-- ---------------------------------------------------------------------------

local GENESIS_SAMPLE_FILES = {
  genesis_bass   = "genesis_bass.wav",
  genesis_epiano = "genesis_epiano.wav",
  genesis_lead   = "genesis_lead.wav",
  genesis_bell   = "genesis_bell.wav",
  genesis_brass  = "genesis_brass.wav",
  genesis_clav   = "genesis_clav.wav",
  genesis_organ  = "genesis_organ.wav",
  genesis_kick   = "genesis_kick.wav",
  genesis_snare  = "genesis_snare.wav",
  genesis_hihat  = "genesis_hihat.wav",
}

local GENESIS_ONESHOTS = {
  genesis_kick  = true,
  genesis_snare = true,
  genesis_hihat = true,
}

function M.load_genesis_sample(instrument, waveform_key, sample_name)
  local filename = GENESIS_SAMPLE_FILES[waveform_key]
  if not filename then
    renoise.app():show_error("8chip: Unknown Genesis waveform key: " .. tostring(waveform_key))
    return false
  end

  local path = renoise.tool().bundle_path .. "data/genesis_samples/" .. filename

  M.ensure_sample_slot(instrument)
  local sample = instrument.samples[1]
  sample.name  = sample_name or waveform_key

  local buf       = sample.sample_buffer
  local ok, err   = buf:load_from(path)
  if not ok then
    renoise.app():show_error("8chip: Could not load Genesis sample.\n" .. tostring(err))
    return false
  end

  if GENESIS_ONESHOTS[waveform_key] then
    sample.loop_mode = renoise.Sample.LOOP_MODE_OFF
  else
    -- Single-cycle forward loop
    sample.loop_mode  = renoise.Sample.LOOP_MODE_FORWARD
    sample.loop_start = 1
    sample.loop_end   = buf.number_of_frames
  end
  -- base_note is not settable via the Renoise Lua API.

  return true
end

-- ---------------------------------------------------------------------------
-- Chip Authentic Sample loader
-- Loads one of the bundled Halebop single-cycle WAV files (GB / SID) into
-- instrument slot 1.
--
-- waveform_key must be one of:
--   "chip_gb_wave_saw"      → gb_wave_saw.wav
--   "chip_gb_wave_triangle" → gb_wave_triangle.wav
--   "chip_sid_sawtooth"     → sid_sawtooth.wav
--   "chip_sid_triangle"     → sid_triangle.wav
--   "chip_sid_pulse_25"     → sid_pulse_25.wav
--   "chip_sid_pulse_50"     → sid_pulse_50.wav
-- ---------------------------------------------------------------------------

local CHIP_SAMPLE_FILES = {
  chip_gb_wave_saw      = "gb_wave_saw.wav",
  chip_gb_wave_triangle = "gb_wave_triangle.wav",
  chip_sid_sawtooth     = "sid_sawtooth.wav",
  chip_sid_triangle     = "sid_triangle.wav",
  chip_sid_pulse_25     = "sid_pulse_25.wav",
  chip_sid_pulse_50     = "sid_pulse_50.wav",
}

function M.load_chip_sample(instrument, waveform_key, sample_name)
  local filename = CHIP_SAMPLE_FILES[waveform_key]
  if not filename then
    renoise.app():show_error("8chip: Unknown chip waveform key: " .. tostring(waveform_key))
    return false
  end

  local path = renoise.tool().bundle_path .. "data/chip_samples/" .. filename

  M.ensure_sample_slot(instrument)
  local sample  = instrument.samples[1]
  sample.name   = sample_name or waveform_key

  local buf      = sample.sample_buffer
  local ok, err  = buf:load_from(path)
  if not ok then
    renoise.app():show_error("8chip: Could not load chip sample.\n" .. tostring(err))
    return false
  end

  sample.loop_mode  = renoise.Sample.LOOP_MODE_FORWARD
  sample.loop_start = 1
  sample.loop_end   = buf.number_of_frames
  return true
end

return M
