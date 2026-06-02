{ lib, pkgs, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;

in {
  options = {
    sway.enable = lib.mkEnableOption ''
      Enables sway wm environment.
    '';
  };

  config = lib.mkIf config.sway.enable {
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
            { command = "systemctl --user restart xremap"; always = true; }
            { command = ''swaybg -c "#1d2021"''; always = true; }
            { command = "wezterm"; always = true; }
          ];
        } // (commonConfig {config = config; lib = lib;});
      };
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
