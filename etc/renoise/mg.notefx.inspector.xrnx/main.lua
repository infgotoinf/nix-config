--[[============================================================================
MG Note & FX Inspector  (Effect Command Inspector)
------------------------------------------------------------------------------
Resolves a single effect-column command into a plain-language readout.

  * SELECTION drives the readout: the command at the END of the selection is
    shown, so while click-dragging the readout follows the drag end.
  * If there is NO selection, the command under the edit cursor is shown.

Device commands resolve to the real device + parameter name and the real
scaled value the command would set. The scaled value is read by briefly
assigning the parameter, reading value_string, then restoring it - only while
playback is stopped, for the single shown command, and toggleable.

Text colour: Renoise text views have no RGB colour; the brightest available is
multiline_text style "strong" (white on the default dark theme), used here for
all text.

The API (6 / 3.5.x) has no mouse-hover over the native Pattern Editor; this
reads the selection or edit cursor instead.
============================================================================]]--

local DEVICE_OFFSET = 1   -- command device digit -> track.devices[digit + 1]
local PARAM_OFFSET  = 0   -- command param digit  -> device.parameters[digit + 0]

-- ----------------------------------------------------------------------------
-- Command tables (verified against the official Renoise 3.5 manual)
-- ----------------------------------------------------------------------------

local BUILTIN = {  -- first char "0"
  A = { "Arpeggio (pitch)", function(x,y) return
    ("Arpeggio: alternate the note with +%Xh and +%Xh semitones (0 = original note)."):format(x,y) end },
  U = { "Pitch slide up", function(x,y,v) return
    ("Slide pitch up by %d/16 of a semitone per line (~%.2f semitone). 00 repeats last value."):format(v, v/16) end },
  D = { "Pitch slide down", function(x,y,v) return
    ("Slide pitch down by %d/16 of a semitone per line (~%.2f semitone). 00 repeats last value."):format(v, v/16) end },
  G = { "Glide to note", function(x,y,v) return
    ("Glide toward the note by %d/16 of a semitone (~%.2f). FF = instant. 00 repeats last value."):format(v, v/16) end },
  V = { "Vibrato (pitch)", function(x,y) return
    ("Vibrato: regular pitch variation. Speed = %Xh, depth = %Xh."):format(x,y) end },
  I = { "Volume fade in", function(x,y,v) return ("Fade volume in by %d volume units per tick."):format(v) end },
  O = { "Volume fade out", function(x,y,v) return ("Fade volume out by %d volume units per tick."):format(v) end },
  T = { "Tremolo (volume)", function(x,y) return
    ("Tremolo: regular volume variation. Speed = %Xh, depth = %Xh."):format(x,y) end },
  C = { "Volume cut", function(x,y) return
    ("Cut volume to factor x = %Xh (0 = 0%%, F = 100%%) after y = %Xh ticks. Playback continues."):format(x,y) end },
  S = { "Sample offset / slice", function(x,y,v) return
    ("Play from offset ~%.0f%% into the sample, or trigger slice #%Xh."):format(v/256*100, v) end },
  B = { "Sample direction", function(x,y,v,vs) return
    ("Play sample backwards (00) or forwards (01). Current: %s."):format(v==0 and "backwards" or (v==1 and "forwards" or vs)) end },
  E = { "Modulation set position", function(x,y,v) return
    ("Set all Envelope / AHDSR / Fader / Stepper modulation devices to offset %Xh."):format(v) end },
  N = { "Auto-pan", function(x,y) return ("Auto-pan: regular pan variation. Speed = %Xh, depth = %Xh."):format(x,y) end },
  M = { "Channel volume", function(x,y,v) return
    ("Set instrument channel volume. 00 = -60 dB, FF = +3 dB. Value = %Xh."):format(v) end },
  Z = { "Trigger phrase", function(x,y,v) return ("Trigger phrase #%Xh (00 = none, 7F = keymap mode)."):format(v) end },
  Q = { "Delay line", function(x,y,v) return ("Delay this whole line by %d ticks (0 - TPL)."):format(v) end },
  Y = { "Maybe-trigger line", function(x,y,v) return
    ("Trigger this line with probability ~%.0f%% (00 = mutually-exclusive mode)."):format(v/255*100) end },
  R = { "Retrigger instrument", function(x,y) return
    ("Retrigger every y = %Xh ticks, volume factor x = %Xh applied each time. Restarts the sample."):format(y,x) end },
  L = { "Pre-mixer volume", function(x,y,v) return
    ("Set track pre-mixer volume. 00 = -INF, FF = +3 dB. Value = %Xh."):format(v) end },
  P = { "Pre-mixer pan", function(x,y,v) return
    ("Set track pre-mixer pan. 00 = full left, 80 = center, FF = full right. Value = %Xh."):format(v) end },
  W = { "Surround width", function(x,y,v) return
    ("Set track pre-mixer surround width. 00 = off, FF = max. Value = %Xh."):format(v) end },
  X = { "Stop notes / FX", function(x,y,v) return
    (v==0 and "Stop all notes and FX." or ("Stop a specific effect (#%Xh)."):format(v)) end },
  J = { "Output routing", function(x,y,v) return
    ("Route track output to channel %Xh (00 = master, 01+ = hardware outputs, FF = closest parent group)."):format(v) end },
}

