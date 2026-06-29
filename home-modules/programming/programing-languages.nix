{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    cmake
    lua
    ruby
  ];
}
