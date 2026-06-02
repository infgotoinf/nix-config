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

  programs.mpv = {
    enable = true;
  };

  # TODO: configure this thing fully
  programs.translate-shell = {
    enable = true;
    settings = {
      hl = "ru";
      tl = [
        "ru"
        "en"
      ];
      # engine = "yandex";
      verbose = true;
    };
  };
}
