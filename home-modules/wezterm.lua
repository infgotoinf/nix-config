local modifier = "ALT";
local act = wezterm.action
local disable = act.DisableDefaultAssignment

return {
  -- font = wezterm.font_from_file("/home/inf/nix-config/etc/fonts/UnifontEX/UnifontExMono.ttf"),
  -- font = wezterm.font("UnifontExMono"); -- cp etc/fonts/UnifontEX/UnifontExMono.ttf ~/.local/share/fonts
  -- font_size = 12.0,

    -- font = wezterm.font_with_fallback {
    --     "ProggyClean Nerd Font Mono",
    --     "Twitter Color Emoji",
    -- },

  cell_width = 0.5,
  use_fancy_tab_bar = false,
  scrollback_lines = 10000,

  default_cursor_style = 'BlinkingBlock',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  cursor_blink_rate = 250,

  -- https://github.com/wezterm/wezterm/discussions/2329
  keys = {
		{key="-", mods=modifier, action=act.SplitVertical{domain="CurrentPaneDomain"}},
		{key="=", mods=modifier, action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
		{key="f", mods=modifier, action="TogglePaneZoomState" },

		{key="h", mods=modifier, action=act.ActivatePaneDirection("Left")},
		{key="j", mods=modifier, action=act.ActivatePaneDirection("Down")},
		{key="k", mods=modifier, action=act.ActivatePaneDirection("Up")},
		{key="l", mods=modifier, action=act.ActivatePaneDirection("Right")},

		{key="h", mods="CTRL|" .. modifier, action=act{AdjustPaneSize={"Left", 1}}},
		{key="j", mods="CTRL|" .. modifier, action=act{AdjustPaneSize={"Down", 1}}},
		{key="k", mods="CTRL|" .. modifier, action=act{AdjustPaneSize={"Up", 1}}},
		{key="l", mods="CTRL|" .. modifier, action=act{AdjustPaneSize={"Right", 1}}},

		{key="H", mods="CTRL|" .. modifier, action=act.MoveTabRelative(-1)},
		{key="L", mods="CTRL|" .. modifier, action=act.MoveTabRelative(1)},
		{key="H", mods=modifier, action=act.ActivateTabRelative(-1)},
		{key="L", mods=modifier, action=act.ActivateTabRelative(1)},

		{key="c", mods=modifier, action=act{SpawnTab="CurrentPaneDomain"}},
		{key="Enter", mods=modifier, action=act{SpawnTab="CurrentPaneDomain"}},
		{key=".", mods=modifier, action=act.ActivateLastTab},

		{key="1", mods=modifier, action=act{ActivateTab=1}},
		{key="2", mods=modifier, action=act{ActivateTab=2}},
		{key="3", mods=modifier, action=act{ActivateTab=3}},
		{key="4", mods=modifier, action=act{ActivateTab=4}},
		{key="5", mods=modifier, action=act{ActivateTab=5}},
		{key="6", mods=modifier, action=act{ActivateTab=6}},
		{key="7", mods=modifier, action=act{ActivateTab=7}},
		{key="8", mods=modifier, action=act{ActivateTab=8}},
		{key="9", mods=modifier, action=act{ActivateTab=9}},


		{key="x", mods=modifier, action=act.ActivateCopyMode},
    {key="v", mods=modifier, action=act.PasteFrom("PrimarySelection")},


    {key="=", mods="WIN",  action=disable},
    {key="+", mods="CTRL", action=disable},
    {key="-", mods="CTRL", action=disable},
    {key="=", mods="CTRL", action=disable},
    {key="_", mods="CTRL", action=disable},
  },

  key_tables = {
    copy_mode = {
      {key="c", mods="CTRL", action=act.CopyMode("Close")},
      {key="[", mods="CTRL", action=act.CopyMode("Close")},
      {key="q", mods="NONE", action=act.CopyMode("Close")},
      {key="Escape", mods="NONE", action=act.CopyMode("Close")},

      {key="h", mods="NONE", action=act.CopyMode("MoveLeft")},
      {key="j", mods="NONE", action=act.CopyMode("MoveDown")},
      {key="k", mods="NONE", action=act.CopyMode("MoveUp")},
      {key="l", mods="NONE", action=act.CopyMode("MoveRight")},

      {key="LeftArrow",  mods="NONE", action=act.CopyMode("MoveLeft")},
      {key="DownArrow",  mods="NONE", action=act.CopyMode("MoveDown")},
      {key="UpArrow",    mods="NONE", action=act.CopyMode("MoveUp")},
      {key="RightArrow", mods="NONE", action=act.CopyMode("MoveRight")},

      {key="u", mods="CTRL", action=act.CopyMode{MoveByPage=0.5}},
      {key="d", mods="CTRL", action=act.CopyMode{MoveByPage=-0.5}},

      {key="w", mods="NONE", action=act.CopyMode("MoveForwardWord")},
      {key="b", mods="NONE",  action=act.CopyMode("MoveBackwardWord")},

      {key="0", mods="NONE",  action=act.CopyMode("MoveToStartOfLine")},
      {key="Enter", mods="NONE", action=act.CopyMode("MoveToStartOfNextLine")},
      {key="$", mods="NONE",  action=act.CopyMode("MoveToEndOfLineContent")},
      {key="$", mods="SHIFT", action=act.CopyMode("MoveToEndOfLineContent")},
      {key="_", mods="NONE",  action=act.CopyMode("MoveToStartOfLineContent")},
      {key="_", mods="SHIFT", action=act.CopyMode("MoveToStartOfLineContent")},
      {key="m", mods="ALT",   action=act.CopyMode("MoveToStartOfLineContent")},

      {key=" ", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
      {key="v", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
      {key="V", mods="NONE",  action=act.CopyMode{SetSelectionMode="Line"}},
      {key="V", mods="SHIFT", action=act.CopyMode{SetSelectionMode="Line"}},
      {key="v", mods="CTRL",  action=act.CopyMode{SetSelectionMode="Block"}},

      {key="G", mods="NONE",  action=act.CopyMode("MoveToScrollbackBottom")},
      {key="G", mods="SHIFT", action=act.CopyMode("MoveToScrollbackBottom")},
      {key="g", mods="NONE",  action=act.CopyMode("MoveToScrollbackTop")},

      {key="Enter", mods="NONE", action=act.Multiple{
        act.CopyTo("ClipboardAndPrimarySelection"),
        act.CopyMode("Close"),
      }},
      {key="/", mods="NONE", action=act{Search={CaseSensitiveString=""}}},
      {key="n", mods="CTRL", action=act{CopyMode="NextMatch"}},
    },

    -- Never used this mode btw
    search_mode = {
      {key="Escape", mods="NONE", action=act{CopyMode="Close"}},
      {key="Enter", mods="NONE", action="ActivateCopyMode"},
      {key="n", mods="CTRL", action=act{CopyMode="NextMatch"}},
    },
  }
}
