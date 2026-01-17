{ pkgs, lib, config, ... }: {
  services.displayManager = {
    enable = true;
    ly = {
      enable = true;
    };
  };
}
