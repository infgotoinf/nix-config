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
    ffmpeg-full
    mermaid-filter
  ];

  programs.pandoc = {
    enable = true;
  };
}
