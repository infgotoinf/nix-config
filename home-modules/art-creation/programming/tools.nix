{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Debug tools
    gdb-dashboard
    # rr

    # Others
    # devbox
  ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
}
