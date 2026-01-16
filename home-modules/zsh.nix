{ pkgs, lib, config, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    history = {
      ignoreAllDups = true;
      share = true;
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "agkozak-zsh-prompt";
        src = pkgs.agkozak-zsh-prompt;
        file = "share/zsh/site-functions/agkozak-zsh-prompt.plugin.zsh";
      }
    ];
    localVariables = {
      AGKOZAK_PROMPT_DIRTRIM = 10;

      AGKOZAK_COLORS_CMD_EXEC = "yellow";
      #AGKOZAK_COLORS_PROMPT_CHAR = "yellow";
      AGKOZAK_COLORS_USER_HOST = "red";
      AGKOZAK_COLORS_PATH = "blue";
      
      AGKOZAK_BLANK_LINES = 1;

      AGKOZAK_LEFT_PROMPT_ONLY = 1;
      AGKOZAK_PROMPT_CHAR = [ "$" "#" ":" ];
    };
  };
}
