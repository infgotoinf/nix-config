{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ncdu
    _2048-in-terminal
  ];

  # TODO: Configure mpd, zathura, aerc and weathr
  # Configure nnn or ranger or lf
}
