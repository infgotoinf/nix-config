{ config, ... }:
{
  programs.discord.enable = true;

  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = false;
      splashTheming = true;
      staticTitle = true;
      # hardwareAcceleration = true;
      hardwareAcceleration = false;
      discordBranch = "stable";
    };
    vencord = let
      colors = config.lib.stylix.colors.withHashtag;
    in {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        disableMinSize = true;
        notifyAboutUpdates = false;
        plugins = {
          # FakeNitro = {
          #   enabled = true;
          # };
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
        };
        useQuickCss = true;
      };
      extraQuickCss = ''
        @font-face {
            font-family: 'UnifontExMono';
            src: url(https://github.com/stgiga/UnifontEX/releases/download/16/UnifontExMono.woff) format('woff');
          }

          /* Remove every border radius */
          *,
          *::before,
          *::after {
            border-radius: 0px !important;
            clip-path: none !important;
          }

          /* Scrollbar */
          *::-webkit-scrollbar {
            width: 12px !important;
            height: 12px !important;
          }

          *::-webkit-scrollbar-track {
            background-color: ${colors.base00} !important;
            border-radius: 0px !important;
          }

          *::-webkit-scrollbar-thumb {
            background-color: ${colors.base03};
            border-radius: 0px !important;
            min-height: 30px !important;
          }

          *::-webkit-scrollbar-thumb:hover,
          *::-webkit-scrollbar-thumb:active {
            background-color: ${colors.base04};
          }

          /* Appli UnifontExMono font everythere except PUA icons and stuff */
          *:not([class*="icon"]):not([class*="fa"]):not([class*="material"]):not([class*="glyph"]) {
            font-family: UnifontExMono !important;
          }

          /* Make every regular text have the same size */
          :is(a,
            b,
            i,
            p,
            li,
            body,
            input,
            textarea,
            button,
            select):not([class*="icon"]):not([class*="fa"]):not([class*="material"]):not([class*="glyph"]) {
            font-size: 16px !important;
          }

          /* Makes bold text work if it doesn't (cause it doesn't in Github markdown)*/
          strong,
          b {
            font-weight: bold !important;
          }

          /********** COLOR **********/
          /* Change selection color */
          ::selection {
            background-color: ${colors.blue} !important;
          }
      '';
    };
  };
}
