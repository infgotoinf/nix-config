-- ui/presets_panel.lua
-- Module 2: Preset Library
-- Browse, preview, and load chip presets into instrument slots.

local gen = require("waveforms.generators")
local CW  = require("ui.canvas_wave")

-- ---------------------------------------------------------------------------
-- Category registry
-- ---------------------------------------------------------------------------

local CATEGORIES = {
  { label = "NES",       file = "data.presets.nes"     },
  { label = "Game Boy",  file = "data.presets.gameboy" },
  { label = "C64 / SID", file = "data.presets.c64"    },
  { label = "Genesis",   file = "data.presets.genesis" },
}

-- Cache loaded preset tables so they are only required once
local preset_cache = {}

local function load_presets(cat_idx)
  if not preset_cache[cat_idx] then
    preset_cache[cat_idx] = require(CATEGORIES[cat_idx].file)
  end
  return preset_cache[cat_idx]
end

-- ---------------------------------------------------------------------------
-- Waveform generation from a preset entry
-- ---------------------------------------------------------------------------

local WAVEFORM_FN = {
  sine       = gen.generate_sine,
  square     = gen.generate_square,
  sawtooth   = gen.generate_sawtooth,
  triangle   = gen.generate_triangle,
  noise      = gen.generate_noise,
}

-- Returns true if the preset uses an authentic NES sample file.
local function is_nes_authentic(waveform)
  return waveform and waveform:sub(1, 4) == "nes_"
end

-- Returns true if the preset uses an authentic Genesis sample file.
local function is_genesis_authentic(waveform)
  return waveform and waveform:sub(1, 8) == "genesis_"
end

-- Returns true if the preset uses an authentic Halebop chip sample file.
local function is_chip_authentic(waveform)
  return waveform and waveform:sub(1, 5) == "chip_"
end

local function build_frames_from_preset(p)
  local nf = p.num_frames or 256
  if p.waveform == "pulse" then
    return gen.generate_pulse(nf, p.duty or 0.5)
  elseif p.waveform == "fm" then
    return gen.generate_fm(nf, p.fm_op_ratio or 2.0, p.fm_mod_index or 1.0)
  else
    local fn = WAVEFORM_FN[p.waveform] or gen.generate_sine
    return fn(nf)
  end
end

-- Write preset waveform into the given instrument at sample slot 1.
-- Routes nes_* through load_nes_sample(), genesis_* through load_genesis_sample(),
-- all others use the math path.
local function apply_preset_to_instrument(preset, instrument)
  if is_nes_authentic(preset.waveform) then
    gen.load_nes_sample(instrument, preset.waveform, preset.name)
    -- Apply loop_mode override if specified (load_nes_sample defaults to forward)
    if preset.loop_mode == "off" then
      instrument.samples[1].loop_mode = renoise.Sample.LOOP_MODE_OFF
    elseif preset.loop_mode == "ping_pong" then
      instrument.samples[1].loop_mode = renoise.Sample.LOOP_MODE_PING_PONG
    end
    return
  end

  if is_genesis_authentic(preset.waveform) then
    gen.load_genesis_sample(instrument, preset.waveform, preset.name)
    -- load_genesis_sample sets loop mode from its own table; allow ping_pong override
    if preset.loop_mode == "ping_pong" then
      instrument.samples[1].loop_mode = renoise.Sample.LOOP_MODE_PING_PONG
    end
    return
  end

  if is_chip_authentic(preset.waveform) then
    gen.load_chip_sample(instrument, preset.waveform, preset.name)
    return
  end

  gen.ensure_sample_slot(instrument)
  local frames = build_frames_from_preset(preset)
  instrument.samples[1].name = preset.name
  gen.write_to_buffer(
    instrument, 1,
    preset.sample_rate or 44100,
    preset.bit_depth   or 16,
    preset.loop_mode   or "off",
    frames
  )
end

-- ---------------------------------------------------------------------------
-- Canvas preview helpers
-- Shape approximations for authentic sample waveforms (avoids loading WAVs
-- just for display).
-- ---------------------------------------------------------------------------

local NES_CANVAS_MAP = {
  nes_square   = function(nf) return gen.generate_square(nf) end,
  nes_pulse_25 = function(nf) return gen.generate_pulse(nf, 0.25) end,
  nes_pulse_12 = function(nf) return gen.generate_pulse(nf, 0.125) end,
  nes_triangle = function(nf) return gen.generate_triangle(nf) end,
  nes_noise    = function(nf) return gen.generate_noise(nf) end,
}

