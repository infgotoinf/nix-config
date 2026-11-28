{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Based
    wget
    _7zz
    file
    killall
    ffmpeg-full
    imagemagick

    # Usefull tools
    calc      # calculator
    cloc      # number of lines of code
    codespell # typos in code
    file-rename

    # Working with documents
    # mermaid-filter
    catdocx
    poppler-utils # For pdftotext
  ];

  programs.fd = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration  = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batgrep
      batdiff
    ];
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    colors = "auto";
    icons = "auto";
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
