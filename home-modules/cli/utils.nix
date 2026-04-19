{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    zip
    dtrx
    file-rename
    wget
    viu
    calc
    killall
  ];
}
