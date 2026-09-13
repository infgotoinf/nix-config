{ lib, config, ... }:

{
  options = {
    has_nvidia_gpu = lib.mkEnableOption ''
      Enables nvidia gpu specific options
    '';
    has_amd_gpu= lib.mkEnableOption ''
      Enables amd gpu specific options
    '';
  };

  config = lib.mkMerge [
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
        nvidia = lib.mkIf config.has_nvidia_gpu {
          branch = "production";
          # open = true;
          open = false;
          forceFullCompositionPipeline = true;
          modesetting.enable = true;
          # TODO: add PRIME configuration for laptop
        };
      };
    }

    (lib.mkIf config.has_nvidia_gpu {
      services.xserver.videoDrivers = [ "nvidia" ];

      # Early drivers startup
      boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

      nixpkgs.config.cudaSupport = true;
    })
  ];
}
