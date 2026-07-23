{
  security.pam = {
    loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
  };

  services.autorandr.enable = true;
  services.picom.enable = true;

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      open = false;
      # TODO: add PRIME configuration for laptop
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Early drivers startup
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
}
