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
        # https://github.com/NixOS/nixpkgs/issues/554125#issuecomment-5346123812
        nvidia = lib.mkIf config.has_nvidia_gpu {
          package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "595.91.07";
            sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
            sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
            openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
            settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
            persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
          };
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
