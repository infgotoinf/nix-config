{
  # Not in stylix.nix cause nixosModule doesn't have such option ig
  stylix.targets.gtk.extraCss = ''
    * {
      border-radius: 0;
      transition: none;
      -gtk-outline-radius: 0;
    }
  '';

  services.udiskie.enable = true;

  home.sessionVariables  = {
    TERM = "xterm-256color";
  };
}
