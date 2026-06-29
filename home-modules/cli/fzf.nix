{ unstable, ... }:
{
  programs.fzf = {
    enable = true;
    package = unstable.fzf;

    enableFishIntegration = true;
    tmux.enableShellIntegration  = true;
  };
}
