-- ui/modulation_panel.lua
-- Module 6: Modulation Injector
-- Write 0V / 0T / 0N modulation into phrases or the selected pattern region.

local mod = require("generators.modulation_generator")

local W = 480

-- Built-in presets: { label, effect, speed (0-15), depth (0-15) }
local PRESETS = {
  { label = "Chiptune Vibrato",  effect = "0V", speed = 12, depth = 3 },
  { label = "16-bit Vibrato",    effect = "0V", speed = 10, depth = 6 },
  { label = "Deep Wobble",   effect = "0V", speed = 5,  depth = 12 },
  { label = "Wobble Bass",   effect = "0T", speed = 8,  depth = 8  },
  { label = "Tremolo Flutter", effect = "0T", speed = 14, depth = 5 },
  { label = "Wide Stereo",   effect = "0N", speed = 6,  depth = 10 },
  { label = "Fast Pan",      effect = "0N", speed = 14, depth = 8  },
}

local EFFECTS     = { "Vibrato (0V)", "Tremolo (0T)", "Auto-Pan (0N)" }
local EFFECT_CMDS = { "0V", "0T", "0N" }

local NOTE_NAMES = { "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" }
local function build_note_items()
  local items = {}
  for note = 0, 119 do
    items[note + 1] = NOTE_NAMES[(note % 12) + 1] .. tostring(math.floor(note / 12))
  end
  return items
end

local LPB_VALUES = { 4, 8, 16, 32 }
local LPB_LABELS = { "4", "8", "16", "32" }

