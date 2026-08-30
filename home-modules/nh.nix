{ username, config, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 7 --optimise";
    };
    flake = "/home/${username}/nix-config";
    homeFlake = config.programs.nh.flake;
    osFlake = config.programs.nh.flake;
  };
}
