-- ui/arp_panel.lua
-- Module 3: Arp Generator
-- Hardware (0A), Explicit note, and Script (pattrns) modes.

local arp   = require("generators.arp_generator")
local chord = require("data.chords")

local W = 480

local ARP_MODES     = { "Hardware (0A effect)", "Explicit notes", "Script (pattrns)" }
local ARP_PATTERNS  = { "Ascending", "Descending", "Ping-Pong", "Down-Up", "Skip (1-3-2)", "Random" }
local LPB_VALUES    = { 4, 8, 12, 16, 24, 32, 48, 64 }
local LPB_LABELS    = { "4", "8", "12", "16 (default)", "24", "32", "48", "64 (ultra-fast)" }
local PHRASE_LENS   = { 8, 16, 24, 32, 48, 64 }
local PHRASE_LABELS = { "8", "16", "24", "32", "48", "64" }

local NOTE_NAMES = {
  "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
}

-- Build note selector items: C0..B9 = 0..119
local function build_note_items()
  local items = {}
  for note = 0, 119 do
    local oct  = math.floor(note / 12)
    local semi = note % 12
    items[note + 1] = NOTE_NAMES[semi + 1] .. tostring(oct)
  end
  return items
end

-- ---------------------------------------------------------------------------
-- Live mode state — module-level so notifiers survive panel recreation
-- ---------------------------------------------------------------------------
local live_mode_active = false

-- ---------------------------------------------------------------------------
-- Preview arp: synthesise the arp sequence as a square-wave audio buffer,
-- write it to a temporary sample slot, play it, then clean it up.
-- trigger_instrument_note_on only plays raw samples; it does not trigger
-- phrases, so we generate the audio ourselves.
-- ---------------------------------------------------------------------------
local preview_note_active = false
local preview_samp_idx    = nil

local function preview_arp(prefs)
  local song      = renoise.song()
  local instr     = song.selected_instrument
  local instr_idx = song.selected_instrument_index
  if not instr then
    renoise.app():show_error("8chip: No instrument selected.")
    return
  end
  if preview_note_active then return end

  local root    = prefs.arp_root_note.value
  local cidx    = prefs.arp_chord_type.value
  local ospan   = prefs.arp_octave_span.value
  local ptype   = prefs.arp_pattern.value
  local lpb     = LPB_VALUES[prefs.arp_lpb.value]

  -- Build the note sequence (intervals relative to root)
  local intervals = chord.get_intervals(cidx)
  local seq       = arp.make_arp_sequence(intervals, ptype, ospan)
  local seq_len   = #seq
  if seq_len == 0 then return end

  -- Synthesise a square-wave buffer representing the arp at 120 BPM
  local SAMPLE_RATE = 22050
  local line_dur    = 60.0 / (120 * lpb / 4.0)   -- seconds per line
  local num_cycles  = 3
  local note_samps  = math.max(1, math.floor(line_dur * SAMPLE_RATE))
  local total_samps = seq_len * num_cycles * note_samps

  -- Append a temporary sample (deleted after playback)
  local new_samp_idx = #instr.samples + 1
  instr:insert_sample_at(new_samp_idx)
  local samp = instr.samples[new_samp_idx]
  samp.name  = "8chip Preview (temp)"

  local buf = samp.sample_buffer
  buf:create_sample_data(SAMPLE_RATE, 32, 1, total_samps)
  buf:prepare_sample_data_changes()

  local frame = 1
  for _ = 1, num_cycles do
    for _, interval in ipairs(seq) do
      local midi_note = math.max(0, math.min(119, root + interval))
      local freq      = 440.0 * 2.0 ^ ((midi_note - 69) / 12.0)
      local period    = SAMPLE_RATE / freq
      for s = 0, note_samps - 1 do
        local phase = (s % period) / period
        local sq    = (phase < 0.5) and 0.65 or -0.65
        local decay = 1.0 - (s / note_samps) * 0.6
        buf:set_sample_data(1, frame, sq * decay)
        frame = frame + 1
      end
    end
  end
  buf:finalize_sample_data_changes()

  -- Find a sequencer track to route through
  local track_idx = song.selected_track_index
  for i, track in ipairs(song.tracks) do
    if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
      track_idx = i
      break
    end
  end

  -- Play the synthesised buffer directly (bypasses keyzones and phrases)
  preview_note_active = true
  preview_samp_idx    = new_samp_idx
  song:trigger_sample_note_on(instr_idx, new_samp_idx, track_idx, 48, 1.0)

  local play_dur_ms = math.ceil(total_samps / SAMPLE_RATE * 1000) + 300
  local function stop_preview()
    pcall(function()
      song:trigger_sample_note_off(instr_idx, preview_samp_idx, track_idx, 48)
      -- Remove temp sample by name to avoid stale-index errors
      local cur_instr = renoise.song().selected_instrument
      if cur_instr then
        for i = #cur_instr.samples, 1, -1 do
          if cur_instr.samples[i].name == "8chip Preview (temp)" then
            cur_instr:delete_sample_at(i)
            break
          end
        end
      end
    end)
    preview_note_active = false
    preview_samp_idx    = nil
    renoise.tool():remove_timer(stop_preview)
  end
  renoise.tool():add_timer(stop_preview, play_dur_ms)
