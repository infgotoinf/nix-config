{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ncdu
  ];

  programs.w3m = {
    enable = true;
    extraPackages = with pkgs; [
      rdrview
      libsixel
    ];
  };
}
