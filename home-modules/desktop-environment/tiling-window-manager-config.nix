{ pkgs, config, lib }: # Don't remove lib

{
  terminal = "wezterm";
  defaultWorkspace = "workspace number 1";
  modifier = "Mod4";
  # assigns = {
  #   #"1: console" = [{ class = "^Wezterm$"; }];
  # };
  menu = "rofi -show drun";
  # gaps = {
  #   bottom = 1;
  #   horizontal = 1;
  # };

  window.commands = [
    {
      command = "floating enable, sticky enable";
      criteria = {
        app_id = "screenkey";
      };
    }
  ];

  keybindings = lib.mkOptionDefault {
    "Mod4+Shift+Ctrl+q" = "kill";
    "Mod4+q" = null;
    "Mod4+r" = null;
    "Mod4+k" = null;
    "Mod4+b" = null;
  };

  bars = [{
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-bar.toml";
    position = "top";
    # trayPadding = 4;
    fonts = let
      stylix_fonts = config.stylix.fonts;
    in {
      size = stylix_fonts.sizes.desktop + 0.0;
      names = [ stylix_fonts.monospace.name ];
    };
    colors = let
      colors = config.lib.stylix.colors.withHashtag;
    in {
      background = colors.base00;
      statusline = colors.base00;
      separator = colors.base00;
      focusedStatusline = colors.base00;
      focusedWorkspace = {
        background = colors.base00;
        border = colors.base00;
        text = colors.base06;
      };
      activeWorkspace = {
        background = colors.base01;
        border = colors.base01;
        text = colors.base06;
      };
      inactiveWorkspace = {
        background = colors.base01;
        border = colors.base01;
        text = colors.base06;
      };
      urgentWorkspace = {
        background = colors.base01;
        border = colors.base01;
        text = colors.base06;
      };
      bindingMode = {
        background = colors.base01;
        border = colors.base01;
        text = colors.base06;
      };
    };
  }];

  # window = [

  # ];
}
