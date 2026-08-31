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
  ];

  programs.fastfetch = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
  };

  # programs.pandoc = {
  #   enable = true;
  # };

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
