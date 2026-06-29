{ pkgs, unstable, lib, config, ... }: {

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    initLua = ./yazi.lua;
    # package = pkgs.yazi.override {_7zz = pkgs._7zz-rar; };
    settings = {
      mgr = {
        linemode = "size_and_mtime";
      };
      input = {
        cursor_blink = true;
      };
      preview = {
        image_delay = 0;
        max_width = 640;
        max_height = 640;
      };
      # https://github.com/boydaihungst/mediainfo.yazi
      plugin = {
        prepend_preloaders = [
          # Replace magick, image, video with mediainfo
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }

          # Adobe Photoshop is image/adobe.photoshop, already handled above
          # Adobe Illustrator
          # { mime = "application/postscript"; run = "mediainfo"; }
          # { mime = "application/illustrator"; run = "mediainfo"; }
          # { mime = "application/dvb.ait"; run = "mediainfo"; }
          # { mime = "application/vnd.adobe.illustrator"; run = "mediainfo"; }
          # { mime = "image/x-eps"; run = "mediainfo"; }
          # { mime = "application/eps"; run = "mediainfo"; }

          # Sometimes AI file is recognized as "application/pdf". Lmao.
          # In this case use file extension instead:
          { url = "*.{ai,eps,ait}"; run = "mediainfo"; }

          # Hide metadata by default.
          # Example for image mimetype:
          # { mime = "{image}/*"; run = "mediainfo --no-metadata"; }

          # Hide image preview by default.
          # Example for video mimetype:
          # { mime = "{video}/*"; run = "mediainfo --no-preview"; }

          # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
          # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
        ];
        prepend_previewers = [
          # Replace magick, image, video with mediainfo
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }

          # Adobe Photoshop is image/adobe.photoshop, already handled above
          # Adobe Illustrator
          # { mime = "application/postscript"; run = "mediainfo"; }
          # { mime = "application/illustrator"; run = "mediainfo"; }
          # { mime = "application/dvb.ait"; run = "mediainfo"; }
          # { mime = "application/vnd.adobe.illustrator"; run = "mediainfo"; }
          # { mime = "image/x-eps"; run = "mediainfo"; }
          # { mime = "application/eps"; run = "mediainfo"; }

          # Sometimes AI file is recognized as "application/pdf". Lmao.
          # In this case use file extension instead:
          { url = "*.{ai,eps,ait}"; run = "mediainfo"; }

          # Hide metadata by default.
          # Example for image mimetype:
          # { mime = "{image}/*"; run = "mediainfo --no-metadata"; }

          # Hide image preview by default.
          # Example for video mimetype:
          # { mime = "{video}/*"; run = "mediainfo --no-preview"; }

          # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
          # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
        ];
      };
      tasks = {
        image_alloc = 1073741824;
        image_bound = [0 0];
      };
    };
    theme = let
      mkf = lib.mkForce;
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
      indicator.padding = {
        open = "▐";
        close = "▌";
      };
      status = {
        sep_left = config.programs.yazi.theme.indicator.padding;
        sep_right = config.programs.yazi.theme.indicator.padding;

        overall = {
          fg = "${fg_color}";
          bg = "${bg_color3}";
        };
        left.open = {
          fg = "${fg_color}";
          bg = "${bg_color3}";
        };
      };
      mgr = {
        border_symbol = " ";
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          # https://github.com/sxyazi/yazi/discussions/327
          on = [ "<C-n>" ];
          run = ''shell -- ${pkgs.dragon-drop}/bin/dragon-drop -x -i -T "$@" -a -s 100'';
        }
        {
          on   = "<C-g>";
          run  = ''shell -- rofi -theme fullscreen-preview -show filebrowser -filebrowser-command "ya emit reveal" -filebrowser-directory "$(pwd)"'';
        }
        {
          on   = "T";
          run  = "plugin toggle-pane max-preview";
        }
      ];
    };

    plugins = with pkgs.yaziPlugins; {
      "starship" = {
        package = starship;
        setup = true;
      };
      "allmytoes" = {
        package = unstable.yaziPlugins.allmytoes;
        setup = true;
      };
      # "bypass" = {
      #   package = bypass;
      #   setup = true;
      # };
      "mediainfo" = {
        package = mediainfo;
        # setup = true;
      };
      "toggle-pane" = {
        package = toggle-pane;
        # setup = true;
      };
    };
    extraPackages = with pkgs; [
      imagemagick
      mediainfo
      unstable.allmytoes
    ];
  };
}
