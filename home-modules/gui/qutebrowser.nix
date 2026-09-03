{ pkgs, lib, config, ... }:
{
  # https://github.com/qutebrowser/qutebrowser/issues/5378
  # home.sessionVariables = {
  #   QTWEBENGINE_CHROMIUM_FLAGS = "--enable-gpu-rasterization";
  # };

  programs.qutebrowser = {
    enable = true;
    searchEngines = {

    };

    keyBindings = {
      normal = {
        "H" = "tab-prev";
        "L" = "tab-next";
        "J" = "back";
        "K" = "forward";
        "<Ctrl-Shift-H>" = "tab-move -";
        "<Ctrl-Shift-L>" = "tab-move +";

        "<Alt-c>" = "open -t";
        "<Alt-Return>" = "open -t";

        "pv" = "spawn mpv {url}";
        "<Ctrl-i>" = "config-cycle colors.webpage.darkmode.enabled true false";
      };
    };

    perDomainSettings = {
      "discord.com" = {
        content = {
          media.audio_capture = true;
          media.video_capture = true;
          javascript.clipboard = "access";
        };
        colors.webpage.darkmode.enabled = false;
      };
      "github.com" = {
        content.javascript.clipboard = "access";
        colors.webpage.darkmode.enabled = false;
      };
      "www.youtube.com" = {
        colors.webpage.darkmode.enabled = false;
      };
      "web.telegram.org" = {
        colors.webpage.darkmode.enabled = false;
      };
      # Fixes the error with not being able to login in Google account
      # https://github.com/qutebrowser/qutebrowser/issues/5182
      "accounts.google.com" = {
        content.headers.user_agent = "Mozilla/5.0 ({os_info}; rv:135.0) Gecko/20100101 Firefox/135";
      };
    };

    greasemonkey = [
      # (pkgs.fetchurl { # Block sponsors on youtube
      #   url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1ab9f20435cdc39c6551e940fb7788d3207161e6/youtube_sponsorblock.js";
      #   sha256 = "1pk05gsmbr3kp37214x8h0020gh5jli9frbagf606f0apmc6bhys";
      # })
      (pkgs.fetchurl { # Removes youtube shorts
        url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1ab9f20435cdc39c6551e940fb7788d3207161e6/youtube_shorts_block.js";
        sha256 = "sha256-e9qCSAuEMoNivepy7W/W5F9D1PJZrPAJoejsBi9ejiY=";
      })
      # (pkgs.fetchurl { # Youtube addblocker
      #   url = "https://raw.githubusercontent.com/iamfugui/youtube-adb/ddceb665747980df3411e9081fda9286d53ccea5/index.user.js";
      #   sha256 = "1s04dgmlj75d49bgz9afl50bg0d6srrlxjlnndgjvg5piwjz1yfv";
      # })
      # (pkgs.fetchurl { # Youtube video downloader, adblocker and sponsorblocker
      #   url = "https://update.greasyfork.org/scripts/34613/YouTube%20Ultimate%20Downloader%20v133%20%F0%9F%9A%80%20%E2%80%94%20All-in-One%20Media%20Suite%20%F0%9F%8C%8D%F0%9F%8E%A5%F0%9F%8E%B5%20%7C%20Ad-Free%20%2B%20SponsorBlock%20%F0%9F%9B%A1.user.js";
      #   sha256 = "sha256-UCxyVu6ig4JPLPIUse84oRapauLrXpO6E8mFHThehAo=";
      # })
      # (pkgs.fetchurl { # Lower youtube footprint
      #   url = "https://update.greasyfork.org/scripts/431573/YouTube%20CPU%20Tamer%20by%20AnimationFrame.user.js";
      #   sha256 = "sha256-5/OXukzb/IIhUQb1o4p4pWBeLtx6cCO930PvUYHuAxw=";
      # })
      # (pkgs.fetchurl { # Prioritises video loading on media sites
      #   url = "https://update.greasyfork.org/scripts/571522/I%20Hate%20Waiting.user.js";
      #   sha256 = "sha256-nx7GIpnV+dOq6Yt4TVI5T4xZRsEHoL187u/pXVimjYU=";
      # })
      # (pkgs.fetchurl { # Lowers CPU usage by optimising js events
      #   url = "https://update.greasyfork.org/scripts/531874/Web%20CPU%20Tamer.user.js";
      #   sha256 = "sha256-ov1FouQmzCgfi4iYnRuVGtsqa1XnAa17KTCmLCspjGk=";
      # })
      # (pkgs.fetchurl { # Lets you select text on sites that prevent you from selecting text
      #   url = "https://raw.githubusercontent.com/qxinGitHub/Remove-web-limits-/refs/heads/master/Remove-web-limits-网页限制解除(改).js";
      #   sha256 = "sha256-L4tOP7ukMkFI6BseJ5VdZvgTMcOtkf79Lz8awo4N57k=";
      # })
      # Why do they keep adding this annoying shit, like really why
      (pkgs.writeText "remove-annoying-ad-youtube-logo.js" ''
        // ==UserScript==
        // @name         Remove annoying ad YouTube logo
        // @version      1.1.0
        // @author       infgotoinf
        // @license      MIT
        // @match        *://*.youtube.com/*
        // @grant        none
        // ==/UserScript==

        (function () {
          function removeElements() {
            document
              .querySelectorAll('img.style-scope.ytd-yoodle-renderer')
              .forEach((x) => x.remove());
          }

          if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', removeElements);
          } else {
            removeElements();
          }
        })();
      '')
    ];

    settings = let
      mkf = lib.mkForce;
      qb_colors = config.programs.qutebrowser.settings.colors;
      colors = config.lib.stylix.colors.withHashtag;

    in {
      qt.args = [
        "--enable-gpu-rasterization"
      ];
      auto_save.session = true;

      colors.webpage.darkmode.enabled = true;
      colors.webpage.bg = mkf colors.base00;

      keyhint.delay = 0;

      # Remove rounding everythere
      hints.radius   = 0;
      keyhint.radius = 0;
      prompt.radius  = 0;
      # Other custom css styling
      content.user_stylesheets = [(toString (pkgs.writeText "style.css" ''
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

        /* Apply UnifontExMono font everythere except PUA icons and stuff */
        *:not([class*="icon"]):not([class*="fa"]):not([class*="material"]):not([class*="glyph"]) {
          font-family: "Unifont", "Twitter Color Emoji" !important;
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
      ''))];


      # "${../../etc/qutebrowser}/style.css";
      content.blocking.method = "both";

      hints.border = mkf "1px solid ${colors.green}";
      colors = {
        tabs = {
          indicator.start = mkf colors.yellow;

          even.bg = mkf colors.base03;
          even.fg = mkf colors.base06;
          odd.bg  = mkf qb_colors.tabs.even.bg;
          odd.fg  = mkf qb_colors.tabs.even.fg;
          selected = {
            even.bg = mkf colors.base00;
            even.fg = mkf colors.base07;
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
          fg = mkf colors.base07;
          scrollbar.fg = mkf colors.base07;
          item.selected = {
            bg = mkf colors.base03;
            fg = mkf colors.base06;
            border.top    = mkf qb_colors.completion.item.selected.bg;
            border.bottom = mkf qb_colors.completion.item.selected.bg;
          };
        };
        downloads = {
          bar.bg   = mkf colors.base02;
          start.bg = mkf colors.yellow;
          stop.bg  = mkf colors.green;
        };

        hints.bg   = mkf colors.base00;
        hints.fg   = mkf colors.base07;
        keyhint.bg = mkf qb_colors.hints.bg;
        keyhint.fg = mkf qb_colors.hints.fg;
        keyhint.suffix.fg = mkf colors.green;
        tooltip.bg = mkf qb_colors.hints.bg;
        tooltip.fg = mkf qb_colors.hints.fg;

        prompts = {
          fg = mkf colors.base07;
          selected.bg = mkf colors.base03;
          selected.fg = mkf colors.base06;
        };
        contextmenu = {
          menu.fg = mkf colors.base07;
          disabled.bg = mkf colors.base04;
          disabled.fg = mkf colors.base00;
          selected.bg = mkf colors.base07;
          selected.fg = mkf colors.base00;
        };
        statusbar = {
          caret.fg = mkf colors.base07;
          caret.selection.fg = mkf colors.base06;
          command.fg = mkf qb_colors.statusbar.caret.fg;
          command.private.fg = mkf qb_colors.statusbar.caret.fg;
          normal.fg = mkf qb_colors.statusbar.caret.fg;
          private.fg = mkf qb_colors.statusbar.caret.fg;

          passthrough.bg = mkf colors.yellow;
          url = {
            fg = mkf colors.base07;
            hover.fg = mkf qb_colors.statusbar.url.fg;
            success.http.fg = mkf colors.yellow;
          };
        };
      };
    };
  };
}
