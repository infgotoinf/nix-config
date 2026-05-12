# { config, ... }:
let
  modifier = "Win";
  wlroots-screenshot-command = ["bash" "-c" ''grim -g "$(slurp)" - | satty -f -''];
  wlroots-screenshot-command2 = ["bash" "-c" ''grim - | satty -f -''];
  # x11-screenshot-command = ''grim -g "$(slurp)" - | satty --filename -'';
in
{
  services.xremap = {
    enable = true;
    # withWlroots = true;
    config = {
      keymap = [
        # Use Ctrl+[ instead
        # {
        #   name = "Second esc";
        #   remap = {
        #     "Alt-Capslock" = "Esc";
        #     "Win-Capslock" = "Esc";
        #     "Ctrl-Capslock" = "Esc";
        #   };
        # }
        {
          name = "Screenshot";
          remap = {
            "${modifier}-Shift-s".launch = wlroots-screenshot-command;
            "${modifier}-s".launch = wlroots-screenshot-command2;
          };
        }
        {
          name = "Application launcher";
          remap = {
            "${modifier}-Space".launch = ["bash" "-c" "rofi -show drun"];
            "${modifier}-Alt-Space".launch = ["bash" "-c" "rofi -show emoji"];
            "${modifier}-Ctrl-Alt-Space".launch = ["bash" "-c" "rofi -show nerdy"];
          };
        }
      ];
    };
  };
}
