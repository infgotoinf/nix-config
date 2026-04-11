{ pkgs, ... }:

{
  # TODO: Find a replacement for light due to it's being unmaintained and removed from nixpkgs
  # programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      # Set `Ctrl+F9' to increase display brightness
      # { keys = [ 29 67 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/light -U 2"; }
      # Set `Ctrl+F10' to decrease display brightness
      # { keys = [ 29 68 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/light -A 2"; }
      
      # Set 'Shift+F9' to volume up
      { keys = [ 42 67 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 1+ unmute"; }
      # Set 'Shift+F10' to volume down
      { keys = [ 42 68 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 1- unmute"; }
      
      # Set 'Ctrl+F8' to mute sound
      { keys = [ 29 66 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle"; }
      # Set 'Shift+F8' to mute mic
      { keys = [ 42 66 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Capture toggle"; }
    ];
  };
}

