{ pkgs, ... }:
{
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
}
