{
  #stylix.targets.wezterm.fonts.enable = false;

  programs.wezterm = {
    enable = true;
    #enableZshIntegration = true;
    extraConfig = ''
      return {
        -- font = wezterm.font_from_file("/home/inf/nix-config/etc/fonts/UnifontEX/UnifontExMono.ttf"),
        -- font = wezterm.font("UnifontExMono"); -- cp etc/fonts/UnifontEX/UnifontExMono.ttf ~/.local/share/fonts
        -- font_size = 12.0,
        cell_width = 0.5,

        default_cursor_style = 'BlinkingBlock',
        cursor_blink_ease_in = 'Constant',
        cursor_blink_ease_out = 'Constant',
        cursor_blink_rate = 250,
      }
    '';
   
  };
}