function create_modulation_panel(vb)
  local note_items = build_note_items()

  local state = {
    preset     = 1,
    effect_idx = 1,        -- 1=0V 2=0T 3=0N
    speed      = 12,       -- nibble 0-15
    depth      = 3,        -- nibble 0-15
    note       = 60,       -- C5
    lpb        = 3,        -- index → 16
    phrase_len = 16,
    looping    = true,
    target     = 1,        -- 1=phrase, 2=pattern region
  }

  local function get_lpb() return LPB_VALUES[state.lpb] or 16 end

  local function packed_val()
    local s = math.max(0, math.min(15, state.speed))
    local d = math.max(0, math.min(15, state.depth))
    return string.format("%02X", s * 16 + d)
  end

  local function effect_cmd()
    return EFFECT_CMDS[state.effect_idx] or "0V"
  end

  local function refresh_target_rows()
    vb.views["mod_phrase_rows"].visible  = (state.target == 1)
    vb.views["mod_pattern_note"].visible = (state.target == 2)
  end

  -- Apply a preset row to the UI state
  local function apply_preset(idx)
    local p = PRESETS[idx]
    if not p then return end
    -- Find matching effect_idx
    for i, cmd in ipairs(EFFECT_CMDS) do
      if cmd == p.effect then state.effect_idx = i; break end
    end
    state.speed = p.speed
    state.depth = p.depth
    -- Sync widgets
    vb.views["mod_effect_chooser"].value = state.effect_idx
    vb.views["mod_speed_slider"].value   = state.speed
    vb.views["mod_depth_slider"].value   = state.depth
    vb.views["mod_speed_label"].text     = tostring(state.speed)
    vb.views["mod_depth_label"].text     = tostring(state.depth)
    vb.views["mod_packed_label"].text    = effect_cmd() .. " " .. packed_val()
  end

  local function update_packed_label()
    vb.views["mod_packed_label"].text = effect_cmd() .. " " .. packed_val()
  end

  local function do_write_phrase()
    local song  = renoise.song()
    local instr = song.selected_instrument
    if not instr then
      renoise.app():show_error("8chip: No instrument selected.")
      return
    end
    local lpb = get_lpb()
    local cmd = state.effect_idx
    if cmd == 1 then
      mod.write_vibrato(instr, state.note, state.speed, state.depth,
                        lpb, state.phrase_len, state.looping)
    elseif cmd == 2 then
      mod.write_tremolo(instr, state.note, state.speed, state.depth,
                        lpb, state.phrase_len, state.looping)
    elseif cmd == 3 then
      mod.write_autopan(instr, state.note, state.speed, state.depth,
                        lpb, state.phrase_len, state.looping)
    end
    renoise.app():show_status("8chip: Modulation phrase written.")
  end

  local function do_inject_pattern()
    mod.inject_into_pattern(effect_cmd(), packed_val())
    renoise.app():show_status("8chip: Modulation injected into pattern region.")
  end

  local function do_preview()
    local song      = renoise.song()
    local instr_idx = song.selected_instrument_index
    do_write_phrase()
    local track_idx = song.selected_track_index
    for i, t in ipairs(song.tracks) do
      if t.type == renoise.Track.TRACK_TYPE_SEQUENCER then
        track_idx = i; break
      end
    end
    renoise.song():trigger_instrument_note_on(instr_idx, track_idx, state.note, 1.0)
    local function off() pcall(function()
      renoise.song():trigger_instrument_note_off(instr_idx, track_idx, state.note)
    end); renoise.tool():remove_timer(off) end
    renoise.tool():add_timer(off, 2500)
  end

  local panel = vb:column {
    id      = "panel_modulation",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text { text = "Modulation Injector", font = "bold", style = "strong" },
    vb:text {
      text  = "Writes 0V (vibrato), 0T (tremolo), 0N (auto-pan) into a phrase or injects\n"
           .. "into the currently selected pattern region.",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Quick presets
    vb:row {
      spacing = 8,
      vb:text { text = "Quick Preset", width = 90 },
      vb:popup {
        id    = "mod_preset",
        width = 200,
        items = (function()
          local labels = {}
          for _, p in ipairs(PRESETS) do labels[#labels + 1] = p.label end
          return labels
        end)(),
        value = state.preset,
        notifier = function(idx)
          state.preset = idx
          apply_preset(idx)
        end,
      },
    },

    vb:space { height = 2 },

    -- Effect type
    vb:row {
      spacing = 8,
      vb:text    { text = "Effect", width = 90 },
      vb:chooser {
        id    = "mod_effect_chooser",
        items = EFFECTS,
        value = state.effect_idx,
        notifier = function(idx)
          state.effect_idx = idx
          update_packed_label()
        end,
      },
    },

    -- Speed
    vb:row {
      spacing = 8,
      vb:text { text = "Speed", width = 90 },
      vb:slider {
        id    = "mod_speed_slider",
        width = 180,
        min   = 0,
        max   = 15,
        value = state.speed,
        notifier = function(v)
          state.speed = math.floor(v)
          vb.views["mod_speed_label"].text = tostring(state.speed)
          update_packed_label()
        end,
      },
      vb:text { id = "mod_speed_label", text = tostring(state.speed) },
      vb:text { text = "(0–15, hi nibble)", style = "disabled" },
    },

    -- Depth
    vb:row {
      spacing = 8,
      vb:text { text = "Depth", width = 90 },
      vb:slider {
        id    = "mod_depth_slider",
        width = 180,
        min   = 0,
        max   = 15,
        value = state.depth,
        notifier = function(v)
          state.depth = math.floor(v)
          vb.views["mod_depth_label"].text = tostring(state.depth)
          update_packed_label()
        end,
      },
      vb:text { id = "mod_depth_label", text = tostring(state.depth) },
      vb:text { text = "(0–15, lo nibble)", style = "disabled" },
    },

    vb:row {
      spacing = 8,
      vb:text { text = "Effect value", width = 90, style = "disabled" },
      vb:text { id = "mod_packed_label",
                text = effect_cmd() .. " " .. packed_val(),
                style = "strong" },
    },

    vb:space { height = 6 },

    -- Target toggle
    vb:row {
      spacing = 8,
      vb:text    { text = "Target", width = 90 },
      vb:chooser {
        id    = "mod_target",
        items = { "New Phrase", "Pattern Region" },
        value = state.target,
        notifier = function(idx)
          state.target = idx
          refresh_target_rows()
          if idx == 2 then
            vb.views["mod_write_btn"].text = "Inject into Pattern Region"
          else
            vb.views["mod_write_btn"].text = "Write Phrase to Selected Instrument"
          end
        end,
      },
    },

    -- Phrase-specific controls
    vb:column {
      id      = "mod_phrase_rows",
      visible = true,
      spacing = 4,

      vb:row {
        spacing = 8,
        vb:text  { text = "Note", width = 90 },
        vb:popup {
          id    = "mod_note",
          width = 90,
          items = note_items,
          value = state.note + 1,
          notifier = function(idx) state.note = idx - 1 end,
        },
      },
      vb:row {
        spacing = 8,
        vb:text  { text = "LPB", width = 90 },
        vb:popup {
          id    = "mod_lpb",
          width = 80,
          items = LPB_LABELS,
          value = state.lpb,
          notifier = function(idx) state.lpb = idx end,
        },
      },
      vb:row {
        spacing = 8,
        vb:text     { text = "Phrase Len", width = 90 },
        vb:valuebox {
          id    = "mod_plen",
          min   = 2,
          max   = 64,
          value = state.phrase_len,
          notifier = function(v) state.phrase_len = v end,
        },
      },
      vb:row {
        spacing = 8,
        vb:text { text = "Loop", width = 90 },
        vb:checkbox {
          id    = "mod_loop",
          value = state.looping,
          notifier = function(v) state.looping = v end,
        },
      },
    },

    -- Pattern-mode info (no extra controls needed)
    vb:text {
      id    = "mod_pattern_note",
      text  = "Injects effects onto lines that already have a note trigger in the selected pattern region (or whole track if no selection). Does not write or remove notes.",
      style = "disabled",
      visible = false,
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
        id       = "mod_write_btn",
        text     = "Write Phrase to Selected Instrument",
        width    = 250,
        notifier = function()
          if state.target == 1 then
            do_write_phrase()
          else
            do_inject_pattern()
          end
        end,
      },
    },
  }

  return panel
end
