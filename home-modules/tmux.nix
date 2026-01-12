{ pkgs, lib, config, ... }:

let
  tmux2k = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux2k";
    version = "unstable-2026-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "2KAbhichek";
      repo = "tmux2k";
      rev = "2f7a613793a982401d9233fa2755dc2f5a916219";
      hash = "sha256-xg6ka8FJsii/LetYE3Cp+9kIiAg8AbK39Wpe7YEVEK8=";
    };
  };

in {
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
      {
        plugin = tmux2k;
        extraConfig = ''
          # set -g @tmux2k-icons-only true

           set -g @tmux2k-left-plugins "ram cpu cpu-temp gpu"
           set -g @tmux2k-right-plugins "bandwidth ping time"
          
           set -g @tmux2k-refresh-rate 10
          
           set -g @tmux2k-show-powerline false
        '';
      }
    ];
  };
}
