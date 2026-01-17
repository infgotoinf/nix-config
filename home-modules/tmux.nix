{ pkgs, lib, config, ... }:

let
  tmux2k = pkgs.tmuxPlugins.mkTmuxPlugin rec{
    pluginName = "2k";
    version = "1.8";
    src = pkgs.fetchFromGitHub {
      owner = "2KAbhishek";
      repo = "tmux2k";
      rev = version;
      hash = "sha256-xg6ka8FJsii/LetYE3Cp+9kIiAg8AbK39Wpe7YEVEK8=";
    };
  };
  /*pomodoro = pkgs.tmuxPlugins.mkTmuxPlugin rec{
    pluginName = "pomodoro";
    version = "v1.0.2";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris";
      repo = "tmux-pomodoro";
      rev = version;
      hash = "sha256-xg6ka8FJsii/LetYE3Cp+9kIiAg8AbK39Wpe7YEVEK8=";
    };
  };*/


in {
  programs.tmux = {
    enable = true;
    terminal = "screen-16color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    shortcut = "Space";
    extraConfig = ''
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      better-mouse-mode
      /*{
        plugin = pomodoro;
        extraConfig = ''
          set -g @pomodoro_notifications 'on'
        '';
      }*/
      {
        plugin = tmux2k;
        extraConfig = ''
          set -g @tmux2k-theme 'gruvbox'
          set -g @tmux2k-icons-only true

          set -g @tmux2k-time-format "%a %I:%M %p %B %Y"

          set -g @tmux2k-left-plugins "ram cpu cpu-temp gpu"
          set -g @tmux2k-right-plugins "battery bandwidth ping time"

          set -g @tmux2k-show-powerline false
        '';
      }
    ];
  };
}