end

-- ---------------------------------------------------------------------------
-- Public: create_arp_panel(vb)
-- ---------------------------------------------------------------------------
function create_arp_panel(vb)
  local prefs      = renoise.tool().preferences
  local note_items = build_note_items()
  local chord_names = chord.get_names()

  -- Clamp stored indices to valid popup ranges (guards against stale prefs)
  if prefs.arp_lpb.value < 1 or prefs.arp_lpb.value > #LPB_VALUES then
    prefs.arp_lpb.value = 4
  end
  if prefs.arp_phrase_len.value < 1 or prefs.arp_phrase_len.value > #PHRASE_LENS then
    prefs.arp_phrase_len.value = 2
  end
  if prefs.arp_chord_type.value < 1 or prefs.arp_chord_type.value > #chord_names then
    prefs.arp_chord_type.value = 2
  end
  if prefs.arp_root_note.value < 0 or prefs.arp_root_note.value > 119 then
    prefs.arp_root_note.value = 48
  end

  -- LPB popup index → closest match to stored value
  local function lpb_idx()
    return prefs.arp_lpb.value
  end

  local function refresh_mode_hint()
    local mode = prefs.arp_mode.value
    local hints = {
      [1] = "One note per line + 0A XY effect. Most hardware-authentic. Best for 3-note chords.",
      [2] = "Each chord note on its own phrase line. Full per-note control.",
      [3] = "Writes a pattrns Lua script. Algorithmic, live-tweakable. Requires Renoise 3.5.",
    }
    vb.views["arp_mode_hint"].text = hints[mode] or ""
  end

  local panel = vb:column {
    id      = "panel_arp",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    -- Header
    vb:text {
      text  = "Arp Generator",
      font  = "bold",
      style = "strong",
    },
    vb:text {
      text  = "Writes an arpeggio phrase into the selected instrument.",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Mode
    vb:row {
      spacing = 8,
      vb:text { text = "Mode", width = 90 },
      vb:chooser {
        id    = "arp_mode_chooser",
        items = ARP_MODES,
        value = prefs.arp_mode.value,
        notifier = function(idx)
          prefs.arp_mode.value = idx
          refresh_mode_hint()
        end,
      },
    },
    vb:text {
      id    = "arp_mode_hint",
      text  = "",
      style = "disabled",
      width = W,
    },

    vb:space { height = 4 },

    -- Root note
    vb:row {
      spacing = 8,
      vb:text  { text = "Root Note", width = 90 },
      vb:popup {
        id    = "arp_root_popup",
        width = 90,
        items = note_items,
        value = prefs.arp_root_note.value + 1,  -- popup is 1-based
        notifier = function(idx)
          prefs.arp_root_note.value = idx - 1
        end,
      },
    },

    -- Chord type + inline reference grid
    vb:row {
      spacing = 8,
      vb:text  { text = "Chord", width = 90 },
      vb:popup {
        id    = "arp_chord_popup",
        width = 130,
        items = chord_names,
        value = prefs.arp_chord_type.value,
        notifier = function(idx)
          prefs.arp_chord_type.value = idx
          -- Update the interval display
          local ivs = chord.get_intervals(idx)
          vb.views["arp_chord_ivs"].text = "  intervals: " .. table.concat(ivs, ", ")
        end,
      },
      vb:text {
        id    = "arp_chord_ivs",
        text  = "  intervals: " .. table.concat(chord.get_intervals(prefs.arp_chord_type.value), ", "),
        style = "disabled",
      },
    },

    -- Octave span
    vb:row {
      spacing = 8,
      vb:text { text = "Octave Span", width = 90 },
      vb:chooser {
        id    = "arp_oct_chooser",
        items = { "1", "2", "3" },
        value = prefs.arp_octave_span.value,
        notifier = function(idx)
          prefs.arp_octave_span.value = idx
        end,
      },
      vb:text { text = "octave(s)", style = "disabled" },
    },

    -- Arp pattern
    vb:row {
      spacing = 8,
      vb:text  { text = "Pattern", width = 90 },
      vb:popup {
        id    = "arp_pattern_popup",
        width = 160,
        items = ARP_PATTERNS,
        value = prefs.arp_pattern.value,
        notifier = function(idx)
          prefs.arp_pattern.value = idx
        end,
      },
    },

    -- LPB (speed)
    vb:row {
      spacing = 8,
      vb:text  { text = "LPB (Speed)", width = 90 },
      vb:popup {
        id    = "arp_lpb_popup",
        width = 160,
        items = LPB_LABELS,
        value = prefs.arp_lpb.value,
        notifier = function(idx)
          prefs.arp_lpb.value = idx
        end,
      },
      vb:text { text = "lines per beat", style = "disabled" },
    },

    -- Phrase length (not shown for Script mode but kept for HW/Explicit)
    vb:row {
      spacing = 8,
      vb:text  { text = "Phrase Len", width = 90 },
      vb:popup {
        id    = "arp_plen_popup",
        width = 90,
        items = PHRASE_LABELS,
        value = prefs.arp_phrase_len.value,
        notifier = function(idx)
          prefs.arp_phrase_len.value = idx
        end,
      },
      vb:text { text = "lines", style = "disabled" },
    },

    -- Loop
    vb:row {
      spacing = 8,
      vb:text { text = "Loop", width = 90 },
      vb:checkbox {
        id    = "arp_loop_check",
        value = prefs.arp_loop.value,
        notifier = function(v)
          prefs.arp_loop.value = v
        end,
      },
    },

    vb:space { height = 6 },

    -- Chord reference
    vb:text {
      text  = "Chord Reference",
      font  = "bold",
    },
    vb:text {
      text = "Power: 0,7  -  Major: 0,4,7  -  Minor: 0,3,7  -  Dim: 0,3,6  -  Aug: 0,4,8\n" ..
             "Sus2: 0,2,7  -  Sus4: 0,5,7  -  Octave: 0,12  -  Maj7: 0,4,7,11\n" ..
             "Min7: 0,3,7,10  -  Dom7: 0,4,7,10",
      style = "disabled",
      width = W,
    },

    vb:space { height = 6 },

    -- Action buttons + Live mode
    vb:row {
      spacing = 8,
      vb:button {
        text     = "Preview",
        width    = 110,
        notifier = function()
          preview_arp(prefs)
        end,
      },
      vb:button {
        id       = "arp_write_btn",
        text     = "Write Phrase to Selected Instrument",
        width    = 250,
        notifier = function()
          local song  = renoise.song()
          local instr = song.selected_instrument
          if not instr then
            renoise.app():show_error("8chip: No instrument selected.")
            return
          end
          local root    = prefs.arp_root_note.value
          local cidx    = prefs.arp_chord_type.value
          local ospan   = prefs.arp_octave_span.value
          local ptype   = prefs.arp_pattern.value
          local lpb     = LPB_VALUES[prefs.arp_lpb.value]
          local plen    = PHRASE_LENS[prefs.arp_phrase_len.value] or 16
          local looping = prefs.arp_loop.value
          local mode    = prefs.arp_mode.value
          if mode == 1 then
            arp.write_hardware_mode(instr, root, cidx, ospan, ptype, lpb, plen, looping)
          elseif mode == 2 then
            arp.write_explicit_mode(instr, root, cidx, ospan, ptype, lpb, plen, looping)
          else
            arp.write_script_mode(instr, root, cidx, ospan, ptype, lpb, looping)
          end
          renoise.app():show_status("8chip: Arp phrase written.")
        end,
      },
    },

    -- Live mode row (Script mode only)
    vb:row {
      id      = "arp_live_row",
      spacing = 8,
      visible = (prefs.arp_mode.value == 3),
      vb:checkbox {
        id    = "arp_live_check",
        value = false,
        notifier = function(enabled)
          live_mode_active = enabled
          vb.views["arp_live_status"].text = enabled
            and "LIVE — chord/root changes apply instantly at next loop"
            or  "Off"
          vb.views["arp_live_status"].style = enabled and "strong" or "disabled"
        end,
      },
      vb:text { text = "Live Mode", width = 80 },
      vb:text {
        id    = "arp_live_status",
        text  = "Off",
        style = "disabled",
        width = W - 120,
      },
    },
  }

  -- Helper: re-write script phrase on the current instrument if live mode is on
  local function live_update()
    if not live_mode_active then return end
    if prefs.arp_mode.value ~= 3 then return end
    local instr = renoise.song().selected_instrument
    if not instr then return end
    pcall(function()
      arp.write_script_mode(
        instr,
        prefs.arp_root_note.value,
        prefs.arp_chord_type.value,
        prefs.arp_octave_span.value,
        prefs.arp_pattern.value,
        LPB_VALUES[prefs.arp_lpb.value],
        prefs.arp_loop.value,
        true  -- reuse_phrase: live mode overwrites, does not accumulate
      )
    end)
  end

  -- Attach live_update to every control that affects the script output
  prefs.arp_root_note:add_notifier(live_update)
  prefs.arp_chord_type:add_notifier(live_update)
  prefs.arp_octave_span:add_notifier(live_update)
  prefs.arp_pattern:add_notifier(live_update)
  prefs.arp_lpb:add_notifier(live_update)
  prefs.arp_loop:add_notifier(live_update)

  -- Show/hide live row when mode changes
  prefs.arp_mode:add_notifier(function()
    local is_script = (prefs.arp_mode.value == 3)
    vb.views["arp_live_row"].visible = is_script
    -- Turn off live mode when leaving Script
    if not is_script and live_mode_active then
      live_mode_active = false
      vb.views["arp_live_check"].value = false
      vb.views["arp_live_status"].text  = "Off"
      vb.views["arp_live_status"].style = "disabled"
    end
  end)

  -- Init mode hint
  refresh_mode_hint()

  return panel
end
