{ pkgs, ... }:
{
  home.packages = with pkgs; [
    frei0r
  ];
}
