{ pkgs, lib, config, ... }: {

  options = {
    xorg.enable = lib.mkEnableOption "enables xorg";
  };

  config = lib.mkIf config.xorg.enable {
    services.xserver = {
      enable = true;
      windowManager = {
        i3.enable = true;
      };
    };
  };
}
