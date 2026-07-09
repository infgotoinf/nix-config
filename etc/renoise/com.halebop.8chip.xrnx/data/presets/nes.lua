-- data/presets/nes.lua
-- NES (Famicom) instrument presets.
-- Presets marked with waveform = "nes_*" load authentic single-cycle samples
-- recorded from real NES APU hardware (bundled in data/nes_samples/).
-- Other categories still use mathematical generators.
--
-- Fields:
--   name          : display name (string)
--   waveform      : "nes_square"|"nes_pulse_25"|"nes_pulse_12"|"nes_triangle"|
--                   "nes_noise"  (authentic) or the usual math types
--   loop_mode     : "forward"|"ping_pong"|"off"
--   starter_phrase: phrase key string | nil

return {
  {
    name          = "NES  -  Pulse Lead",
    description   = "Bright melodic lead  -  50% duty square, real APU recording",
    waveform      = "nes_square",
    loop_mode     = "forward",
    starter_phrase = "arp_major_fast",
  },
  {
    name          = "NES  -  Thin Lead",
    description   = "Thinner, buzzier lead  -  25% duty pulse, real APU",
    waveform      = "nes_pulse_25",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Hollow Lead",
    description   = "Narrow 12.5% duty pulse  -  thinnest NES tone, real APU",
    waveform      = "nes_pulse_12",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Pulse Bass",
    description   = "Fat bass  -  50% duty square, real APU recording",
    waveform      = "nes_square",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Hollow Bass",
    description   = "Narrow hollow bass  -  12.5% duty pulse, real APU",
    waveform      = "nes_pulse_12",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Triangle Walk",
    description   = "Smooth bass walk  -  15-step staircase triangle, real NES APU ch.3",
    waveform      = "nes_triangle",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Triangle Pluck",
    description   = "Percussive pluck  -  NES staircase triangle",
    waveform      = "nes_triangle",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Noise Loop",
    description   = "Real NES LFSR noise channel  -  looping, use for drums or texture",
    waveform      = "nes_noise",
    loop_mode     = "forward",
  },
  {
    name          = "NES  -  Drum Kick",
    description   = "Short noise burst, pitch-drop kick character (math generator)",
    waveform      = "noise",
    sample_rate   = 8000,
    bit_depth     = 8,
    num_frames    = 64,
    loop_mode     = "off",
  },
  {
    name          = "NES  -  Drum Snare",
    description   = "Mid-range noise crack (math generator)",
    waveform      = "noise",
    sample_rate   = 11025,
    bit_depth     = 8,
    num_frames    = 128,
    loop_mode     = "off",
  },
}
