{ pkgs, ... }:
let
  screenshot = ["bash" "-l" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | satty -f -
    else
      flameshot gui
    fi
  ''];

  screenshot-full = ["bash" "-l" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim - | satty -f -
    else
      flameshot gui
    fi
  ''];

  screenlock = ["bash" "-l" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      swaylock-plugin
    else
      ${pkgs.i3lock}/bin/i3lock
    fi
  ''];
in
{
  services.xremap = {
    enable = true;
    config = {
      keymap = [
        {
          name = "Screenshot";
          remap = {
            "Win-Shift-s".launch = screenshot;
            "Win-s".launch = screenshot-full;
          };
        }
        {
          name = "Application launcher";
          remap = {
            "Win-Space".launch = ["bash" "-l" "-c" "rofi -show drun"];
            "Win-Alt-Space".launch = ["bash" "-l" "-c" "rofi -show emoji"];
            "Win-Ctrl-Alt-Space".launch = ["bash" "-l" "-c" "rofi -show nerdy"];
          };
        }
        {
          name = "Pc control";
          remap = {
            "Win-Ctrl-Shift-l".launch = screenlock;
            "Win-Ctrl-Shift-r".launch = ["bash" "-c" "reboot"];
            "Win-Ctrl-Shift-p".launch = ["bash" "-c" "poweroff"];
            "Win-Ctrl-Shift-h".launch = ["bash" "-c" "systemctl hibernate"];
          };
        }
      ];
    };
  };
}
