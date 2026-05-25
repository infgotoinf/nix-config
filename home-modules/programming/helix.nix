{ pkgs, ... }:

{
  stylix.targets.helix.colors.enable = false;

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "gruvbox_dark_hard";
      editor = {
        scrolloff = 8;
        completion-replace = true;
        color-modes = true;
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        auto-pairs = false;
        auto-save.focus-lost = true;
      };
    };

    languages = {
      language = [{
        name = "perl";
        indent = { tab-width = 4; unit = "    "; };
      }];
    };

    # LSP's
    extraPackages = with pkgs; [
      nixd

      cmake-language-server
      clang-tools

      # python314Packages.jedi-language-server
      ty
      ruff
      lua-language-server
      perlnavigator

      superhtml
      vscode-css-languageserver
      yaml-language-server
    ];
  };
}