local CHIP_CANVAS_MAP = {
  chip_gb_wave_saw      = function(nf) return gen.generate_sawtooth(nf) end,
  chip_gb_wave_triangle = function(nf) return gen.generate_triangle(nf) end,
  chip_sid_sawtooth     = function(nf) return gen.generate_sawtooth(nf) end,
  chip_sid_triangle     = function(nf) return gen.generate_triangle(nf) end,
  chip_sid_pulse_25     = function(nf) return gen.generate_pulse(nf, 0.25) end,
  chip_sid_pulse_50     = function(nf) return gen.generate_square(nf) end,
}

local function get_canvas_frames(p)
  local nf = p.num_frames or 256
  if is_nes_authentic(p.waveform) then
    local fn = NES_CANVAS_MAP[p.waveform]
    return fn and fn(nf) or nil
  elseif is_chip_authentic(p.waveform) then
    local fn = CHIP_CANVAS_MAP[p.waveform]
    return fn and fn(nf) or nil
  elseif is_genesis_authentic(p.waveform) then
    return gen.generate_sawtooth(nf)
  elseif p.waveform == "noise" then
    -- Fixed seed so canvas is stable across multiple calls
    math.randomseed(12345)
    return gen.generate_noise(nf)
  else
    return build_frames_from_preset(p)
  end
end

-- ---------------------------------------------------------------------------
-- Preview note management
-- ---------------------------------------------------------------------------

local preview_active = false
local preview_ctx    = { instr_idx = nil, track_idx = nil }

local function delete_preview_instrument(instr_idx)
  pcall(function()
    local song = renoise.song()
    -- Only delete if it still looks like our temp slot
    if song.instruments[instr_idx] and
       song.instruments[instr_idx].name == "8chip Preview [temp]" then
      song:delete_instrument_at(instr_idx)
    end
  end)
end

local function stop_preset_preview()
  if preview_active and preview_ctx.instr_idx then
    local idx       = preview_ctx.instr_idx
    local track_idx = preview_ctx.track_idx
    -- Send note-off first so the audio engine can process it
    pcall(function()
      renoise.song():trigger_sample_note_off(idx, 1, track_idx, 48)
    end)
    -- Delete the temp instrument after a short delay so the release can complete
    local del_idx = idx
    local function del_timer()
      delete_preview_instrument(del_idx)
      pcall(function() renoise.tool():remove_timer(del_timer) end)
    end
    renoise.tool():add_timer(del_timer, 200)
  end
  preview_active = false
  preview_ctx    = { instr_idx = nil, track_idx = nil }
end

