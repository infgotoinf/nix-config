{ pkgs, ... }:

{
  boot = {
    kernelParams = [
      # https://www.techpowerup.com/338254/intel-gpus-gain-20-performance-by-disabling-security-mitigations
      "NEO_DISABLE_MITIGATIONS=1"
    ];
    loader = {
      timeout = 0; # Mash space to select different generation
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };
}
