{ pkgs, ... }:
{
  # For automounting connected devices
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
  };

  # For the sake of reproducable and flexable gammastep
  # services.geoclue2.enable = true;

  programs.gpu-screen-recorder = {
    enable = true;
  };

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    w3m
  ];
}
