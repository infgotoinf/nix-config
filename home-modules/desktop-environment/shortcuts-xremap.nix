let
  wlroots-screenshot-command = ["bash" "-c" ''grim -g "$(slurp)" - | satty -f -''];
  wlroots-screenshot-command2 = ["bash" "-c" ''grim - | satty -f -''];
  # x11-screenshot-command = ''grim -g "$(slurp)" - | satty --filename -'';
in
{
  services.xremap = {
    enable = true;
    config = {
      keymap = [
        {
          name = "Screenshot";
          remap = {
            "Win-Shift-s".launch = wlroots-screenshot-command;
            "Win-s".launch = wlroots-screenshot-command2;
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
        {
          name = "Killer";
          remap = {
            "Win-Alt-x".launch = ["bash" "-c" "swaymsg kill"];
          };
        }
      ];
    };
  };
}
