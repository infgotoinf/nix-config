{ lib, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;

in {
  options = {
    xorg.enable = lib.mkEnableOption ''
      Enables X11 based environments.
    '';
  };

  config = lib.mkIf config.xorg.enable {
    xsession.windowManager.i3 = {
      enable = true;
    } // commonConfig;
  };
}
