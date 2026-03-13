# { config, ... }:
let
  modifier = "Win";
  wlroots-screenshot-command = ["bash" "-c" ''grim -g "$(slurp)" - | satty --filename -''];
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
            "${modifier}-s".launch = wlroots-screenshot-command;
            # "KEY_PRINT".launch = wlroots-screenshot-command;
          };
        }
        {
          name = "Application launcher";
          remap = {
            "${modifier}-Space".launch = ["bash" "-c" "rofi -show drun"];
            "${modifier}-Alt-Space".launch = ["bash" "-c" "rofi -show emoji"];
          };
        }
      ];
    };   
  };
}
