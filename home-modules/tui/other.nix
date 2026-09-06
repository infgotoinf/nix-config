{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ncdu
    # sc-im
  ];

  # programs.chawan = {
  #   enable = true;
  #   settings = {
  #     buffer = {
  #       autofocus = true;
  #       images = true;
  #     };
  #   };
  # };
}
