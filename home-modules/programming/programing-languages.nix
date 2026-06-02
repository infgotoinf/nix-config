{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    lua
    ruby
  ];
}
