{ lib, pkgs, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;

in {
  options = {
    i3.enable = lib.mkEnableOption ''
      Enables i3 wm environment.
    '';
  };

  config = lib.mkIf config.i3.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        startup = [
          { command = "wezterm"; always = true; }
        ];
      } // (commonConfig {config = config; lib = lib;});
    };
  };
}
