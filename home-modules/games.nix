
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    supertuxkart
    mindustry
    prismlauncher
  ];
}
