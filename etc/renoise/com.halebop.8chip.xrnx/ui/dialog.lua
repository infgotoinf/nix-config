-- ui/dialog.lua
-- Main dialog: tabbed container for all 8chip panels.
-- Exposes the global function show_8chip_dialog().

require("ui.waveform_panel")
require("ui.presets_panel")
require("ui.arp_panel")
require("ui.pitch_panel")
require("ui.percussion_panel")
require("ui.modulation_panel")
require("ui.probability_panel")
require("ui.singlecycle_panel")

local dialog = nil  -- holds the open dialog reference

-- Tab labels (index matches panel creation order below)
local TAB_LABELS = {
  "Waveforms",
  "Presets",
  "Arp",
  "Pitch",
  "Drums",
  "Mod",
  "Probability",
  "Single Cycle",
}

function show_8chip_dialog()
  -- If already open, bring to front
  if dialog and dialog.visible then
    dialog:show()
    return
  end

  local vb = renoise.ViewBuilder()

  -- Build each panel (all created, only one visible at a time)
  local waveform_panel    = create_waveform_panel(vb)
  local presets_panel     = create_presets_panel(vb)
  local arp_panel         = create_arp_panel(vb)
  local pitch_panel       = create_pitch_panel(vb)
  local percussion_panel  = create_percussion_panel(vb)
  local modulation_panel  = create_modulation_panel(vb)
  local probability_panel = create_probability_panel(vb)
  local singlecycle_panel = create_singlecycle_panel(vb)

  local panels = {
    waveform_panel,
    presets_panel,
    singlecycle_panel,
    probability_panel,
    arp_panel,
    pitch_panel,
    percussion_panel,
    modulation_panel,
  }

  -- Show the panel at index idx, hide the rest; update button colours
  local ORANGE = {192, 64, 0}
  local GREY   = {0,   0,  0}
  local BTN_W  = 120   -- 480 / 4

  local function select_tab(idx)
    for i, panel in ipairs(panels) do
      panel.visible = (i == idx)
    end
    for i = 1, 8 do
      vb.views["tab_btn_" .. i].color = (i == idx) and ORANGE or GREY
    end
  end

  local TAB_NAMES = {
    "Waveforms", "Presets", "Single Cycles", "Probability",
    "Arp", "Pitch", "Drums", "Modulation",
  }

  local function make_btn(i)
    return vb:button {
      id       = "tab_btn_" .. i,
      text     = TAB_NAMES[i],
      width    = BTN_W,
      color    = i == 1 and ORANGE or GREY,
      notifier = function() select_tab(i) end,
    }
  end

  local tab_row1 = vb:row {
    spacing = 0,
    make_btn(1), make_btn(2), make_btn(3), make_btn(4),
  }
  local tab_row2 = vb:row {
    spacing = 0,
    make_btn(5), make_btn(6), make_btn(7), make_btn(8),
  }

  local content = vb:column {
    margin  = 6,
    spacing = 4,
    tab_row1,
    tab_row2,
    vb:space { height = 2 },
    waveform_panel,
    presets_panel,
    singlecycle_panel,
    probability_panel,
    arp_panel,
    pitch_panel,
    percussion_panel,
    modulation_panel,
  }

  dialog = renoise.app():show_custom_dialog("8chip", content)
end