-- ---------------------------------------------------------------------------
-- Public: create_presets_panel(vb)
-- ---------------------------------------------------------------------------
function create_presets_panel(vb)
  local W     = 480
  local prefs = renoise.tool().preferences

  -- Current UI state
  local sel_cat    = 1
  local sel_preset = 1
  local presets    = load_presets(sel_cat)

  -- Canvas preview (set after panel construction)
  local canvas_view
  local function refresh_preset_canvas()
    if not canvas_view then return end
    local p = presets[sel_preset]
    if not p then CW.clear(canvas_view) ; return end
    local frames = get_canvas_frames(p)
    if frames then
      CW.set_data(canvas_view, frames)
    else
      CW.clear(canvas_view)
    end
  end

  -- Derive display list (names) from current preset table
  local function preset_names()
    local names = {}
    for i, p in ipairs(presets) do
      names[i] = p.name
    end
    return names
  end

  -- Update info text below the preset list
  local function refresh_info()
    local p = presets[sel_preset]
    if p then
      vb.views["preset_info"].text = p.description or ""
    else
      vb.views["preset_info"].text = ""
    end
  end

  -- Switch category: reload preset list in the listbox
  local function switch_category(idx)
    sel_cat    = idx
    sel_preset = 1
    presets    = load_presets(sel_cat)
    vb.views["preset_list"].items = preset_names()
    vb.views["preset_list"].value = 1
    refresh_info()
    refresh_preset_canvas()
  end

  -- Preview the currently selected preset (non-destructive: temp instrument)
  local function do_preview()
    local p = presets[sel_preset]
    if not p then return end

    local song = renoise.song()
    stop_preset_preview()

    -- Insert a temporary instrument at the end so selected instrument is untouched
    local temp_idx = #song.instruments + 1
    song:insert_instrument_at(temp_idx)
    local instr = song.instruments[temp_idx]
    instr.name  = "8chip Preview [temp]"
    apply_preset_to_instrument(p, instr)

    local track_idx = gen.find_sequencer_track()
    preview_ctx     = { instr_idx = temp_idx, track_idx = track_idx }
    preview_active  = true

    song:trigger_sample_note_on(temp_idx, 1, track_idx, 48, 1.0, false)

    local function note_off_timer()
      stop_preset_preview()
      renoise.tool():remove_timer(note_off_timer)
    end
    renoise.tool():add_timer(note_off_timer, 1500)
  end

  -- Load preset into a new instrument slot
  local function do_load_single()
    local p = presets[sel_preset]
    if not p then return end

    local song    = renoise.song()
    local new_idx = song.selected_instrument_index + 1
    song:insert_instrument_at(new_idx)
    local instr = song.instruments[new_idx]
    instr.name  = p.name
    apply_preset_to_instrument(p, instr)
    song.selected_instrument_index = new_idx
    renoise.app():show_status("8chip: Loaded \"" .. p.name .. "\"")
  end

  -- Load entire category as a kit (slot 0 = Kit phrase holder, slots 1..N = sounds)
  local function do_load_kit()
    local cat   = CATEGORIES[sel_cat]
    local kit   = load_presets(sel_cat)
    if #kit == 0 then return end

    local song  = renoise.song()
    local base  = song.selected_instrument_index + 1
    local count = #kit

    -- Insert kit holder slot
    song:insert_instrument_at(base)
    song.instruments[base].name = cat.label .. " Kit [phrase holder]"

    -- Insert a slot for each preset
    for i, p in ipairs(kit) do
      local slot  = base + i
      song:insert_instrument_at(slot)
      local instr = song.instruments[slot]
      instr.name  = p.name .. " [ch." .. string.format("%02d", base + i) .. "]"
      apply_preset_to_instrument(p, instr)
    end

    song.selected_instrument_index = base
    renoise.app():show_status(
      "8chip: Loaded " .. cat.label .. " kit (" .. count .. " instruments)")
  end

  -- ---------------------------------------------------------------------------
  -- Build the view
  -- ---------------------------------------------------------------------------
  local panel = vb:column {
    id      = "panel_presets",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text {
      text  = "Preset Library",
      font  = "bold",
      style = "strong",
    },
    vb:text {
      text  = "Browse and load chip instrument presets. Each preset generates its waveform on load.",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Category selector
    vb:row {
      spacing = 8,
      vb:text { text = "Console", width = 70 },
      vb:chooser {
        id    = "preset_cat_chooser",
        items = (function()
          local labels = {}
          for i, c in ipairs(CATEGORIES) do labels[i] = c.label end
          return labels
        end)(),
        value    = sel_cat,
        notifier = switch_category,
      },
    },

    vb:space { height = 2 },

    -- Preset selector
    vb:popup {
      id       = "preset_list",
      width    = math.floor(W / 2),
      items    = preset_names(),
      value    = sel_preset,
      notifier = function(idx)
        sel_preset = idx
        refresh_info()
        refresh_preset_canvas()
      end,
    },

    -- Description text
    vb:text {
      id    = "preset_info",
      text  = presets[1] and presets[1].description or "",
      style = "disabled",
      width = W,
    },

    vb:space { height = 4 },

    -- Action buttons
    vb:row {
      spacing = 8,
      vb:button {
        text     = "Preview",
        width    = 100,
        notifier = do_preview,
      },
      vb:button {
        text     = "Load Preset",
        width    = 130,
        notifier = do_load_single,
      },
      vb:button {
        text     = "Load Full Kit",
        width    = 130,
        notifier = do_load_kit,
      },
    },

    vb:text {
      text  = "\"Load Preset\" adds one instrument. \"Load Full Kit\" adds all in the category.",
      style = "disabled",
    },
    vb:space { height = 8 },
  }

  canvas_view = CW.create(vb, W, 80)
  panel:add_child(canvas_view)

  refresh_info()
  refresh_preset_canvas()
  return panel
end
