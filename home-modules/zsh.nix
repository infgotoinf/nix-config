{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    dotDir = "${config.xdg.configHome}/zsh"; 
    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    plugins = [
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
      nix_shell             = ''%F{blue}($((SHLVL/2)))%f '';
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
        ${exit_status}${cmd_exec_time}${nix_shell}%F{red}[%f${username_and_hostname}%F{red}:%f${path}%F{red}]%f${venv}${bg_job_indicator}${git_status}
        ${prompt_char}'';
    };
    initContent = ''
      # Disabling underline
      (( ''${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[path]=none
      ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green
      ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green
      ZSH_HIGHLIGHT_STYLES[precommand]=fg=green

      # Change cursor to blinking block
      # echo -ne '\e[1 q'
      echo -e '\033[?6c'
    '';
  };
}
