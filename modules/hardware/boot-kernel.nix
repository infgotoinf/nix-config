{ pkgs, ... }:

{
  boot = {
    loader = {
      timeout = 0; # Mash space to select different deneration
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };
}

