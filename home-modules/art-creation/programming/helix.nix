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
      keys.normal = {
        "A-e" = ":toggle soft-wrap.enable";
        "C-y" = [
        	'':sh rm -f /tmp/unique-ca1ea106''
        	'':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-ca1ea106''
        	'':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
        	'':open %sh{cat /tmp/unique-ca1ea106}''
        	'':redraw''
        	'':set mouse false''
          '':set mouse true''
        ];
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
      ruby-lsp
      bash-language-server

      superhtml
      vscode-css-languageserver
      yaml-language-server
    ];
  };
}
