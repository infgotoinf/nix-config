{ system_info, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = system_info.has_nvidia_gpu;

  programs.nix-ld = {
    enable = true;
  };

  # To use those variables then rebuild with sudo
  # they defined in ../home-modules/home-manager.nix
  security.sudo.extraConfig = ''
    Defaults env_keep += "NH_FLAKE NH_OS_FLAKE"
  '';

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      # Mirrors in case of 1984
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # Ok, they don't work in 1984

      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
