{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wget
    calc
    cloc
    _7zz
    killall
    file-rename
    ffmpeg-full
    # mermaid-filter
    # groff
    catdocx
  ];

  programs.fastfetch = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
  };

  programs.atool = {
    enable = true;
    extraPackages = with pkgs; [
      bzip2
      cpio
      gnutar
      gzip
      lhasa
      lzop
      _7zz
      unrar-free
      unzip
      xz
      zip
    ];
    settings = {
      path_7z = "7zz";
      path_unrar = "unrar-free";
    };
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
