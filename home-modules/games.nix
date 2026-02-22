
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    superTuxKart
    mindustry
    prismlauncher
  ];
}
