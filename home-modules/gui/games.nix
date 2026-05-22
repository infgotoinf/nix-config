
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # supertuxkart
    # mindustry
    # itch
    # cataclysm-dda
  ];

  programs.prismlauncher = {
    enable = true;
  };
}
