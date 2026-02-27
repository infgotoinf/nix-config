{ lib, pkgs, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;
  
in {
  options = {
    wayland.enable = lib.mkEnableOption ''
      Enables wayland based environments.
    '';
  };

  config = lib.mkIf config.wayland.enable {
    wayland = {
      windowManager.sway = {
        enable = true;
        systemd.variables = ["--all"];
        swaynag.enable = true;
        config = {
          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+Shift+s" = ''grim -g "$(slurp)" - | satty --filename -'';
            "Print" = ''grim -g "$(slurp)" - | satty --filename -'';
          };
          input."*" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:caps_toggle";
          };
        } // commonConfig; };
      systemd.target = "sway-session.target";
    };

    home.packages = with pkgs; [
      /*brightnessctl
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu
      flameshot*/
      wl-clipboard
      grim
      slurp
    ];

    programs = {
      waybar = {
        enable = true;
      };
      satty = {
        enable = true;
        settings = {
          general = {
            fullscreen = false;
            corner-roundness = 0;
            initial-tool = "brush";
            output-filename = "~/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png";
          };
        };
      };
    };
  };
}
