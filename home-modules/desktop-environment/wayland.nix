{ lib, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;
  
in {
  options = {
    wayland.enable = lib.mkEnableOption ''
      Enables wayland based environments.
    '';
  };

  config = lib.mkIf config.wayland.enable {
    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
    } // commonConfig;
  };
}
