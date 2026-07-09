-- ui/percussion_panel.lua
-- Module 5: Percussion Shaper UI

local perc = require("generators.percussion_generator")

local W = 480

local PRESETS = { "Kick", "Snare", "Hi-Hat", "Noise Burst" }

local NOTE_NAMES = { "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" }
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

local function do_preview_note(instr_idx, track_idx, note)
  renoise.song():trigger_instrument_note_on(instr_idx, track_idx, note, 1.0)
  local function off_timer()
    pcall(function()
      renoise.song():trigger_instrument_note_off(instr_idx, track_idx, note)
    end)
    renoise.tool():remove_timer(off_timer)
  end
  renoise.tool():add_timer(off_timer, 800)
end

function create_percussion_panel(vb)
  local note_items = build_note_items()

  local state = {
    preset          = 1,
    note            = 48,  -- C4
    decay_lines     = 4,
    retrigger_count = 4,
    cut_tick        = 2,
    probability     = 0,
    lpb             = 3,   -- index → 16
    phrase_len      = 16,
    looping         = false,
  }

  local function get_lpb() return LPB_VALUES[state.lpb] or 16 end

  local function do_write()
    local song  = renoise.song()
    local instr = song.selected_instrument
    if not instr then
      renoise.app():show_error("8chip: No instrument selected.")
      return
    end
    local p   = state.preset
    local lpb = get_lpb()
    if p == 1 then
      perc.write_kick(instr, state.note, state.decay_lines,
                      lpb, state.phrase_len, state.looping)
    elseif p == 2 then
      perc.write_snare(instr, state.note, state.retrigger_count,
                       lpb, state.phrase_len, state.looping)
    elseif p == 3 then
      perc.write_hihat(instr, state.note, state.cut_tick, state.probability,
                       lpb, state.phrase_len, state.looping)
    elseif p == 4 then
      perc.write_noise_burst(instr, state.note, state.decay_lines,
                             lpb, state.phrase_len, state.looping)
    end
    renoise.app():show_status("8chip: Percussion phrase written.")
  end

  local function do_preview()
    local song      = renoise.song()
    local instr_idx = song.selected_instrument_index
    do_write()
    local track_idx = song.selected_track_index
    for i, t in ipairs(song.tracks) do
      if t.type == renoise.Track.TRACK_TYPE_SEQUENCER then
        track_idx = i; break
      end
    end
    do_preview_note(instr_idx, track_idx, state.note)
  end

  local function refresh_rows()
    local p = state.preset
    vb.views["perc_decay_row"].visible    = (p == 1 or p == 4)
    vb.views["perc_retrig_row"].visible   = (p == 2)
    vb.views["perc_cut_row"].visible      = (p == 3)
    vb.views["perc_prob_row"].visible     = (p == 3)
  end

  local panel = vb:column {
    id      = "panel_percussion",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text { text = "Percussion Shaper", font = "bold", style = "strong" },
    vb:text {
      text  = "Writes effect-driven percussion patterns (volume fade, 0C cut, 0R retrigger, 0Y probability).",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Preset
    vb:row {
      spacing = 8,
      vb:text    { text = "Preset", width = 90 },
      vb:chooser {
        id    = "perc_preset",
        items = PRESETS,
        value = state.preset,
        notifier = function(idx)
          state.preset = idx
          refresh_rows()
        end,
      },
    },

    vb:space { height = 2 },

    -- Note
    vb:row {
      spacing = 8,
      vb:text  { text = "Note", width = 90 },
      vb:popup {
        id    = "perc_note",
        width = 90,
        items = note_items,
        value = state.note + 1,
        notifier = function(idx) state.note = idx - 1 end,
      },
    },

    -- Decay lines (Kick + Noise)
    vb:row {
      id      = "perc_decay_row",
      visible = true,
      spacing = 8,
      vb:text     { text = "Decay Lines", width = 90 },
      vb:valuebox {
        id    = "perc_decay_box",
        min   = 1,
        max   = 32,
        value = state.decay_lines,
        notifier = function(v) state.decay_lines = v end,
      },
    },

    -- Retrigger count (Snare)
    vb:row {
      id      = "perc_retrig_row",
      visible = false,
      spacing = 8,
      vb:text     { text = "Retriggers", width = 90 },
      vb:valuebox {
        id    = "perc_retrig_box",
        min   = 1,
        max   = 15,
        value = state.retrigger_count,
        notifier = function(v) state.retrigger_count = v end,
      },
    },

    -- Cut tick (Hi-hat)
    vb:row {
      id      = "perc_cut_row",
      visible = false,
      spacing = 8,
      vb:text     { text = "Cut Tick", width = 90 },
      vb:valuebox {
        id    = "perc_cut_box",
        min   = 1,
        max   = 255,
        value = state.cut_tick,
        notifier = function(v) state.cut_tick = v end,
      },
      vb:text { text = "(lower = tighter)", style = "disabled" },
    },

    -- Probability (Hi-hat)
    vb:row {
      id      = "perc_prob_row",
      visible = false,
      spacing = 8,
      vb:text { text = "Probability", width = 90 },
      vb:slider {
        id    = "perc_prob_slider",
        width = 160,
        min   = 0,
        max   = 255,
        value = state.probability,
        notifier = function(v)
          state.probability = math.floor(v)
          vb.views["perc_prob_label"].text =
            string.format("%d%%", math.floor(math.floor(v) / 255 * 100))
        end,
      },
      vb:text {
        id   = "perc_prob_label",
        text = "0%",
      },
    },

    -- LPB
    vb:row {
      spacing = 8,
      vb:text  { text = "LPB", width = 90 },
      vb:popup {
        id    = "perc_lpb",
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
        id    = "perc_plen",
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
        id    = "perc_loop",
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
