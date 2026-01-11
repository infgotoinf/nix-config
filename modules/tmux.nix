{ pkgs, lib, config, ... }: {

  #let
  #  tmux2k = pkgs.tmuxPlugins.mkTmuxPlugin {
  #    pluginName = "tmux2k";
  #    version = "unstable-2026-01-01";
  #    src = pkgs.fetchFromGitHub {
  #      owner = "2KAbhichek";
  #      repo = "tmux2k";
  #      rev = "

  programs.tmux = {
    enable =  true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    shortcut = "Space";
    plugins = with pkgs.tmuxPlugins; [
      
      resurrect
      better-mouse-mode
    ];
  };   
}
