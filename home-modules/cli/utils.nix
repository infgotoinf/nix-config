{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    zip
    dtrx
    wget
    calc
    cloc
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
