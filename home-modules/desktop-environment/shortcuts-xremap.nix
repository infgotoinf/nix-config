{ pkgs, ... }:
let
  screenshot = ["bash" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | satty -f -
    else
      flameshot gui
    fi
  ''];

  screenshot-full = ["bash" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim - | satty -f -
    else
      flameshot gui
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
            "Win-Space".launch = ["bash" "-c" "rofi -show drun"];
            "Win-Alt-Space".launch = ["bash" "-c" "rofi -show emoji"];
            "Win-Ctrl-Alt-Space".launch = ["bash" "-c" "rofi -show nerdy"];
          };
        }
        # {
        #   name = "Killer";
        #   remap = {
        #     "Win-Alt-x".launch = ["bash" "-c" "swaymsg kill"];
        #   };
        # }
      ];
    };
  };
}
