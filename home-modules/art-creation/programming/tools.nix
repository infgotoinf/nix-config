{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Debug tools
    gdb-dashboard
    rr

    # Others
    devbox
  ];
}
