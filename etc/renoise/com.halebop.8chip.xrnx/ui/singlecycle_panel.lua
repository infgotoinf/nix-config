-- ui/singlecycle_panel.lua
-- Module 8: Single Cycle Waveform Browser
-- Browse any WAV library (e.g. AKWF-FREE), preview waveforms, and insert
-- them as looped samples or spread across keyzones as a wavetable.

local CW = require("ui.canvas_wave")

-- ---------------------------------------------------------------------------
-- WAV-to-float parser  (reads PCM data directly — no instrument slot needed)
-- Supports 8-bit and 16-bit mono/stereo PCM.  Results are cached by path.
-- ---------------------------------------------------------------------------

local wav_cache = {}

local function parse_wav_floats(path)
  if wav_cache[path] then return wav_cache[path] end

  local f = io.open(path, "rb")
  if not f then return nil end

  local function u16(s, off)
    return string.byte(s, off) + string.byte(s, off + 1) * 256
  end
  local function u32(s, off)
    return string.byte(s, off)           +
           string.byte(s, off + 1) * 256 +
           string.byte(s, off + 2) * 65536 +
           string.byte(s, off + 3) * 16777216
  end

  -- RIFF/WAVE header
  if f:read(4) ~= "RIFF" then f:close() return nil end
  f:read(4)                             -- file size (ignored)
  if f:read(4) ~= "WAVE" then f:close() return nil end

  local n_ch, bps = 1, 16
  local floats = nil

  while true do
    local id     = f:read(4)
    local sz_raw = f:read(4)
    if not id or not sz_raw or #id < 4 then break end
    local sz = u32(sz_raw, 1)

    if id == "fmt " then
      local fmt = f:read(sz)
      n_ch = u16(fmt, 3)
      bps  = u16(fmt, 15)

    elseif id == "data" then
      floats = {}
      local bps_bytes   = math.floor(bps / 8)
      local frame_bytes = bps_bytes * n_ch
      local n_frames    = math.floor(sz / frame_bytes)

      for _ = 1, n_frames do
        local raw = f:read(bps_bytes)
        if not raw or #raw < bps_bytes then break end

        local v
        if bps == 16 then
          local u = string.byte(raw, 1) + string.byte(raw, 2) * 256
          if u >= 32768 then u = u - 65536 end
          v = u / 32767.0
        elseif bps == 8 then
          v = (string.byte(raw, 1) - 128) / 127.0
        else
          v = 0.0
        end
        floats[#floats + 1] = v

        -- Skip extra channels (only channel 1 used for canvas)
        if n_ch > 1 then f:read((n_ch - 1) * bps_bytes) end
      end
      break

    else
      -- Unknown chunk — skip
      f:read(sz)
    end
  end

  f:close()

  if floats and #floats > 0 then
    wav_cache[path] = floats
    return floats
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- Directory helpers
-- ---------------------------------------------------------------------------

local function scan_banks(lib_path)
  if not lib_path or lib_path == "" then return {} end
  local banks = {}
  local f = io.popen('ls -1d "' .. lib_path .. '"/*/ 2>/dev/null')
  if f then
    for line in f:lines() do
      local name = line:match("([^/]+)/?$")
      if name and name ~= "" then
        banks[#banks + 1] = name
      end
    end
    f:close()
  end
  return banks
end

local function scan_wavs(bank_path)
  if not bank_path or bank_path == "" then return {} end
  local files = {}
  local f = io.popen('ls -1 "' .. bank_path .. '" 2>/dev/null | grep -i "\\.wav$"')
  if f then
    for line in f:lines() do
      if line ~= "" then files[#files + 1] = line end
    end
    f:close()
  end
  return files
end

-- ---------------------------------------------------------------------------
-- Sample insert helpers
-- ---------------------------------------------------------------------------

local function insert_sample_from_wav(instrument, wav_path, sample_name)
  local new_idx = #instrument.samples + 1
  instrument:insert_sample_at(new_idx)
  local sample = instrument.samples[new_idx]
  sample.name  = sample_name or
                 (wav_path:match("([^/]+)$") or ""):gsub("%.[Ww][Aa][Vv]$", "")
  local buf = sample.sample_buffer
  local ok  = buf:load_from(wav_path)
  if ok then
    sample.loop_mode  = renoise.Sample.LOOP_MODE_FORWARD
    sample.loop_start = 1
    sample.loop_end   = buf.number_of_frames
  end
  return ok
end

-- Redistribute keyzones for ALL samples in an instrument evenly over C0..B9
local function apply_spread_keyzones(instrument)
  local n = #instrument.samples
  if n == 0 then return end
  local total = 120  -- notes 0..119
  for i = 1, n do
    local lo = math.floor((i - 1) * total / n)
    local hi = math.floor(i * total / n) - 1
    if i == n then hi = total - 1 end
    instrument.samples[i].sample_mapping.note_range = { lo, hi }
  end
end

-- ---------------------------------------------------------------------------
-- Public: create_singlecycle_panel(vb)
-- ---------------------------------------------------------------------------
function create_singlecycle_panel(vb)
  local W  = 480
  local IW = W - 16  -- inner usable width (margin=8 on each side)

  local prefs    = renoise.tool().preferences
  -- Effective library path: use prefs value, or fall back to the bundled waveform selection
  local lib_path
  if prefs.scw_library_path.value ~= "" then
    lib_path = prefs.scw_library_path.value
  else
    lib_path = renoise.tool().bundle_path:gsub("[\\/]$", "") .. "/data/bundled_waves"
  end

  -- State
  local banks        = scan_banks(lib_path)
  local cur_bank_idx = 1
  local cur_wave_idx = 1
  local wav_names    = {}   -- display names (no extension)
  local wav_fullpath = {}   -- absolute paths

  -- Canvas view — created before panel so closure captures it
  local canvas_view = CW.create(vb, W, 80)

  local function refresh_canvas()
    local path = wav_fullpath[cur_wave_idx]
    if not path then
      CW.clear(canvas_view)
      return
    end
    local floats = parse_wav_floats(path)
    if floats then
      CW.set_data(canvas_view, floats)
    else
      CW.clear(canvas_view)
    end
  end

  local function load_bank(idx)
    if not banks[idx] then
      wav_names    = {}
      wav_fullpath = {}
      return
    end
    local bank_path = lib_path .. "/" .. banks[idx]
    local files     = scan_wavs(bank_path)
    wav_names    = {}
    wav_fullpath = {}
    for _, fname in ipairs(files) do
      wav_names[#wav_names + 1]    = fname:gsub("%.[Ww][Aa][Vv]$", "")
      wav_fullpath[#wav_fullpath + 1] = bank_path .. "/" .. fname
    end
    prefs.scw_last_bank.value = banks[idx]
  end

  -- Restore last bank
  if #banks > 0 then
    local last = prefs.scw_last_bank.value
    for i, name in ipairs(banks) do
      if name == last then cur_bank_idx = i ; break end
    end
    load_bank(cur_bank_idx)
  end

  local bank_items = #banks > 0 and banks or { "(no banks)" }
  local wave_items = #wav_names > 0 and wav_names or { "(no waveforms)" }

  local lib_display = prefs.scw_library_path.value ~= "" and
    (prefs.scw_library_path.value:match("([^/]+)$") or prefs.scw_library_path.value) or
    "Built-in  (84 curated AKWF waveforms)"

  local wave_info_text = #wav_names > 0 and (#wav_names .. " waveforms") or ""

  -- -------------------------------------------------------------------------
  -- Notifiers / actions
  -- -------------------------------------------------------------------------

  local function do_browse()
    local path = renoise.app():prompt_for_path("Select waveform library folder:")
    if not path or path == "" then return end
    path      = path:gsub("/*$", "")
    lib_path  = path
    prefs.scw_library_path.value = path

    banks        = scan_banks(lib_path)
    cur_bank_idx = 1
    cur_wave_idx = 1
    bank_items   = #banks > 0 and banks or { "(no banks found)" }

    vb.views["scw_lib_text"].text         = path:match("([^/]+)$") or path
    vb.views["scw_bank_popup"].items      = bank_items
    vb.views["scw_bank_popup"].value      = 1

    if #banks > 0 then
      load_bank(1)
      wave_items = #wav_names > 0 and wav_names or { "(no waveforms)" }
    else
      wav_names    = {}
      wav_fullpath = {}
      wave_items   = { "(no banks found)" }
    end

    vb.views["scw_wave_list"].items = wave_items
    if #wave_items > 0 then
      vb.views["scw_wave_list"].value = 1
    end
    cur_wave_idx = 1
    vb.views["scw_wave_name"].text  = wav_names[1] or ""
    refresh_canvas()
  end

  local function do_use_internal()
    prefs.scw_library_path.value = ""
    lib_path = renoise.tool().bundle_path:gsub("[\\/]$", "") .. "/data/bundled_waves"
    banks        = scan_banks(lib_path)
    cur_bank_idx = 1
    cur_wave_idx = 1
    bank_items   = #banks > 0 and banks or { "(no banks)" }
    vb.views["scw_lib_text"].text        = "Built-in  (84 curated AKWF waveforms)"
    vb.views["scw_bank_popup"].items     = bank_items
    vb.views["scw_bank_popup"].value     = 1
    load_bank(1)
    wave_items = #wav_names > 0 and wav_names or { "(no waveforms)" }
    vb.views["scw_wave_list"].items = wave_items
    if #wave_items > 0 then vb.views["scw_wave_list"].value = 1 end
    cur_wave_idx = 1
    vb.views["scw_wave_name"].text = wav_names[1] or ""
    refresh_canvas()
  end

  local function on_bank_change(idx)
    cur_bank_idx = idx
    cur_wave_idx = 1
    load_bank(idx)
    wave_items = #wav_names > 0 and wav_names or { "(no waveforms)" }
    vb.views["scw_wave_list"].items = wave_items
    if #wave_items > 0 then
      vb.views["scw_wave_list"].value = 1
    end
    vb.views["scw_wave_name"].text = wav_names[1] or ""
    refresh_canvas()
  end

  local function on_wave_select(idx)
    cur_wave_idx = idx
    vb.views["scw_wave_name"].text = wav_names[idx] or ""
    refresh_canvas()
  end

  -- -------------------------------------------------------------------------
  -- Wavetable queue (max 4 slots)
  -- -------------------------------------------------------------------------
  local MAX_QUEUE = 4
  local queue_paths = {}   -- absolute paths
  local queue_names = {}   -- display names

  local function refresh_queue_ui()
    for i = 1, MAX_QUEUE do
      local id  = "scw_qslot_" .. i
      local v   = vb.views[id]
      if v then
        if queue_names[i] then
          v.text  = i .. ".  " .. queue_names[i]
          v.style = "normal"
        else
          v.text  = i .. ".  —"
          v.style = "disabled"
        end
      end
    end
    local has_items = #queue_names > 0
    vb.views["scw_q_remove"].active  = has_items
    vb.views["scw_q_clear"].active   = has_items
    vb.views["scw_q_insert"].active  = has_items
    vb.views["scw_q_single"].active  = wav_fullpath[cur_wave_idx] ~= nil
  end

  local function do_add_to_queue()
    if #queue_names >= MAX_QUEUE then
      renoise.app():show_status("8chip: Queue full (max " .. MAX_QUEUE .. " waveforms)")
      return
    end
    local path = wav_fullpath[cur_wave_idx]
    local name = wav_names[cur_wave_idx]
    if not path then return end
    queue_paths[#queue_paths + 1] = path
    queue_names[#queue_names + 1] = name
    refresh_queue_ui()
  end

  local function do_remove_last()
    if #queue_names == 0 then return end
    table.remove(queue_paths)
    table.remove(queue_names)
    refresh_queue_ui()
  end

  local function do_clear_queue()
    queue_paths = {}
    queue_names = {}
    refresh_queue_ui()
  end

  local function do_insert_single()
    local path = wav_fullpath[cur_wave_idx]
    if not path then return end
    local song  = renoise.song()
    local instr = song.selected_instrument
    if not instr then renoise.app():show_error("8chip: Select an instrument first.") ; return end
    local name = wav_names[cur_wave_idx] or ""
    local ok   = insert_sample_from_wav(instr, path, name)
    if ok then
      renoise.app():show_status("8chip: Inserted \"" .. name .. "\"")
    else
      renoise.app():show_error("8chip: Could not load \"" .. path .. "\"")
    end
  end

  local function do_insert_wavetable()
    if #queue_names == 0 then return end
    local song  = renoise.song()
    local instr = song.selected_instrument
    if not instr then renoise.app():show_error("8chip: Select an instrument first.") ; return end
    local loaded = 0
    for i, path in ipairs(queue_paths) do
      if insert_sample_from_wav(instr, path, queue_names[i]) then
        loaded = loaded + 1
      end
    end
    if loaded > 1 then apply_spread_keyzones(instr) end
    if loaded > 0 then
      renoise.app():show_status(
        "8chip: Inserted " .. loaded .. " waveform" .. (loaded > 1 and "s as wavetable" or ""))
      do_clear_queue()
    end
  end

  -- -------------------------------------------------------------------------
  -- Build panel
  -- -------------------------------------------------------------------------
  local panel = vb:column {
    id      = "panel_singlecycle",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text {
      text  = "Single Cycle Browser",
      font  = "bold",
      style = "strong",
    },
    vb:text {
      text  = "Browse the internal waveforms from Adventure Kid or add your own folder",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Library path
    vb:row {
      spacing = 6,
      vb:text { text = "Library:", width = 70 },
      vb:text {
        id    = "scw_lib_text",
        text  = lib_display,
        width = 220,
      },
      vb:button {
        text     = "Use Internal",
        width    = 95,
        notifier = do_use_internal,
      },
      vb:button {
        text     = "Browse",
        width    = 75,
        notifier = do_browse,
      },
    },

    -- Bank selector
    vb:row {
      spacing = 6,
      vb:text { text = "Bank:", width = 70 },
      vb:popup {
        id       = "scw_bank_popup",
        items    = bank_items,
        value    = cur_bank_idx,
        width    = 240,
        notifier = on_bank_change,
      },
    },

    vb:space { height = 2 },

    -- Waveform selector
    vb:row {
      spacing = 6,
      vb:text { text = "Waveform:", width = 70 },
      vb:popup {
        id       = "scw_wave_list",
        items    = wave_items,
        value    = #wave_items > 0 and 1 or 0,
        width    = 240,
        notifier = on_wave_select,
      },
    },

    -- Canvas preview (full width)
    vb:space { height = 8 },
    canvas_view,
    vb:text {
      id    = "scw_wave_name",
      text  = wav_names[1] or "",
      style = "disabled",
      width = W,
    },

    vb:space { height = 4 },

    -- Add to queue / single insert buttons
    vb:row {
      spacing = 6,
      vb:button {
        id       = "scw_q_single",
        text     = "Insert Single",
        width    = math.floor(W / 2) - 3,
        active   = wav_fullpath[cur_wave_idx] ~= nil,
        notifier = do_insert_single,
      },
      vb:button {
        text     = "+ Add to Wavetable",
        width    = math.floor(W / 2) - 3,
        notifier = do_add_to_queue,
      },
    },

    vb:space { height = 4 },

    -- Queue section header
    vb:row {
      spacing = 8,
      vb:text {
        text  = "WAVETABLE QUEUE",
        font  = "bold",
        style = "strong",
      },
      vb:text {
        text  = "— add to keyzone",
        style = "disabled",
      },
    },

    -- Queue slots (4 fixed rows)
    vb:text { id = "scw_qslot_1", text = "1.  —", style = "disabled", width = W },
    vb:text { id = "scw_qslot_2", text = "2.  —", style = "disabled", width = W },
    vb:text { id = "scw_qslot_3", text = "3.  —", style = "disabled", width = W },
    vb:text { id = "scw_qslot_4", text = "4.  —", style = "disabled", width = W },

    vb:space { height = 4 },

    -- Remove / Clear
    vb:row {
      spacing = 6,
      vb:button {
        id       = "scw_q_remove",
        text     = "Remove Last",
        width    = math.floor(W / 2) - 3,
        active   = false,
        notifier = do_remove_last,
      },
      vb:button {
        id       = "scw_q_clear",
        text     = "Clear All",
        width    = math.floor(W / 2) - 3,
        active   = false,
        notifier = do_clear_queue,
      },
    },

    vb:space { height = 2 },

    -- Insert wavetable
    vb:button {
      id       = "scw_q_insert",
      text     = "Insert as Wavetable  →",
      width    = W,
      active   = false,
      notifier = do_insert_wavetable,
    },
  }

  -- Initial canvas draw
  refresh_canvas()

  return panel
end
