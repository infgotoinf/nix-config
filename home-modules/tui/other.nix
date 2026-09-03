{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ncdu
    sc-im
  ];

  programs.w3m = {
    enable = true;
    extraPackages = with pkgs; [
      rdrview
      libsixel
    ];
  };
}
