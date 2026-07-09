-- ui/probability_panel.lua
-- Module 7: Probability & Variation
-- Three pattern-editing tools operating on the selected region.

local prob = require("generators.probability_generator")

local W = 480

local TOOLS = { "Probability Scatter", "Humanize", "Fill (Every Nth)" }

function create_probability_panel(vb)

  local state = {
    tool        = 1,
    density     = 0.5,     -- scatter/humanize density 0–1
    prob_val    = 128,     -- 0Y amount (0-255); 128 = 50%
    max_delay   = 4,       -- humanize max delay ticks
    nth         = 4,       -- fill: every Nth note
    fill_chance = 128,     -- fill: 0Y amount
  }

  local function refresh_rows()
    local t = state.tool
    vb.views["prob_scatter_rows"].visible  = (t == 1)
    vb.views["prob_human_rows"].visible    = (t == 2)
    vb.views["prob_fill_rows"].visible     = (t == 3)
  end

  local function do_apply()
    local t = state.tool
    if t == 1 then
      prob.scatter_probability(state.density, state.prob_val)
      renoise.app():show_status("8chip: Probability scatter applied.")
    elseif t == 2 then
      prob.humanize(state.max_delay, state.density)
      renoise.app():show_status("8chip: Humanize applied.")
    elseif t == 3 then
      prob.fill_nth(state.nth, state.fill_chance)
      renoise.app():show_status(
        string.format("8chip: Every %d notes marked with 0Y %02X.",
                      state.nth, state.fill_chance))
    end
  end

  local panel = vb:column {
    id      = "panel_probability",
    visible = false,
    width   = W,
    spacing = 6,
    margin  = 8,

    vb:text { text = "Probability & Variation", font = "bold", style = "strong" },
    vb:text {
      text  = "Applies 0Y (probability) and 0Q (delay) effects to notes in the\n"
           .. "currently selected pattern region. Select notes in the pattern first.",
      style = "disabled",
    },

    vb:space { height = 4 },

    -- Tool selector
    vb:row {
      spacing = 8,
      vb:text    { text = "Tool", width = 90 },
      vb:chooser {
        id    = "prob_tool",
        items = TOOLS,
        value = state.tool,
        notifier = function(idx)
          state.tool = idx
          refresh_rows()
        end,
      },
    },

    vb:space { height = 4 },

    -- -----------------------------------------------------------------------
    -- Probability Scatter controls
    -- -----------------------------------------------------------------------
    vb:column {
      id      = "prob_scatter_rows",
      visible = true,
      spacing = 4,

      vb:text {
        text  = "Scatters 0Y (probability gate) across notes. High density = most notes affected.",
        style = "disabled",
      },

      vb:row {
        spacing = 8,
        vb:text { text = "Density", width = 90 },
        vb:minislider {
          id    = "prob_density_slider",
          width = 180,
          min   = 0,
          max   = 100,
          value = math.floor(state.density * 100),
          notifier = function(v)
            state.density = v / 100.0
            vb.views["prob_density_label"].text = tostring(math.floor(v)) .. "%"
          end,
        },
        vb:text { id = "prob_density_label",
                  text = tostring(math.floor(state.density * 100)) .. "%" },
      },

      vb:row {
        spacing = 8,
        vb:text { text = "Prob chance", width = 90 },
        vb:minislider {
          id    = "prob_val_slider",
          width = 180,
          min   = 0,
          max   = 255,
          value = state.prob_val,
          notifier = function(v)
            state.prob_val = math.floor(v)
            local pct = math.floor(math.floor(v) / 255 * 100)
            vb.views["prob_val_label"].text =
              string.format("0Y %02X  (%d%%)", state.prob_val, pct)
          end,
        },
        vb:text {
          id   = "prob_val_label",
          text = string.format("0Y %02X  (%d%%)", state.prob_val,
                               math.floor(state.prob_val / 255 * 100)),
        },
      },
    },

    -- -----------------------------------------------------------------------
    -- Humanize controls
    -- -----------------------------------------------------------------------
    vb:column {
      id      = "prob_human_rows",
      visible = false,
      spacing = 4,

      vb:text {
        text  = "Scatters small 0Q note-delay values across notes for a loose, human feel.",
        style = "disabled",
      },

      vb:row {
        spacing = 8,
        vb:text { text = "Density", width = 90 },
        vb:minislider {
          id    = "prob_human_density",
          width = 180,
          min   = 0,
          max   = 100,
          value = math.floor(state.density * 100),
          notifier = function(v)
            state.density = v / 100.0
            vb.views["prob_human_density_label"].text = tostring(math.floor(v)) .. "%"
          end,
        },
        vb:text { id = "prob_human_density_label",
                  text = tostring(math.floor(state.density * 100)) .. "%" },
      },

      vb:row {
        spacing = 8,
        vb:text     { text = "Max Delay", width = 90 },
        vb:valuebox {
          id    = "prob_delay_box",
          min   = 1,
          max   = 15,
          value = state.max_delay,
          notifier = function(v) state.max_delay = v end,
        },
        vb:text { text = "ticks (0Q)", style = "disabled" },
      },
    },

    -- -----------------------------------------------------------------------
    -- Fill (Every Nth) controls
    -- -----------------------------------------------------------------------
    vb:column {
      id      = "prob_fill_rows",
      visible = false,
      spacing = 4,

      vb:text {
        text  = "Marks every Nth note with 0Y (probability gate). Good for adding organic\n"
             .. "variation to repeated patterns without changing the melody.",
        style = "disabled",
      },

      vb:row {
        spacing = 8,
        vb:text     { text = "Every Nth", width = 90 },
        vb:valuebox {
          id    = "prob_nth_box",
          min   = 1,
          max   = 32,
          value = state.nth,
          notifier = function(v) state.nth = v end,
        },
        vb:text { text = "notes get 0Y", style = "disabled" },
      },

      vb:row {
        spacing = 8,
        vb:text { text = "Chance (0Y)", width = 90 },
        vb:minislider {
          id    = "prob_fill_chance",
          width = 180,
          min   = 0,
          max   = 255,
          value = state.fill_chance,
          notifier = function(v)
            state.fill_chance = math.floor(v)
            local pct = math.floor(math.floor(v) / 255 * 100)
            vb.views["prob_fill_chance_label"].text =
              string.format("0Y %02X  (%d%%)", state.fill_chance, pct)
          end,
        },
        vb:text {
          id   = "prob_fill_chance_label",
          text = string.format("0Y %02X  (%d%%)", state.fill_chance,
                               math.floor(state.fill_chance / 255 * 100)),
        },
      },
    },

    vb:space { height = 6 },

    vb:row {
      spacing = 8,
      vb:button {
        text     = "Apply to Selected Region",
        width    = 200,
        notifier = do_apply,
      },
    },

    vb:text {
      text  = "Tip: Ctrl+Z to undo if the result isn't what you wanted.",
      style = "disabled",
    },
  }

  return panel
end
