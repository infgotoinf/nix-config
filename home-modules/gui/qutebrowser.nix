# If google account does not work, then paste this inside
# qutebrowser's command prompt
# :set -u https://accounts.google.com/* content.headers.user_agent "Mozilla/5.0 ({os_info}; rv:135.0) Gecko/20100101 Firefox/135"

{ lib, config, ... }:

{
  # For some reason then I go into follow link mode I have to wait about 2-3 seconds till the
  # letters appear and the issue fixes if I change from 12pt to any other. I guess this issue
  # is driver specific, cause I have this issue only on my PC amoung with issue with proper
  # raylib render (f***, Nvidia!)
  # stylix.targets.qutebrowser.fonts.override = { sizes.applications = 11; };

  programs.qutebrowser = {
    enable = true;
    settings = let
      mkf = lib.mkForce;
      qb_colors = config.programs.qutebrowser.settings.colors;
      stylix_colors = config.lib.stylix.colors;
      bg_color  = "#${stylix_colors.base00}";
      bg_color2 = "#${stylix_colors.base01}";
      bg_color3 = "#${stylix_colors.base02}";
      bg_color4 = "#${stylix_colors.base03}";
      fg_color  = "#${stylix_colors.base06}";
      fg_color2 = "#${stylix_colors.base07}";
      yellow    = "#${stylix_colors.base0A}";
      green     = "#${stylix_colors.base0B}";

    in {
      auto_save.session = true;

      colors.webpage.darkmode.enabled = true;
      colors.webpage.bg = mkf bg_color;

      keyhint.delay = 0;

      # Remove rounding everythere
      hints.radius   = 0;
      keyhint.radius = 0;
      prompt.radius  = 0;
      content.user_stylesheets = "~/nix-config/etc/qutebrowser/style.css";

      hints.border = mkf "1px solid ${green}";

      colors = {
        tabs = {
          indicator.start = mkf yellow;

          even.bg = mkf bg_color3;
          even.fg = mkf fg_color2;
          odd.bg  = mkf qb_colors.tabs.even.bg;
          odd.fg  = mkf qb_colors.tabs.even.fg;
          selected = {
            even.bg = mkf bg_color;
            even.fg = mkf fg_color;
            odd.bg  = mkf qb_colors.tabs.selected.even.bg;
            odd.fg  = mkf qb_colors.tabs.selected.even.fg;
          };
          pinned = {
            even.bg = mkf qb_colors.tabs.odd.bg;
            even.fg = mkf qb_colors.tabs.odd.fg;
            odd.bg  = mkf qb_colors.tabs.even.bg;
            odd.fg  = mkf qb_colors.tabs.even.fg;
            selected = {
              even.bg = mkf qb_colors.tabs.selected.odd.bg;
              even.fg = mkf qb_colors.tabs.selected.odd.fg;
              odd.bg  = mkf qb_colors.tabs.selected.even.bg;
              odd.fg  = mkf qb_colors.tabs.selected.even.fg;
            };
          };
        };
        completion = {
          odd.bg = mkf qb_colors.completion.even.bg;
          fg = mkf fg_color;
          scrollbar.fg = mkf fg_color;
          item.selected = {
            bg = mkf bg_color3;
            fg = mkf fg_color2;
            border.top    = mkf qb_colors.completion.item.selected.bg;
            border.bottom = mkf qb_colors.completion.item.selected.bg;
          };
        };
        downloads = {
          bar.bg   = mkf bg_color2;
          start.bg = mkf yellow;
          stop.bg  = mkf green;
        };

        hints.bg   = mkf bg_color;
        hints.fg   = mkf fg_color;
        keyhint.bg = mkf qb_colors.hints.bg;
        keyhint.fg = mkf qb_colors.hints.fg;
        keyhint.suffix.fg = mkf green;
        tooltip.bg = mkf qb_colors.hints.bg;
        tooltip.fg = mkf qb_colors.hints.fg;

        prompts = {
          fg = mkf fg_color;
          selected.bg = mkf bg_color3;
          selected.fg = mkf fg_color2;
        };
        contextmenu = {
          menu.fg = mkf fg_color;
          disabled.bg = mkf bg_color4;
          disabled.fg = mkf bg_color;
          selected.bg = mkf fg_color;
          selected.fg = mkf bg_color;
        };
        statusbar = {
          caret.fg = mkf fg_color;
          caret.selection.fg = mkf fg_color2;
          command.fg = mkf qb_colors.statusbar.caret.fg;
          command.private.fg = mkf qb_colors.statusbar.caret.fg;
          normal.fg = mkf qb_colors.statusbar.caret.fg;
          private.fg = mkf qb_colors.statusbar.caret.fg;

          passthrough.bg = mkf yellow;
          url = {
            fg = mkf fg_color;
            hover.fg = mkf qb_colors.statusbar.url.fg;
            success.http.fg = mkf yellow;
          };
        };
      };
    };
  };

  # programs.librewolf = {
  #   enable = true;
  # };
}
