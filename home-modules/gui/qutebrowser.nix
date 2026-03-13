{ lib, config, ... }:

let
  mkf = lib.mkForce;
  qb-colors = config.programs.qutebrowser.settings.colors;
  stylix-colors = config.lib.stylix.colors;
  bg-color = "#${stylix-colors.base00}";
  bg-color2 = "#${stylix-colors.base01}";
  bg-color3 = "#${stylix-colors.base02}";
  bg-color4 = "#${stylix-colors.base03}";
  fg-color = "#${stylix-colors.base06}";
  fg-color2 = "#${stylix-colors.base07}";
  yellow = "#${stylix-colors.base0A}";
  green = "#${stylix-colors.base0B}";

in
{
  # For some reason then I go into follow link mode I have to wait about 2-3 seconds till the
  # letters appear and the issue fixes if I change from 12pt to any other. I guess this issue
  # is driver specific, cause I have this issue only on my PC amoung with issue with proper
  # raylib render (f***, Nvidia!) 
  # stylix.targets.qutebrowser.fonts.override = { sizes.applications = 11; };
  
  programs.qutebrowser = {
    enable = true;
    settings = {
      auto_save.session = true;

      colors.webpage.darkmode.enabled = true;
      colors.webpage.bg = mkf bg-color;

      keyhint.delay = 0;
      
      # Remove rounding everythere
      hints.radius = 0;
      keyhint.radius = 0;
      prompt.radius = 0;
      content.user_stylesheets = "~/nix-config/etc/qutebrowser/style.css";

      hints.border = mkf "1px solid ${green}";
      
      colors = {
        tabs = {
          indicator.start = mkf yellow;
          
          even.bg = mkf bg-color4;
          even.fg = mkf fg-color;
          odd.bg = mkf qb-colors.tabs.even.bg;
          odd.fg = mkf qb-colors.tabs.even.fg;
          selected = {
            even.bg = mkf bg-color;
            even.fg = mkf fg-color;
            odd.bg = mkf qb-colors.tabs.selected.even.bg;
            odd.fg = mkf qb-colors.tabs.selected.even.fg;
          };
          pinned = {
            even.bg = mkf qb-colors.tabs.odd.bg;
            even.fg = mkf qb-colors.tabs.odd.fg;
            odd.bg = mkf qb-colors.tabs.even.bg;
            odd.fg = mkf qb-colors.tabs.even.fg;
            selected = {
              even.bg = mkf qb-colors.tabs.selected.odd.bg;
              even.fg = mkf qb-colors.tabs.selected.odd.fg;
              odd.bg = mkf qb-colors.tabs.selected.even.bg;
              odd.fg = mkf qb-colors.tabs.selected.even.fg;
            };
          };
        };
        completion = {
          odd.bg = mkf qb-colors.completion.even.bg;
          fg = mkf fg-color;
          scrollbar.fg = mkf fg-color;
          item.selected = {
            bg = mkf bg-color3;
            fg = mkf fg-color2;
            border.top = mkf qb-colors.completion.item.selected.bg;
            border.bottom = mkf qb-colors.completion.item.selected.bg;
          };
        };
        downloads = {
          bar.bg = mkf bg-color2;
          start.bg = mkf yellow;
          stop.bg = mkf green;
        };

        hints.bg = mkf bg-color;
        hints.fg = mkf fg-color;
        keyhint.bg = mkf qb-colors.hints.bg;
        keyhint.fg = mkf qb-colors.hints.fg;
        keyhint.suffix.fg = mkf green;
        tooltip.bg = mkf qb-colors.hints.bg;
        tooltip.fg = mkf qb-colors.hints.fg;

        prompts = {
          fg = mkf fg-color;
          selected.bg = mkf bg-color3;
          selected.fg = mkf fg-color2;
        };
        contextmenu = {
          menu.fg = mkf fg-color;
          disabled.bg = mkf bg-color4;
          disabled.fg = mkf bg-color;
          selected.bg = mkf fg-color;
          selected.fg = mkf bg-color;
        };
        statusbar = {
          caret.fg = mkf fg-color;
          caret.selection.fg = mkf fg-color2;
          command.fg = mkf qb-colors.statusbar.caret.fg;
          command.private.fg = mkf qb-colors.statusbar.caret.fg;
          normal.fg = mkf qb-colors.statusbar.caret.fg;
          private.fg = mkf qb-colors.statusbar.caret.fg;

          passthrough.bg = mkf yellow;
          url = {
            fg = mkf fg-color;
            hover.fg = mkf qb-colors.statusbar.url.fg;
            success.http.fg = mkf yellow;
          };
        };
      };
    };
  };

  programs.librewolf = {
    enable = true;
  };
}
