{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    extraConfig = {
      max-history = 99;
    };
    theme =
    let
      # Use `mkLiteral` for string-like values that should show without
      # quotes, e.g.:
      # {
      #   foo = "abc"; => foo: "abc";
      #   bar = mkLiteral "abc"; => bar: abc;
      # };
      inherit (config.lib.formats.rasi) mkLiteral;
      colors = config.lib.stylix.colors.withHashtag;
      # bg-color = colors.base00;
      bg-color3 = colors.base02;
      fg-color2 = colors.base07;
      accent = colors.orange;
      element-padding = "1 2";

    in {
      "*" = {
        spacing = 0;
        margin = 0;
        highlight = mkLiteral "bold ${accent}";
      };
      "window" = {
        border = 1;
        border-color = mkLiteral accent;
      };

      "#mainbox" = {
        children = [
          "textbox-custom"
          "listview"
          "inputbar"
        ];
      };

      "textbox-custom" = {
        expand = false;
        content = "Applications";
        text-color = mkLiteral accent;
        padding = mkLiteral element-padding;
      };

      "#listview" = {
        # columns = 2;
        lines = 28;
        # reverse = true;
      };
      "#element" = {
        padding = mkLiteral element-padding;
        vertical-align = mkLiteral "0.5";
        spacing = 4;
        children = map mkLiteral [
          "element-icon"
          # "element-index"
          "element-text"
        ];
      };
      "element.alternate.normal" = {
        background-color = mkLiteral "@normal-background";
        text-color = mkLiteral "@normal-foreground";
      };
      "element.selected.normal" = {
        background-color = mkLiteral bg-color3;
        text-color = mkLiteral fg-color2;
      };
      "#element-icon" = {
        vertical-align = mkLiteral "inherit";
      };
      "#element-index" = {
        text-color = mkLiteral "inherit";
        background-color = mkLiteral "inherit";
      };
      "#element-text" = {
        vertical-align = mkLiteral "inherit";
      };
      # "#element-text-description" = {
      #   text-color = mkLiteral "inherit";
      #   size = 20;
      # };
      # "element-text-description" = {
      #   text-color = mkLiteral "inherit";
      #   size = 20;
      # };

      "#textbox-prompt-colon" = {
        expand = false;
        str = "> ";
      };
      "#inputbar" = {
        # border = 1;
        highlight = mkLiteral "bold";
        padding = mkLiteral element-padding;
        children = map mkLiteral [
          # "prompt"
          "textbox-prompt-colon"
          "entry"
          # "case-indicator"
        ];
      };
    };

    modes = [
      "drun"
      "emoji"
      "nerdy"
    ];
    plugins = with pkgs; [
      rofi-emoji
      rofi-nerdy
    ];
  };
}
