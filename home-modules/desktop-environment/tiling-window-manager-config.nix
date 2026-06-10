{ pkgs, config, lib }:

{
  terminal = "wezterm";
  defaultWorkspace = "workspace number 1";
  modifier = "Mod4";
  # assigns = {
  #   #"1: console" = [{ class = "^Wezterm$"; }];
  # };
  menu = "rofi -show drun";
  gaps = {
    outer = 1;
  };

  bars = [{
    # statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-cool.toml";
    statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
    position = "top";
    trayPadding = 4;
    fonts = let
      stylix_fonts = config.stylix.fonts;
    in {
      size = stylix_fonts.sizes.desktop + 0.0;
      names = [ stylix_fonts.monospace.name ];
    };
    colors = let
      stylix_colors = config.lib.stylix.colors;
      bg_color = "#${stylix_colors.base00}";
      bg_color2 = "#${stylix_colors.base01}";
      fg_color = "#${stylix_colors.base06}";
    in {
      background = "${bg_color}";
      statusline = "${bg_color}";
      separator = "${bg_color}";
      focusedStatusline = "${fg_color}";
      focusedWorkspace = {
        background = bg_color;
        border = bg_color;
        text = fg_color;
      };
      activeWorkspace = {
        background = bg_color2;
        border = bg_color2;
        text = fg_color;
      };
      inactiveWorkspace = {
        background = bg_color2;
        border = bg_color2;
        text = fg_color;
      };
      urgentWorkspace = {
        background = bg_color2;
        border = bg_color2;
        text = fg_color;
      };
      bindingMode = {
        background = bg_color2;
        border = bg_color2;
        text = fg_color;
      };
    };
  }];

  # startup = [
  #   { command = "wezterm"; always = true; }
  # ];

  # window = [

  # ];
}
