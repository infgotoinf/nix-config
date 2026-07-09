-- preferences.lua
-- Persistent settings for 8chip Chiptune Toolbox.
-- Stored in Renoise's tool preferences across sessions.

renoise.tool().preferences = renoise.Document.create("ChiptuneToolboxPrefs") {

  -- Waveform Studio
  waveform_type    = 1,    -- 1=Sine 2=Pulse 3=Square(50%) 4=Sawtooth 5=Triangle 6=Noise 7=FM
  duty_pct         = 25,   -- integer 5..95 (duty cycle %)
  fm_ratio_x10     = 20,   -- integer 5..160 (op ratio * 10, e.g. 20 = 2.0)
  fm_mod_x10       = 10,   -- integer 0..100 (mod index * 10, e.g. 10 = 1.0)
  sample_rate_idx  = 4,    -- 1=8000 2=11025 3=22050 4=44100
  bit_depth_idx    = 3,    -- 1=8bit 2=16bit 3=32bit
  loop_mode_idx    = 1,    -- 1=Forward 2=PingPong 3=Off
  num_frames       = 256,  -- frames per generated waveform cycle

  -- Arp Generator
  arp_mode         = 1,    -- 1=Hardware(0A) 2=Explicit 3=Script(pattrns)
  arp_root_note    = 48,   -- MIDI note 0..119 (48 = C4)
  arp_chord_type   = 1,    -- index into chord table
  arp_octave_span  = 1,    -- 1..3
  arp_pattern      = 1,    -- 1=Asc 2=Desc 3=PingPong 4=DownUp 5=Skip 6=Random
  arp_lpb          = 4,    -- index into LPB_VALUES table {4,8,12,16,24,32,48,64}
  arp_phrase_len   = 2,    -- index into PHRASE_LENS table {8,16,24,32,48,64}
  arp_loop         = true,

  -- Single Cycle Browser
  scw_library_path = "",   -- absolute path to the WAV library root folder
  scw_last_bank    = "",   -- last selected bank name (restored on open)
}
