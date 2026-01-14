{ pkgs, lib, config, ... }:

let
  tmux2k = pkgs.tmuxPlugins.mkTmuxPlugin rec{
    pluginName = "2k"; # Cause plugin code is in `2k.tmux`
    version = "1.8";
    src = pkgs.fetchFromGitHub {
      owner = "2KAbhishek";
      repo = "tmux2k";
      rev = version;
      hash = "sha256-xg6ka8FJsii/LetYE3Cp+9kIiAg8AbK39Wpe7YEVEK8=";
    };
  };

in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    shortcut = "Space";
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      better-mouse-mode
      {
        plugin = tmux2k;
        extraConfig = ''
           set -g @tmux2k-theme 'gruvbox'
           set -g @tmux2k-icons-only true

           set -g @tmux2k-left-plugins "ram cpu cpu-temp gpu"
           set -g @tmux2k-right-plugins "battery bandwidth ping time"
          
           set -g @tmux2k-refresh-rate 100
          
           set -g @tmux2k-show-powerline false
        '';
      }
    ];
  };
}
