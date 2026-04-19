{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gdb-dashboard
    rr
  ];
}
