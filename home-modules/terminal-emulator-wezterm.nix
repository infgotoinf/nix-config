{
  # stylix.targets.wezterm.fonts.enable = false;
  # stylix.targets.wezterm.fonts.override = { sizes = {applications = 14; desktop = 12;}; };

  programs.wezterm = {
    enable = true;
    # enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
