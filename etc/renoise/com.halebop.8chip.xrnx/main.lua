-- main.lua
-- Entry point for 8chip Chiptune Toolbox.
-- Loads preferences and UI, then registers the menu entry and keybinding.

require("preferences")
require("ui.dialog")

renoise.tool():add_menu_entry {
  name   = "Main Menu:Tools:8chip...",
  invoke = show_8chip_dialog,
}

renoise.tool():add_keybinding {
  name   = "Global:Tools:8chip",
  invoke = show_8chip_dialog,
}
