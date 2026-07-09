-- ui/canvas_wave.lua
-- Shared waveform preview canvas widget used by three tabs:
--   Waveform Studio, Presets, Single Cycle (AKWF browser)
--
-- Public API:
--   local CW   = require "ui.canvas_wave"
--   local view = CW.create(vb, width, height)  -- create the canvas view
--   CW.set_data(view, samples)                  -- float array [-1.0, 1.0], triggers repaint
--   CW.clear(view)                              -- blank / no-signal state, triggers repaint

local M = {}

-- Per-canvas data store keyed by the view object itself.
-- Lua tables are reference types, so the view is a stable key.
local _data = setmetatable({}, { __mode = "k" })  -- weak keys: GC-friendly

-- ---------------------------------------------------------------------------
-- Visual constants
-- ---------------------------------------------------------------------------

local COL_BG         = { 0,   0,   0   }   -- solid black background
local COL_CENTRE     = { 20,  60,  10  }   -- faint dark green centre line
local COL_WAVE       = { 57,  255, 20  }   -- neon green waveform
local LINE_W_CENTRE  = 1.0
local LINE_W_WAVE    = 1.5

-- ---------------------------------------------------------------------------
-- Internal render callback factory
-- Returns a closure bound to this specific view object so each canvas draws
-- its own data independently.
-- ---------------------------------------------------------------------------

local function make_render(view)
  return function(ctx)
    local w   = ctx.size.width
    local h   = ctx.size.height
    local mid = h * 0.5

    -- Background
    ctx.fill_color = COL_BG
    ctx:fill_rect(0, 0, w, h)

    -- Centre reference line
    ctx.stroke_color = COL_CENTRE
    ctx.line_width   = LINE_W_CENTRE
    ctx:begin_path()
    ctx:move_to(0,   mid)
    ctx:line_to(w,   mid)
    ctx:stroke()

    -- Waveform
    local samples = _data[view]
    if not samples or #samples < 2 then return end

    local n = #samples
    ctx.stroke_color = COL_WAVE
    ctx.line_width   = LINE_W_WAVE
    ctx:begin_path()
    for i = 1, n do
      local x = (i - 1) / (n - 1) * w
      local y = mid - samples[i] * (mid - 2)
      if i == 1 then
        ctx:move_to(x, y)
      else
        ctx:line_to(x, y)
      end
    end
    ctx:stroke()
  end
end

-- ---------------------------------------------------------------------------
-- Public: CW.create(vb, width, height)
-- Creates and returns a vb:canvas view sized to (width × height).
-- ---------------------------------------------------------------------------

function M.create(vb, width, height)
  width  = width  or 480
  height = height or 80

  -- We need the view reference before we can close over it in render, so we
  -- create a placeholder table and patch it in after construction.
  local view_ref = {}   -- will be replaced with the real view below

  local view = vb:canvas {
    width  = width,
    height = height,
    mode   = "plain",
    render = function(ctx)
      -- Delegate to the closure stored on the real view.
      -- view_ref[1] is set immediately after vb:canvas returns.
      local real_view = view_ref[1]
      if real_view then
        make_render(real_view)(ctx)
      end
    end,
  }

  -- Now that we have the real view object, store it so the render closure
  -- can find it, and initialise with no data.
  view_ref[1] = view
  _data[view]  = nil

  return view
end

-- ---------------------------------------------------------------------------
-- Public: CW.set_data(view, samples)
-- Feed a new float array to the canvas and trigger a repaint.
-- samples : table of numbers in [-1.0, 1.0], any length ≥ 2
-- ---------------------------------------------------------------------------

function M.set_data(view, samples)
  if not view then return end
  _data[view] = samples
  view:update()
end

-- ---------------------------------------------------------------------------
-- Public: CW.clear(view)
-- Remove waveform data and repaint as blank (background + centre line only).
-- ---------------------------------------------------------------------------

function M.clear(view)
  if not view then return end
  _data[view] = nil
  view:update()
end

return M
