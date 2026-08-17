{ lib, config, system_info, ... }:

{
  config = lib.mkIf config.i3.enable or config.sway.enable {
    programs.i3status-rust = {
      enable = true;

      bars."bar" = let
          colors = config.lib.stylix.colors.withHashtag;
        in {
        blocks = [
          {
            block = "music";
            format = "{$combo.str|}";
          }
          {
             block = "disk_space";
             info_type = "used";
             warning = 75.0;
             alert = 90.0;
             format = "$icon $used/$total($percentage)";
             interval = 60;
             theme_overrides.idle_fg = colors.magenta;
          }
          {
             block = "disk_iostats";
             format = "$icon READ $speed_read.eng(prefix:K,w:3) WRITE $speed_write.eng(prefix:K,w:3)";
             interval = 2;
             theme_overrides.idle_fg = colors.orange;
          }
          {
            block = "memory";
            format = "$icon $mem_used.eng(prefix:Mi,w:3)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2))";
            interval = 2;
            theme_overrides.idle_fg = colors.yellow;
          }
          {
            block = "net";
            format = "$icon ^icon_net_down $speed_down.eng(prefix:K,w:3) ^icon_net_up $speed_up.eng(prefix:K,w:3)";
            interval = 2;
            theme_overrides.idle_fg = colors.blue;
          }
          {
            block = "cpu";
            format = "$icon $utilization";
            interval = 2;
            theme_overrides.idle_fg = colors.magenta;
          }
          (lib.mkIf (system_info.has_amd_gpu) {
            block = "amd_gpu";
            format = "$icon $utilization";
            interval = 2;
            theme_overrides.idle_fg = colors.green;
          })
          (lib.mkIf (system_info.has_nvidia_gpu) {
            block = "nvidia_gpu";
            format = "$icon $utilization $memory $temperature";
            interval = 2;
            theme_overrides.idle_fg = colors.green;
          })
          {
           block = "temperature";
            format = "$icon $max";
            interval = 2;
            # theme_overrides.idle_fg = colors.red;
          }
          {
            block = "load";
            format = "$icon $1m";
            interval = 2;
            theme_overrides.idle_fg = colors.orange;
          }
          (lib.mkIf (system_info.has_battery) { block = "battery";
            format = "$icon $percentage";
            interval = 30;
            theme_overrides.idle_fg = colors.magenta;
          })
          (lib.mkIf (system_info.has_backlight) { block = "backlight";
            format = "$icon $brightness";
            theme_overrides.idle_fg = colors.yellow;
          })
          {
            block = "sound";
            format = "$icon $volume";
            theme_overrides.idle_fg = colors.green;
          }
          # {
          #   block = "privacy";
          # }
          {
            block = "time";
            format = "$timestamp.datetime(f:'%a %y/%m/%d %R')";
            theme_overrides.idle_fg = colors.cyan;
          }
          {
            block = "keyboard_layout";
            driver = "sway";
            mappings = {
              "English (US)" = "EN";
              "Russian (N/A)" = "RU";
            };
            format = "$layout ";
            error_format = "";
            theme_overrides.idle_fg = colors.blue;
          }
          {
            block = "keyboard_layout";
            driver = "xkbevent";
            mappings = {
              "us (N/A)" = "EN";
              "ru (N/A)" = "RU";
            };
            format = "$layout ";
            error_format = "";
            theme_overrides.idle_fg = colors.blue;
          }
        ];
        settings = {
          theme = {
            theme = "native";
            overrides = {
              idle_fg = colors.blue;
              info_fg = colors.cyan;
              good_fg = colors.green;
              warning_fg = colors.orange;
              critical_fg = colors.red;

              separator = "  ";
            };
          };
        };
        # icons = "awesome5";
      };
    };
  };
}
