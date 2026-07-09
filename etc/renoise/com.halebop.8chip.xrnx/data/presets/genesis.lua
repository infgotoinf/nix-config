-- data/presets/genesis.lua
-- Sega Genesis / Mega Drive instrument presets.
-- All presets load authentic single-cycle (or one-shot) WAV files bundled in
-- data/genesis_samples/ -- processed from chipsynth MD recordings (user owns
-- license) blended 80% real / 20% math, tuned to C4 at 44100 Hz.
--
-- Fields:
--   waveform  : genesis_* key, routed through generators.load_genesis_sample()
--   loop_mode : forward for melodic loops, off for percussion one-shots
--   starter_phrase : optional phrase key

return {
  {
    name          = "Genesis  -  Bass",
    description   = "Chipsynth MD FM bass - warm, punchy, single-cycle loop",
    waveform      = "genesis_bass",
    loop_mode     = "forward",
  },
  {
    name          = "Genesis  -  Electric Piano",
    description   = "Classic YM2612 DX7-style electric piano, single-cycle loop",
    waveform      = "genesis_epiano",
    loop_mode     = "forward",
  },
  {
    name          = "Genesis  -  Lead",
    description   = "Bright FM lead, single-cycle loop",
    waveform      = "genesis_lead",
    loop_mode     = "forward",
    starter_phrase = "arp_major_fast",
  },
  {
    name          = "Genesis  -  Bell",
    description   = "Inharmonic FM bell, single-cycle loop",
    waveform      = "genesis_bell",
    loop_mode     = "forward",
    starter_phrase = "arp_minor_fast",
  },
  {
    name          = "Genesis  -  Brass",
    description   = "Hard FM brass stab, single-cycle loop",
    waveform      = "genesis_brass",
    loop_mode     = "forward",
  },
  {
    name          = "Genesis  -  Clavinet",
    description   = "Plucked FM clavinet, single-cycle loop",
    waveform      = "genesis_clav",
    loop_mode     = "forward",
  },
  {
    name          = "Genesis  -  Organ",
    description   = "Additive-style FM organ, single-cycle loop",
    waveform      = "genesis_organ",
    loop_mode     = "forward",
  },
  {
    name          = "Genesis  -  Kick",
    description   = "YM2612 FM kick drum - one-shot",
    waveform      = "genesis_kick",
    loop_mode     = "off",
  },
  {
    name          = "Genesis  -  Snare",
    description   = "YM2612 FM snare - one-shot",
    waveform      = "genesis_snare",
    loop_mode     = "off",
  },
  {
    name          = "Genesis  -  Hi-Hat",
    description   = "YM2612 FM hi-hat - one-shot",
    waveform      = "genesis_hihat",
    loop_mode     = "off",
  },
}
