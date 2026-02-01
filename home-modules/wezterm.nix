{
  stylix.targets.wezterm.fonts.enable = false;

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        -- font = wezterm.font_from_file("/home/inf/nix-config/etc/fonts/UnifontEX/UnifontExMono.ttf"),
        font = wezterm.font("Unifont Upper"),
        font_size = 12.0, 
      }
    '';
   
  };
}
