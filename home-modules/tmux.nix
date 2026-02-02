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

in {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      better-mouse-mode # Saves scroll buffer
      {
        plugin = tmux2k;
        extraConfig = ''
          set -g @tmux2k-icons-only true

          set -g @tmux2k-time-format "%a %I:%M %p %B %Y"

          set -g @tmux2k-left-plugins "ram cpu cpu-temp gpu"
          set -g @tmux2k-right-plugins "battery ping time"

          set -g @tmux2k-show-powerline false


          set -g @tmux2k-ram-icon "RAM:"
          set -g @tmux2k-cpu-icon "CPU:"
          set -g @tmux2k-cpu-temp-icon "CPU-TEMP:"
          set -g @tmux2k-gpu-icon "GPU:"

          set -g @tmux2k-battery-charging-icon "CHARGING..."
          set -g @tmux2k-battery-missing-icon " "
          set -g @tmux2k-battery-percentage-0 "!!!BAT:"
          set -g @tmux2k-battery-percentage-1 "!BAT:"
          set -g @tmux2k-battery-percentage-2 "BAT:"
          set -g @tmux2k-battery-percentage-3 "BAT:"
          set -g @tmux2k-battery-percentage-4 "BAT:"
          set -g @tmux2k-ping-icon "Ping:"
          set -g @tmux2k-time-icon " "
        '';
      }
    ];
    extraConfig = ''
      set -g focus-events on


      set -g status-position top
      set -g pane-border-status top 
      set -g pane-border-format ""


      bind -n M-- split-window -v -c "#{pane_current_path}"
      bind -n M-= split-window -h -c "#{pane_current_path}"
      bind -n M-f resize-pane -Z

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5

      bind -n M-c new-window
      bind -n M-n next-window
      bind -n M-p previous-window
      bind -n M-. last-window

      bind -n M-0 select-window -t 0
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-S-d detach-client

      bind -n M-? list-keys
      bind -n M-t clock-mode

      bind -n M-x copy-mode
      bind -n M-v paste-buffer
    '';
  };
}
