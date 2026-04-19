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
        # swaynag.enable = true;
        config = {
          input."*" = {
            # modules/keyboard/locales-keyboard-layouts.nix
            xkb_layout = "us,ru";
            xkb_options = "grp:caps_toggle";
          };
          startup = [
            { command = "systemctl --user restart xremap"; }
            { command = ''swaybg -c "#1d2021"''; always = true; }
            { command = "wezterm"; always = true; }
          ];
        } // commonConfig; };
      # systemd.target = "sway-session.target";
    };

    home.packages = with pkgs; [
      /*brightnessctl
      swayidle
      swaylock
      wmenu*/
      wl-clipboard
      grim
      slurp
      swaybg
    ];

    programs = {
      waybar = {
        enable = true;
      };
      satty = {
        enable = true;
        settings = {
          general = {
            floating-hack = true;
            corner-roundness = 0;
            resize.mode = "smart";
            initial-tool = "brush";
            output-filename = "~/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png";
          };
        };
      };
    };
  };
}
