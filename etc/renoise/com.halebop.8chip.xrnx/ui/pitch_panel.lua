-- ui/pitch_panel.lua
-- Module 4: Pitch & Glide
-- UI for writing pitch slide / portamento phrases.

local pitch = require("generators.pitch_generator")

local W = 480

local PRESETS = { "Laser Zap", "Kick Drop", "Bass Glide", "Portamento Bass" }

local NOTE_NAMES = {
  "C","C#","D","D#","E","F","F#","G","G#","A","A#","B"
}
local function build_note_items()
  local items = {}
  for note = 0, 119 do
    local oct  = math.floor(note / 12)
    local semi = note % 12
    items[note + 1] = NOTE_NAMES[semi + 1] .. tostring(oct)
  end
  return items
end

local LPB_VALUES = { 4, 8, 16, 32 }
local LPB_LABELS = { "4", "8", "16", "32" }

-- Preview state
local preview_active   = false
local preview_samp_idx = nil

function create_pitch_panel(vb)
  local note_items = build_note_items()

  -- Local state (not persisted — pitch panel is simpler)
  local state = {
    preset     = 1,
    note_start = 60,   -- C5
    note_end   = 67,   -- G5
    speed      = 16,
    rise_lines = 4,
    lpb        = 3,    -- index → 16 LPB
    phrase_len = 16,
    looping    = false,
  }

  local function get_lpb()  return LPB_VALUES[state.lpb] or 16 end

  local function do_write()
    local song  = renoise.song()
    local instr = song.selected_instrument
    if not instr then
      renoise.app():show_error("8chip: No instrument selected.")
      return
    end
    local p = state.preset
    local lpb = get_lpb()
    if p == 1 then
      pitch.write_laser_zap(instr, state.note_start, state.speed,
                            state.rise_lines, lpb, state.phrase_len, state.looping)
    elseif p == 2 then
      pitch.write_kick_drop(instr, state.note_start, state.speed,
                            state.rise_lines, lpb, state.phrase_len, state.looping)
    elseif p == 3 then
      pitch.write_glide(instr, state.note_start, state.note_end,
                        state.speed, lpb, state.phrase_len, state.looping)
    elseif p == 4 then
      pitch.write_portamento_bass(instr, state.note_start, state.speed,
                                  lpb, state.phrase_len, state.looping)
    end
    renoise.app():show_status("8chip: Pitch phrase written.")
  end

  local function do_preview()
    local song      = renoise.song()
    local instr     = song.selected_instrument
    local instr_idx = song.selected_instrument_index
    if not instr then
      renoise.app():show_error("8chip: No instrument selected.")
      return
    end

    local SAMPLE_RATE = 22050
    local BPM         = 120
    local lpb         = get_lpb()
    local line_dur    = 60.0 / (BPM * lpb / 4.0)  -- seconds per line
    local p           = state.preset
    -- speed: semitones per second — speed/2 so speed=16→8 sem/s, speed=255→127 sem/s
    local spt         = math.max(0.5, state.speed / 2.0)

    -- Preview length: just enough to hear the sweep, max 2 sec
    local sweep_secs  = state.rise_lines * line_dur
    local total_secs  = math.max(1.0, math.min(2.0, sweep_secs + 0.4))
    local total_samps = math.floor(total_secs * SAMPLE_RATE)

    local buf_data = {}
    local phase    = 0.0

    if p == 1 then
      -- Laser Zap: pitch sweeps UP for rise_lines then cuts to silence
      local rise_samps = math.min(total_samps - 1, math.floor(sweep_secs * SAMPLE_RATE))
      for s = 1, total_samps do
        if s > rise_samps then
          buf_data[s] = 0.0
        else
          local shifted = (s - 1) * spt / SAMPLE_RATE
          local note    = state.note_start + shifted
          local freq    = 440.0 * 2.0 ^ ((note - 69) / 12.0)
          phase         = (phase + freq / SAMPLE_RATE) % 1.0
          buf_data[s]   = (phase < 0.5) and 0.6 or -0.6
        end
      end

    elseif p == 2 then
      -- Kick Drop: pitch sweeps DOWN, amplitude decays
      local drop_samps = math.min(total_samps, math.floor(sweep_secs * SAMPLE_RATE))
      for s = 1, total_samps do
        local shifted = math.min(s - 1, drop_samps) * spt / SAMPLE_RATE
        local note    = state.note_start - shifted
        local freq    = math.max(20.0, 440.0 * 2.0 ^ ((note - 69) / 12.0))
        phase         = (phase + freq / SAMPLE_RATE) % 1.0
        local decay   = math.max(0.0, 1.0 - (s - 1) / (total_samps * 0.8))
        buf_data[s]   = ((phase < 0.5) and 0.6 or -0.6) * decay
      end

    elseif p == 3 then
      -- Bass Glide: hold start note, then slide to end note
      -- Higher speed = faster glide (shorter hold before slide begins)
      local hold_samps  = math.max(1, math.floor((0.5 - state.speed / 600.0) * SAMPLE_RATE))
      local glide_samps = math.max(1, total_samps - hold_samps)
      for s = 1, total_samps do
        local t
        if s <= hold_samps then
          t = 0.0
        else
          t = math.min(1.0, (s - hold_samps) / glide_samps)
        end
        local note  = state.note_start + (state.note_end - state.note_start) * t
        local freq  = 440.0 * 2.0 ^ ((note - 69) / 12.0)
        phase       = (phase + freq / SAMPLE_RATE) % 1.0
        buf_data[s] = (phase < 0.5) and 0.6 or -0.6
      end

    elseif p == 4 then
      -- Portamento Bass: root/fifth/fourth/fifth; speed controls glide tightness
      local nd   = math.max(1024, math.floor(line_dur * 2 * SAMPLE_RATE))
      local gfrac = math.max(0.05, 1.0 - state.speed / 300.0)
      local gd   = math.max(256, math.floor(nd * gfrac))
      local ivs  = { 0, 7, 5, 7 }
      for s = 1, total_samps do
        local ni   = math.floor((s - 1) / nd) % 4
        local pi   = (ni - 1 + 4) % 4
        local t_in = (s - 1) % nd
        local from = state.note_start + ivs[pi + 1]
        local to   = state.note_start + ivs[ni + 1]
        if ni == 0 and math.floor((s-1)/nd) == 0 then from = to end
        local frac = math.min(1.0, t_in / gd)
        local note = from + (to - from) * frac
        local freq = 440.0 * 2.0 ^ ((note - 69) / 12.0)
        phase      = (phase + freq / SAMPLE_RATE) % 1.0
        buf_data[s] = (phase < 0.5) and 0.6 or -0.6
      end
    end

    -- Each call captures its own sample index — no global guard needed
    local my_samp_idx = #instr.samples + 1
    instr:insert_sample_at(my_samp_idx)
    local samp = instr.samples[my_samp_idx]
    samp.name  = "8chip Preview (temp)"

    local sbuf = samp.sample_buffer
    sbuf:create_sample_data(SAMPLE_RATE, 32, 1, total_samps)
    sbuf:prepare_sample_data_changes()
    for i = 1, total_samps do
      sbuf:set_sample_data(1, i, buf_data[i] or 0.0)
    end
    sbuf:finalize_sample_data_changes()

    local track_idx = song.selected_track_index
    for i, t in ipairs(song.tracks) do
      if t.type == renoise.Track.TRACK_TYPE_SEQUENCER then
        track_idx = i; break
      end
    end

    song:trigger_sample_note_on(instr_idx, my_samp_idx, track_idx, 48, 1.0)

    local play_dur_ms = math.ceil(total_samps / SAMPLE_RATE * 1000) + 200
    local function stop_this()
      pcall(function()
        song:trigger_sample_note_off(instr_idx, my_samp_idx, track_idx, 48)
        local ci = renoise.song().selected_instrument
        if ci then
          for i = #ci.samples, 1, -1 do
            if ci.samples[i].name == "8chip Preview (temp)" then
              ci:delete_sample_at(i); break
            end
          end
        end
      end)
      renoise.tool():remove_timer(stop_this)
    end
    renoise.tool():add_timer(stop_this, play_dur_ms)
  end

  -- Visibility helpers
  local function refresh_rows()
    local p = state.preset
    -- note_end row only useful for Glide
    vb.views["pitch_note_end_row"].visible  = (p == 3)
    -- rise/drop lines for Laser and Kick
    vb.views["pitch_rise_row"].visible      = (p == 1 or p == 2)
  end

  local panel = vb:column {
    id      = "panel_pitch",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text { text = "Pitch & Glide", font = "bold", style = "strong" },
    vb:text {
      text  = "Writes pitch slide (0U/0D) and portamento (0G) effects into a phrase.",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Preset
    vb:row {
      spacing = 8,
      vb:text  { text = "Preset", width = 90 },
      vb:chooser {
        id    = "pitch_preset",
        items = PRESETS,
        value = state.preset,
        notifier = function(idx)
          state.preset = idx
          refresh_rows()
        end,
      },
    },

    vb:space { height = 2 },

    -- Start note
    vb:row {
      spacing = 8,
      vb:text  { text = "Note / Root", width = 90 },
      vb:popup {
        id    = "pitch_note_start",
        width = 90,
        items = note_items,
        value = state.note_start + 1,
        notifier = function(idx) state.note_start = idx - 1 end,
      },
    },

    -- End note (Glide only)
    vb:row {
      id      = "pitch_note_end_row",
      visible = (state.preset == 3),
      spacing = 8,
      vb:text  { text = "Target Note", width = 90 },
      vb:popup {
        id    = "pitch_note_end",
        width = 90,
        items = note_items,
        value = state.note_end + 1,
        notifier = function(idx) state.note_end = idx - 1 end,
      },
    },

    -- Speed
    vb:row {
      spacing = 8,
      vb:text { text = "Speed (Sweep Rate)", width = 130 },
      vb:minislider {
        id    = "pitch_speed_slider",
        width = 160,
        min   = 1,
        max   = 255,
        value = state.speed,
        notifier = function(v)
          state.speed = math.floor(v)
          vb.views["pitch_speed_label"].text =
            string.format("%d (0x%02X)", math.floor(v), math.floor(v))
        end,
      },
      vb:text {
        id   = "pitch_speed_label",
        text = string.format("%d (0x%02X)", state.speed, state.speed),
      },
    },

    -- Rise/drop lines
    vb:row {
      id      = "pitch_rise_row",
      visible = (state.preset == 1 or state.preset == 2),
      spacing = 8,
      vb:text     { text = "Sweep Lines", width = 90 },
      vb:valuebox {
        id    = "pitch_rise_box",
        min   = 1,
        max   = 64,
        value = state.rise_lines,
        notifier = function(v) state.rise_lines = v end,
      },
      vb:text { text = "lines of slide", style = "disabled" },
    },

    -- LPB
    vb:row {
      spacing = 8,
      vb:text  { text = "LPB", width = 90 },
      vb:popup {
        id    = "pitch_lpb_popup",
        width = 80,
        items = LPB_LABELS,
        value = state.lpb,
        notifier = function(idx) state.lpb = idx end,
      },
    },

    -- Phrase length
    vb:row {
      spacing = 8,
      vb:text     { text = "Phrase Len", width = 90 },
      vb:valuebox {
        id    = "pitch_plen_box",
        min   = 2,
        max   = 64,
        value = state.phrase_len,
        notifier = function(v) state.phrase_len = v end,
      },
    },

    -- Loop
    vb:row {
      spacing = 8,
      vb:text { text = "Loop", width = 90 },
      vb:checkbox {
        id    = "pitch_loop",
        value = state.looping,
        notifier = function(v) state.looping = v end,
      },
    },

    vb:space { height = 6 },

    vb:row {
      spacing = 8,
      vb:button {
        text     = "Preview",
        width    = 110,
        notifier = do_preview,
      },
      vb:button {
        text     = "Write Phrase to Selected Instrument",
        width    = 250,
        notifier = do_write,
      },
    },
  }

  return panel
end
