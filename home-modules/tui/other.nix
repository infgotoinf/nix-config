{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ncdu
    _2048-in-terminal
  ];
}
