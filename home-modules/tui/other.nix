{ pkgs, username, ... }:
{
  home.packages = with pkgs; [
    ncdu
    _2048-in-terminal
  ];

  # TODO: Configure aerc
  # Configure nnn or ranger or lf or broot

  # accounts.email.accounts.${username}.aerc = {
  #   enable = true;
  # };

  programs.aerc = {
    enable = true;
  };

  # programs.alot = {
  #   enable = true;
  # };

  # programs.notmuch = {
  #   enable = true;
  # };
}
