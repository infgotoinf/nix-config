# { config, ... }:
let
  modifier = "Win";
  wlroots-screenshot-command = ''grim -g "$(slurp)" - | satty --filename -'';
  # x11-screenshot-command = ''grim -g "$(slurp)" - | satty --filename -'';
in
{
  services.xremap = {
    enable = true;
    withWlroots = true;
    config = {
      keymap = [
        {
          name = "Global";
          remap = {
            "${modifier}-Shift-s" = "${wlroots-screenshot-command}";
            "KEY_PRINT" = "${wlroots-screenshot-command}";
          };
        } 
      ];
    };   
  };
}
