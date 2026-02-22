{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd

    cmake-language-server

    superhtml
    vscode-css-languageserver
  ];
}
