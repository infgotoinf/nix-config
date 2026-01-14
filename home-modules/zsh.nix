{ pkgs, lib, config, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    history.ignoreAllDups = true;
    antidote = {
      enable = true;
    };
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };
}
