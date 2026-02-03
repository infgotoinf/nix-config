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
      } // commonConfig;
      systemd.target = "sway-session.target";
    };

    /*
    programs.sway.extraPackages = with pkgs; [
      brightnessctl
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu
      flameshot
      wl-clipboard
    ];
    */

    programs.waybar = {
      enable = true;
    };
  };
}
