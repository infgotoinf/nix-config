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
            { command = ''swaybg -c "${config.lib.stylix.colors.withHashtag.base00}"''; always = true; }
            { command = "wezterm"; always = true; }
            # This fixes xremap not starting in time/not stating correctly
            { command = "systemctl --user import-environment SWAYSOCK WAYLAND_DISPLAY XDG_RUNTIME_DIR"; always = true; }
            { command = "systemctl --user restart xremap"; always = true; }
          ];
        } // (commonConfig {pkgs = pkgs; config = config; lib = lib;});
      };
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

    programs.satty = {
      enable = true;
      settings.general = {
        floating-hack = true;
        corner-roundness = 0;
        resize.mode = "smart";
        initial-tool = "brush";
        output-filename = "~/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png";
      };
    };
  };
}
