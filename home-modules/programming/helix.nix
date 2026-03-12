{ pkgs, ... }:

{
  stylix.targets.helix.colors.enable = false;

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "gruvbox_dark_hard";
    };

    # LSP's
    extraPackages = with pkgs; [
      nixd
      
      cmake-language-server
      clang-tools

      superhtml
      vscode-css-languageserver
    ];
  };
}
