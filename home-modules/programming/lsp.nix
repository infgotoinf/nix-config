{ pkgs, ... }:

{
  home.packages = with pkgs; [
    superhtml
    vscode-css-languageserver
    
    lldb
    clang
    
    nixd
  ];
}
