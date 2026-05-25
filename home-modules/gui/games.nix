{ pkgs, nixpkgs-stable, ... }:

{
  home.packages = with pkgs; [
    # supertuxkart
    # mindustry
    # cataclysm-dda
    retroarch
  ];

  programs.lutris = {
    enable = true;
    package = nixpkgs-stable.lutris;
  };

  programs.prismlauncher = {
    enable = true;
  };
}