local GLOBAL = {  -- first char "Z"
  T = { "Tempo (BPM)", function(v) return ("Set tempo to %d BPM (valid 20 - 255; 00 = stop song)."):format(v) end },
  L = { "Lines Per Beat", function(v) return ("Set Lines Per Beat to %d (01 - FF; 00 = stop song)."):format(v) end },
  K = { "Ticks Per Line", function(v) return ("Set Ticks Per Line to %d (01 - 16)."):format(v) end },
  G = { "Groove toggle", function(v) return ("Toggle song groove (00 = off, 01 or higher = on).") end },
  B = { "Break pattern", function(v) return ("End this pattern now and jump to the next at line %d (hex; lines usually shown decimal)."):format(v) end },
  D = { "Delay pattern", function(v) return ("Pause pattern playback by %d lines."):format(v) end },
}

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------

local function is_empty_cmd(efx, num_str)
  if efx and efx.is_empty then return true end
  return num_str == "" or num_str == ".." or num_str == "00"
end

local function preview_scaled(param, amt_val)
  local lo, hi = param.value_min, param.value_max
  local pos = amt_val / 255
  local target
  if lo >= 0 and hi <= 1.0000001 then target = pos else target = lo + (hi - lo) * pos end
  if target < lo then target = lo elseif target > hi then target = hi end
  local saved = param.value
  if not pcall(function() param.value = target end) then return nil end
  local s; pcall(function() s = param.value_string end)
  pcall(function() param.value = saved end)
  return s
end

local function current_value_string(param)
  local s; pcall(function() s = param.value_string end); return s
end

