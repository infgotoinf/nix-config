{ lib, config, system_info, ... }:

{
  programs.i3status-rust = {
    enable = true;

    bars."bar" = let
        stylix_colors = config.lib.stylix.colors;
        # fg_color  = "#${stylix_colors.base06}";
        # fg_color2 = "#${stylix_colors.base07}";
        red       = "#${stylix_colors.base08}";
        orange    = "#${stylix_colors.base09}";
        yellow    = "#${stylix_colors.base0A}";
        green     = "#${stylix_colors.base0B}";
        cyan      = "#${stylix_colors.base0C}";
        blue      = "#${stylix_colors.base0D}";
        purple    = "#${stylix_colors.base0E}";
        pink      = "#${stylix_colors.base0F}";
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
           theme_overrides.idle_fg = pink;
        }
        {
           block = "disk_iostats";
           format = "$icon READ $speed_read.eng(prefix:K,w:3) WRITE $speed_write.eng(prefix:K,w:3)";
           interval = 2;
           theme_overrides.idle_fg = orange;
        }
        {
          block = "memory";
          format = "$icon $mem_used.eng(prefix:Mi,w:3)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2))";
          interval = 2;
          theme_overrides.idle_fg = yellow;
        }
        {
          block = "net";
          format = "$icon ^icon_net_down $speed_down.eng(prefix:K,w:3) ^icon_net_up $speed_up.eng(prefix:K,w:3)";
          interval = 2;
          theme_overrides.idle_fg = blue;
        }
        {
          block = "cpu";
          format = "$icon $utilization";
          interval = 2;
          theme_overrides.idle_fg = purple;
        }
        (lib.mkIf (system_info.has_amd_gpu) {
          block = "amd_gpu";
          format = "$icon $utilization";
          interval = 2;
          theme_overrides.idle_fg = green;
        })
        (lib.mkIf (system_info.has_nvidia_gpu) {
          block = "nvidia_gpu";
          format = "$icon $utilization $memory $temperature";
          interval = 2;
          theme_overrides.idle_fg = green;
        })
        {
         block = "temperature";
          format = "$icon $max";
          interval = 2;
          # theme_overrides.idle_fg = red;
        }
        {
          block = "load";
          format = "$icon $1m";
          interval = 2;
          theme_overrides.idle_fg = orange;
        }
        (lib.mkIf (system_info.has_battery) { block = "battery";
          format = "$icon $percentage";
          interval = 30;
          theme_overrides.idle_fg = purple;
        })
        (lib.mkIf (system_info.has_backlight) { block = "backlight";
          format = "$icon $brightness";
          theme_overrides.idle_fg = yellow;
        })
        {
          block = "sound";
          format = "$icon $volume";
          theme_overrides.idle_fg = green;
        }
        # {
        #   block = "privacy";
        # }
        {
          block = "time";
          format = "$timestamp.datetime(f:'%a %y/%m/%d %R')";
          theme_overrides.idle_fg = cyan;
        }
        {
          block = "keyboard_layout";
          driver = "sway";
          mappings = {
            "English (US)" = "EN";
            "Russian (N/A)" = "RU";
          };
          format = "$layout";
          theme_overrides.idle_fg = blue;
        }
        # {
        #   block = "menu";
        #   text = " MENU ";
        #   items = [
        #     {
        #       display = "   SLEEP   ";
        #       cmd = "systemctl suspend";
        #     }
        #     {
        #       display = " POWER OFF ";
        #       cmd = "poweroff";
        #       confirm_msg = "Are you sure you want to power off?";
        #     }
        #     {
        #       display = "  REBOOT   ";
        #       cmd = "reboot";
        #       confirm_msg = "Are you sure you want to reboot?";
        #     }
        #   ];
        # }
      ];
      settings = {
        theme = {
          theme = "native";
          overrides = {
            idle_fg = blue;
            info_fg = cyan;
            good_fg = green;
            warning_fg = orange;
            critical_fg = red;

            separator = "  ";
          };
        };
      };
      # icons = "awesome5";
      # theme = "gruvbox-dark";
    };
  };
}
