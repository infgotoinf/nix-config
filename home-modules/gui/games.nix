{ pkgs,  ... }:

{
  home.packages = with pkgs; [
    # supertuxkart
    # mindustry
    # cataclysm-dda
    retroarch
    the-powder-toy
  ];

  programs.lutris = {
    # enable = true;
  };

  programs.prismlauncher = {
    enable = true;
  };
}