-- returns: detail, head_label, head_value
local function resolve_device(dev_digit, param_digit, amt_val, amt_str, track, can_probe)
  if not track then
    if param_digit == 0 then
      local s = (amt_str=="00") and "OFF" or (amt_str=="01" and "ON" or amt_str)
      return ("Turn effect device #%d %s."):format(dev_digit, s), ("Device #%d / On-Off"):format(dev_digit), s
    end
    return ("Set effect device #%d, parameter #%d to %Xh (%d/255, ~%.0f%%)."):format(dev_digit, param_digit, amt_val, amt_val, amt_val/255*100),
      ("Device #%d / param #%d"):format(dev_digit, param_digit), ""
  end

  local n_user = math.max(#track.devices - 1, 0)
  local dev = track.devices[dev_digit + DEVICE_OFFSET]
  if not dev then
    return ("Targets effect device #%d, but this track's chain has %d effect device(s)."):format(dev_digit, n_user),
      ("Device #%d (not in this track)"):format(dev_digit), ""
  end

  local dev_name = dev.display_name
  if param_digit == 0 then
    local s = (amt_str=="00") and "OFF" or (amt_str=="01" and "ON" or amt_str)
    return ("%s: turn device %s (00 = off, 01 = on)."):format(dev_name, s), ("%s / On-Off"):format(dev_name), s
  end

  local p = dev.parameters[param_digit + PARAM_OFFSET]
  if not p then
    return ("%s: parameter #%d, but this device exposes only %d parameter(s)."):format(dev_name, param_digit, #dev.parameters),
      ("%s / param #%d"):format(dev_name, param_digit), ""
  end

  local scaled = can_probe and preview_scaled(p, amt_val) or nil
  if scaled then
    return ('Sets "%s" on %s to %s   (command %s).'):format(p.name, dev_name, scaled, amt_str),
      ("%s / %s:"):format(dev_name, p.name), scaled
  end
  local cur = current_value_string(p)
  local detail = ('Sets "%s" on %s (command %s)'):format(p.name, dev_name, amt_str)
  detail = detail .. (cur and (".  Currently %s; stop playback to preview the value this sets."):format(cur) or ".")
  return detail, ("%s / %s"):format(dev_name, p.name), ""
end

-- returns: detail, head_label, head_value
local function resolve(num_str, amt_str, amt_val, track, can_probe)
  local first = num_str:sub(1,1):upper()
  local second = num_str:sub(2,2):upper()
  local x = math.floor(amt_val/16)
  local y = amt_val % 16
  if first == "0" then
    local e = BUILTIN[second]
    if e then return e[2](x,y,amt_val,amt_str), e[1], "" end
    return ("Unrecognised built-in command 0%s."):format(second), "Unknown command", ""
  end
  if first == "Z" then
    local e = GLOBAL[second]
    if e then return e[2](amt_val), e[1], "" end
    return ("Unrecognised global command Z%s."):format(second), "Unknown command", ""
  end
  local dd, pd = tonumber(first,16), tonumber(second,16)
  if dd and pd then return resolve_device(dd, pd, amt_val, amt_str, track, can_probe) end
  return "Could not resolve this command.", "Unknown command", ""
end

-- ----------------------------------------------------------------------------
-- Reading the pattern
-- ----------------------------------------------------------------------------

local probe_enabled = true

local function can_probe_now(song)
  if not probe_enabled then return false end
  local playing = true
  pcall(function() playing = song.transport.playing end)
  return not playing
end

-- The cell at the END of the selection box (bottom-right-most selected,
-- non-empty cell). Note columns are scanned before effect columns on each line,
-- so an effect column wins over a note column on the same line (it sits to the
-- right). Returns:
--   false  - no selection at all
--   nil    - selection present but no non-empty note/effect cell in it
--   table  - { kind = "fx" | "note", t, l, col, track, ... }
local function selection_end_cell(song)
  local sel = song.selection_in_pattern
  if not sel then return false end
  local pattern = song.selected_pattern
  local last = nil
  for t = sel.start_track, sel.end_track do
    local track_obj = song.tracks[t]
    local ok, ptrack = pcall(function() return pattern:track(t) end)
    if ok and ptrack then
      for l = sel.start_line, sel.end_line do
        local line = ptrack:line(l)
        for ci, nc in ipairs(line.note_columns) do
          local s = false; pcall(function() s = nc.is_selected end)
          if s and not nc.is_empty then
            last = { kind = "note", t = t, l = l, col = ci, nc = nc, track = track_obj }
          end
        end
        for ci, efx in ipairs(line.effect_columns) do
          local s = false; pcall(function() s = efx.is_selected end)
          local num = efx.number_string or ""
          if s and not is_empty_cmd(efx, num) then
            last = { kind = "fx", t = t, l = l, col = ci, num = num,
                     amt = efx.amount_string or "", amt_val = efx.amount_value or 0, track = track_obj }
          end
        end
      end
    end
  end
  return last
end

-- Instrument index (0-based) of the first note column with an instrument on
-- the given pattern line, or nil. Used to resolve which instrument a Zxx
-- (trigger-phrase) command targets.
local function instrument_on_line(song, t, l)
  local idx
  pcall(function()
    local line = song.selected_pattern:track(t):line(l)
    for _, ncol in ipairs(line.note_columns) do
      if ncol.instrument_value <= 254 then idx = ncol.instrument_value; break end
    end
  end)
  return idx
end

-- Resolve a 0Zxx (trigger phrase) command -> detail, head_label, head_value.
local function resolve_zxx(song, c)
  local v = c.amt_val
  if v == 0 then
    return "Z00: stop phrase playback (no phrase).", "Trigger phrase", "(none)"
  end
  if v == 0x7F then
    return "Z7F: switch the instrument to keymap phrase mode.", "Phrases", "keymap mode"
  end
  local inst_idx = instrument_on_line(song, c.t, c.l)
  if inst_idx then
    local inst = song.instruments[inst_idx + 1]
    local nphr = inst and #inst.phrases or 0
    if inst and v <= nphr then
      local ph = inst.phrases[v]
      local nm = (ph.name ~= "" and ph.name) or ("Phrase %02d"):format(v)
      return ('Triggers phrase %d ("%s") of instrument %02X.'):format(v, nm, inst_idx),
        ("Phrase %02X:"):format(v), nm
    end
    return ('Triggers phrase #%d of instrument %02X (it has %d phrase(s)).'):format(v, inst_idx, nphr),
      "Trigger phrase", ("#%02X"):format(v)
  end
  return ('Triggers phrase #%d of the active instrument on this track.'):format(v),
    "Trigger phrase", ("#%02X"):format(v)
end

-- Full single-command readout -> headline, meta (2 grey lines), description
local function single_readout(song, c, can_probe)
  local detail, hl, hv = resolve(c.num, c.amt, c.amt_val, c.track, can_probe)
  if (c.num or ""):upper() == "0Z" then
    detail, hl, hv = resolve_zxx(song, c)
  end
  local headline = (hv ~= "" and (hl .. " " .. hv)) or hl
  local meta = ("Command: %s %s\nTrack %d,  Line %d,  FX col %d"):format(c.num, c.amt, c.t, c.l, c.col)
  return headline, meta, detail
end

-- ----------------------------------------------------------------------------
-- UI
-- ----------------------------------------------------------------------------

local vb, dialog, head_view, meta_view, desc_view
local last_sig, last_render
local status_enabled = true   -- on by default at launch
local mode = "cursor"         -- "cursor" or "selection"
local last_cursor_sig, last_sel_sig
local W = 350
local INNER = W - 24

local function render(headline, meta, desc)
  local key = (headline or "").."\0"..(meta or "").."\0"..(desc or "")
  if key == last_render then return end
  last_render = key
  if head_view then head_view.text = headline or "" end
  if meta_view then meta_view.text = meta or "" end
  if desc_view then desc_view.text = desc or "" end
end

-- Push a resolved readout to the open dialog and/or the status bar.
-- is_command is false for placeholder states; the status bar shows only real
-- command headlines so it does not clobber Renoise's own status messages.
local function push(headline, meta, desc, is_command)
  render(headline, meta, desc)
  if status_enabled and is_command then
    pcall(function() renoise.app():show_status(headline or "") end)
  end
end

-- For a multi-sample instrument, the name of the sample whose note-on keyzone
-- contains note_value, or nil. Single-sample instruments return nil (no need).
local function sample_name_for_note(inst, note_value)
  if not inst or note_value > 119 then return nil end   -- need an actual pitch
  if #inst.samples <= 1 then return nil end             -- only when multi-sample
  local found
  pcall(function()
    local maps = inst.sample_mappings[renoise.Instrument.LAYER_NOTE_ON]
    if not maps then return end
    for i = 1, #maps do
      local m = maps[i]
      local nr = m and m.note_range
      if nr and note_value >= nr[1] and note_value <= nr[2] then
        local smp = inst.samples[i]                      -- 1:1 with note-on maps
        if smp then found = (smp.name ~= "" and smp.name) or ("Sample %02d"):format(i) end
        break
      end
    end
  end)
  return found
end

-- If the instrument is a sliced instrument (slice markers on the first
-- sample), the slice the note triggers, as a display string ("Slice 03" or
-- "Slice 03: name"), or nil. Slices are samples 2..N+1; the full sample (1) is
-- skipped so it can't shadow a slice.
local function slice_for_note(inst, note_value)
  if not inst or note_value > 119 then return nil end
  local s1 = inst.samples[1]
  local markers
  pcall(function() markers = s1 and s1.slice_markers end)
  if not markers or #markers == 0 then return nil end   -- not a sliced instrument
  local found
  pcall(function()
    local maps = inst.sample_mappings[renoise.Instrument.LAYER_NOTE_ON]
    if not maps then return end
    for i = 2, #inst.samples do
      local m  = maps[i]
      local nr = m and m.note_range
      if nr and note_value >= nr[1] and note_value <= nr[2] then
        local n  = i - 1
        local nm = inst.samples[i].name or ""
        if nm ~= "" and not nm:lower():find("^slice") then
          found = ("Slice %02d: %s"):format(n, nm)
        else
          found = ("Slice %02d"):format(n)
        end
        break
      end
    end
  end)
  return found
end


local function phrase_for_note(inst, note_value)
  if not inst or note_value > 119 then return nil end
  local found
  pcall(function()
    if inst.phrase_playback_mode ~= renoise.Instrument.PHRASES_PLAY_KEYMAP then return end
    for i = 1, #inst.phrases do
      local ph = inst.phrases[i]
      local m  = ph and ph.mapping
      local nr = m and m.note_range
      if nr and note_value >= nr[1] and note_value <= nr[2] then
        found = { index = i, name = (ph.name ~= "" and ph.name) or ("Phrase %02d"):format(i) }
        break
      end
    end
  end)
  return found
end

-- Phrase playback state of the instrument: "keymap", "program", or nil (off /
-- no phrases). In program mode the phrase is chosen by the Zxx command, not the
-- note's pitch.
local function phrase_mode(inst)
  local m
  pcall(function()
    if inst and #inst.phrases > 0 then m = inst.phrase_playback_mode end
  end)
  if not m then return nil end
  if m == renoise.Instrument.PHRASES_PLAY_KEYMAP then return "keymap" end
  if m == renoise.Instrument.PHRASES_OFF then return nil end
  return "program"
end

-- Note-cell readout -> headline, meta, desc, is_command
local function note_readout(song, c)
  local nc = c.nc
  local note_str  = nc.note_string or "---"
  local has_instr = nc.instrument_value <= 254    -- 255 = empty

  local headline, desc
  if has_instr then
    local idx  = nc.instrument_value
    local inst = song.instruments[idx + 1]
    local name = inst and inst.name or ""
    if name == "" then name = inst and "(untitled)" or "(no instrument in this slot)" end

    -- Phrases (if active) intercept the note before samples: keymap mode maps
    -- the note to a phrase by pitch; program mode is Zxx-driven.
    local phrase = phrase_for_note(inst, nc.note_value)
    local pmode  = phrase_mode(inst)
    local suffix
    if phrase then
      suffix = (" -> Phrase: %s"):format(phrase.name)
    elseif pmode == "program" then
      suffix = " (phrases: program mode)"
    else
      local slice = slice_for_note(inst, nc.note_value)
      if slice then
        suffix = (" (%s)"):format(slice)
      else
        local smp = sample_name_for_note(inst, nc.note_value)
        suffix = smp and (" (%s)"):format(smp) or ""
      end
    end

    local label = ("%02X: %s"):format(idx, name) .. suffix
    headline = label
    desc = (nc.note_value <= 119) and ('Note %s plays %s.'):format(note_str, label) or (label .. ".")
  else
    headline = ("Note %s"):format(note_str)
    desc = "No instrument number set on this note."
  end

  local meta = ("Note: %s   Instr: %s\nTrack %d,  Line %d,  Note col %d"):format(
    note_str, has_instr and ("%02X"):format(nc.instrument_value) or "--", c.t, c.l, c.col)
  return headline, meta, desc, true
end

-- The cell under the EDIT CURSOR (note or effect), or nil. Empty cells are
-- included (flagged) so scrolling over blanks still updates the readout.
local function cursor_cell(song)
  local efx = song.selected_effect_column
  if efx then
    local num = efx.number_string or ""
    return { kind = "fx", t = song.selected_track_index, l = song.selected_line_index,
      col = song.selected_effect_column_index, num = num, amt = efx.amount_string or "",
      amt_val = efx.amount_value or 0, track = song.tracks[song.selected_track_index],
      empty = is_empty_cmd(efx, num) }
  end
  local nc = song.selected_note_column
  if nc then
    return { kind = "note", t = song.selected_track_index, l = song.selected_line_index,
      col = song.selected_note_column_index, nc = nc,
      track = song.tracks[song.selected_track_index], empty = nc.is_empty }
  end
  return nil
end

-- Position signatures for change detection (position only, not content).
local function cursor_pos_sig(song)
  return ("%d.%d.%d.%d"):format(song.selected_track_index, song.selected_line_index,
    song.selected_note_column_index, song.selected_effect_column_index)
end

local function selection_pos_sig(sel)
  if not sel then return "none" end
  return ("%s.%s.%s.%s.%s.%s"):format(
    tostring(sel.start_track), tostring(sel.start_line), tostring(sel.start_column),
    tostring(sel.end_track),   tostring(sel.end_line),   tostring(sel.end_column))
end

local function cell_signature(cell, can_probe)
  if cell.kind == "fx" then
    return ("fx:%s:%d.%d.%d.%s.%s:%s"):format(tostring(can_probe),
      cell.t, cell.l, cell.col, cell.num, cell.amt, tostring(cell.empty))
  end
  return ("note:%d.%d.%d.%d.%d:%s"):format(
    cell.t, cell.l, cell.col, cell.nc.note_value, cell.nc.instrument_value, tostring(cell.empty))
end

local function resolve_cell(song, cell, can_probe)
  if cell.kind == "fx" then
    if cell.empty then
      return "Empty effect cell",
        ("Track %d,  Line %d,  FX col %d"):format(cell.t, cell.l, cell.col), "", false
    end
    local h, m, d = single_readout(song, cell, can_probe)
    return h, m, d, true
  end
  if cell.empty then
    return "Empty note column",
      ("Track %d,  Line %d,  Note col %d"):format(cell.t, cell.l, cell.col), "", false
  end
  return note_readout(song, cell)
end

local function refresh()
  if not (status_enabled or (dialog and dialog.visible)) then return end
  local ok, err = pcall(function()
    local song = renoise.song()
    if not song then
      if last_sig ~= "nosong" then last_sig = "nosong"; push("No song loaded", "", "", false) end
      return
    end

    -- No readout while the song is playing.
    local playing = false
    pcall(function() playing = song.transport.playing end)
    if playing then return end

    -- Decide which source is active. Making a selection (even a 1-cell click
    -- selection) switches to "selection"; moving the cursor switches back to
    -- "cursor". A click changes both, so a selection change wins the tie.
    local cur_sig = cursor_pos_sig(song)
    local sel = song.selection_in_pattern
    local sel_sig = selection_pos_sig(sel)
    local cur_changed = (cur_sig ~= last_cursor_sig)
    local sel_changed = (sel_sig ~= last_sel_sig)
    last_cursor_sig, last_sel_sig = cur_sig, sel_sig

    if sel_changed and sel then
      mode = "selection"
    elseif cur_changed then
      mode = "cursor"
    elseif mode == "selection" and not sel then
      mode = "cursor"                 -- the selection we were showing was cleared
    end

    -- Resolve the active source into a cell.
    local cell
    if mode == "selection" and sel then
      local e = selection_end_cell(song)
      if type(e) == "table" then cell = e end
    end
    if not cell then cell = cursor_cell(song) end

    local can_probe = can_probe_now(song)
    local sig, build
    if not cell then
      sig = "none"
      build = function() return "No note or command here", "",
        "Move the cursor onto a note or effect command, or select one.", false end
    else
      sig = cell_signature(cell, can_probe)
      build = function() return resolve_cell(song, cell, can_probe) end
    end

    if sig == last_sig then return end
    last_sig = sig
    push(build())
  end)
  if not ok then last_sig = nil; push("MG Note & FX Inspector error", "", tostring(err), false) end
end

local function build_content()
  vb = renoise.ViewBuilder()
  head_view = vb:multiline_text { width = INNER, height = 24, font = "bold",   style = "strong", text = "" }
  meta_view = vb:multiline_text { width = INNER, height = 34, font = "normal", style = "body",   text = "" }
  desc_view = vb:multiline_text { width = INNER, height = 70, font = "normal", style = "strong", text = "" }

  return vb:column {
    margin = 12,
    spacing = 8,
    width = W,
    head_view,
    meta_view,
    desc_view,
    vb:space { height = 6 },
    vb:row {
      spacing = 6,
      vb:checkbox { value = probe_enabled, notifier = function(v)
        probe_enabled = v; last_sig = nil; last_render = nil
      end },
      vb:multiline_text {
        width = INNER - 24, height = 34, style = "body",
        text = "Preview real scaled value for device commands (only while stopped)",
      },
    },
  }
end

local function toggle()
  if dialog and dialog.visible then dialog:close(); dialog = nil; return end
  last_sig, last_render = nil, nil
  dialog = renoise.app():show_custom_dialog("MG Note & FX Inspector", build_content())
  refresh()
end

local function toggle_status()
  status_enabled = not status_enabled
  last_sig = nil
  renoise.app():show_status(status_enabled
    and "MG Note & FX Inspector: status-bar readout ON" or "MG Note & FX Inspector: status-bar readout OFF")
  if status_enabled then refresh() end
end

if not renoise.tool().app_idle_observable:has_notifier(refresh) then
  renoise.tool().app_idle_observable:add_notifier(refresh)
end

renoise.tool():add_menu_entry { name = "Main Menu:Tools:MG Note & FX Inspector...", invoke = toggle }
renoise.tool():add_menu_entry { name = "Pattern Editor:MG Note & FX Inspector...", invoke = toggle }
renoise.tool():add_keybinding { name = "Pattern Editor:Tools:Toggle MG Note & FX Inspector", invoke = toggle }

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:MG Note & FX Inspector Status Readout",
  invoke = toggle_status,
  selected = function() return status_enabled end,
}
renoise.tool():add_menu_entry {
  name = "Pattern Editor:MG Note & FX Inspector Status Readout",
  invoke = toggle_status,
  selected = function() return status_enabled end,
}
renoise.tool():add_keybinding {
  name = "Pattern Editor:Tools:Toggle MG Note & FX Inspector Status Readout",
  invoke = toggle_status,
}

-- show immediately on load (no-op until a song exists)
pcall(refresh)
