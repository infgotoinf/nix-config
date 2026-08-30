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
    file-rename
    ffmpeg-full
    # mermaid-filter
    # I REALLY NEED THOSE
    # cowsay
    # kittysay
    # lolcat
    # uwuify
  ];

  programs.fastfetch = {
    enable = true;
  };

  # programs.pandoc = {
  #   enable = true;
  # };

  programs.mpv = {
    enable = true;
  };

  # TODO: configure this thing fully
  # programs.translate-shell = {
  #   enable = true;
  #   settings = {
  #     hl = "ru";
  #     tl = [
  #       "ru"
  #       "en"
  #     ];
  #     # engine = "yandex";
  #     verbose = true;
  #   };
  # };
}
