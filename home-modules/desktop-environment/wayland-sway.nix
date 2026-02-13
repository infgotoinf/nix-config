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
        config = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in {
          keybindings = lib.mkOptionDefault {
            "${modifier}+Shift+s" = ''exec grim -g "$(slurp)" - | swappy -f -'';
            "Print" = "exec grimshot save output - | tee ~/Pictures/Screenshots/$(data +%Y-%m-%d_%H-%M-%S).png | wl-copy";
          };
          input."*" = {
            xkb_layout = config.services.xserver.xkb.layout;
            xkb_options = config.services.xserver.xkb.options;
          };  
        };
      } // commonConfig;
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
      sway-contrib.grimshot
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
