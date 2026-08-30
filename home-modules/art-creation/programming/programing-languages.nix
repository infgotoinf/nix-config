{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    cmake
    lua
    ruby
    nodejs
  ];
}
