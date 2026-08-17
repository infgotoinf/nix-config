{ system_info, ... }:

{
  security.pam = {
    loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
  };

  services.autorandr.enable = true;

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      open = false;
      forceFullCompositionPipeline = true;
      # TODO: add PRIME configuration for laptop
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Early drivers startup
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  nixpkgs.config.cudaSupport = system_info.has_nvidia_gpu;
}
