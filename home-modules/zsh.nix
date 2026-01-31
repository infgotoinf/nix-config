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
      /*
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      */
      {
        name = "agkozak-zsh-prompt";
        src = pkgs.agkozak-zsh-prompt;
        file = "share/zsh/site-functions/agkozak-zsh-prompt.plugin.zsh";
      }
    ];
    localVariables = 
    let
      # Custom prompt config
      
      exit_status           = ''%(?..%B%F{red}(%?%)%f%b )'';
      cmd_exec_time         = ''%(9V.%F{yellow}%9v %f.)'';
      username_and_hostname = ''%(!.%S%B.%B%F{magenta})%n%1v%(!.%b%s.%f%b)'';
      path                  = ''%B%F{blue}%2v%f%b'';
      venv                  = ''%(10V. %F{green}[%10v]%f.)'';
      bg_job_indicator      = ''%(1j. %F{magenta}%jj%f.)'';
      git_status            = ''%(3V.%F{yellow}%3v%f.)'';
      prompt_char           = ''%(4V.:.%#) '';
    in
    {
      AGKOZAK_PROMPT_DIRTRIM = 0;

      AGKOZAK_BLANK_LINES = 1;

      AGKOZAK_LEFT_PROMPT_ONLY = 1;
      AGKOZAK_PROMPT_CHAR = [ "$" "#" ":" ];

      /*
      AGKOZAK_COLORS_CMD_EXEC = "yellow";
      AGKOZAK_COLORS_CMD_EXEC_TIME = "yellow";
      AGKOZAK_COLORS_USER_HOST = "magenta";
      AGKOZAK_COLORS_PATH = "blue";
      */
      
      AGKOZAK_CUSTOM_PROMPT = ''
        ${exit_status}${cmd_exec_time}%F{red}[%f${username_and_hostname}%F{red}:%f${path}%F{red}]%f${venv}${bg_job_indicator}${git_status}
        ${prompt_char}'';
    };
    /*initContent = ''
      source <(fzf --zsh)
    '';
    */
  };
}
