{ pkgs, lib, config, ... }:

{
  programs.i3blocks = let
      mkf = lib.mkForce;
      qb_colors = config.programs.qutebrowser.settings.colors;
      stylix_colors = config.lib.stylix.colors;
      bg_color  = "#${stylix_colors.base00}";
      bg_color2 = "#${stylix_colors.base01}";
      bg_color3 = "#${stylix_colors.base02}";
      bg_color4 = "#${stylix_colors.base03}";
      fg_color  = "#${stylix_colors.base06}";
      fg_color2 = "#${stylix_colors.base07}";
      red       = "#${stylix_colors.base08}";
      yellow    = "#${stylix_colors.base0A}";
      green     = "#${stylix_colors.base0B}";
  in {
    enable = true;
    #       music = {
    #         command = "~/.config/i3blocks/scripts/now_playing.sh";
    #         interval = 15;
    #       };

    #       network = lib.hm.dag.entryAfter [ "music" ] {
    #         command = "~/.config/i3blocks/scripts/network.sh";
    #         interval = 60;
    #       };

    #       brightness = lib.mkIf (!config.haze.isDesktop) (
    #         lib.hm.dag.entryAfter [ "network" ] {
    #           command = "~/.config/i3blocks/scripts/brightness.sh";
    #           interval = "once";
    #           signal = 11;
    #         }
    #       );

    #       volume = lib.hm.dag.entryAfter [ "brightness" "network" ] {
    #         command = "~/.config/i3blocks/scripts/volume.sh";
    #         interval = 60;
    #         signal = 10;
    #       };

    #       battery = lib.mkIf (!config.haze.isDesktop) (
    #         lib.hm.dag.entryAfter [ "volume" ] {
    #           command = "~/.config/i3blocks/scripts/battery.sh";
    #           interval = 60;
    #           signal = 12;
    #         }
    #       );

    #       datetime = lib.hm.dag.entryAfter [ "battery" "volume" ] {
    #         command = "date '+%Y-%m-%d %I:%M %p'";
    #         interval = 60;
    #         signal = 13;
    #       };

    #     };
    #   };

    #     volume = {
    #       interval = 1;
    #       command = ''echo "Volume: $(pactl list sinks | grep Volume | head -n1 | awk '{print $5}')"'';
    #     };
    #     brightness = {
    #       interval = 1;
    #       command = ''echo "Brightness: $(xbacklight -get | cut -d '.' -f 1)%"'';
    #     };
    #     battery = {
    #       interval = 1;
    #       command = ''echo "Battery: $(acpi -b | grep -P -o '[0-9]+(?=%)')%"'';
    #     };
    #     disk = {
    #       interval = 1;
    #       command = ''echo "Disk: $(df -h / | grep / | awk '{print $5}')"'';
    #     };
    #     memory = {
    #       interval = 1;
    #       command = ''echo "Memory: $(free -h | grep Mem | awk '{print $3}')"'';
    #     };
    #     time_date = {
    #       interval = 1;
    #       command = ''date +" %a, %d %b - %H:%M:%S"'';
    #     };
    #   };
    # };

    bars.config = {
        song = {
          command = ''[[ $(${pkgs.playerctl}/bin/playerctl status) = "Playing" ]] && ${pkgs.playerctl}/bin/playerctl metadata -f ' {{title}} - {{artist}}' || echo ""'';
          interval = 10;
        };
        bat = lib.hm.dag.entryAfter [ "song" ] {
          label = "BAT ";
          command = "${pkgs.acpi}/bin/acpi -b | grep -o '[0-9]\\+%' | head -n1";
          interval = 30;
        };
        vol = lib.hm.dag.entryAfter [ "bat" ] {
          label = "VOL";
          command = ''
            ${pkgs.pipewire}/bin/wpctl get-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1
          '';
          interval = 10;
        };
        disk = lib.hm.dag.entryAfter [ "vol" ] {
          interval = 1;
          command = ''echo "Disk: $(df -h / | grep / | awk '{print $5}')"'';
        };
        ram = lib.hm.dag.entryAfter [ "disk" ] {
          label = "RAM ";
          command = "${pkgs.procps}/bin/free -h | awk '/Mem:/ {print \$3 \"/\" \$2}'";
          interval = 10;
        };
        cpu = lib.hm.dag.entryAfter [ "disk" ] {
          label = "CPU ";
          command = "${pkgs.procps}/bin/uptime | awk -F'load average: ' '{print \$2}'";
          interval = 5;
        };
        net = {
          label = "NET ";
          command = "${pkgs.iproute2}/bin/ip -4 addr show scope global | grep inet | awk '{print \$2}' | cut -d/ -f1 | head -n1";
          interval = 20;
        };
        tmpc = {
          # label = "TMP° ";
          command = "${pkgs.lm_sensors}/bin/sensors | awk '/Tctl/ {print $2; exit}'";
          interval = 15;
        };
        hn = {
          label = "HN ";
          command = "${pkgs.coreutils}/bin/hostname -s";
          interval = 1000;
        };
        dt = {
          command = "${pkgs.coreutils}/bin/date '+%a, %y/%m/%d %H:%M'";
          interval = "once";
        };
      };
    };
}
