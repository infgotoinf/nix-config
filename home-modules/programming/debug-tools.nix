{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cgdb
    gdb
    gdb-dashboard
  ];
}
