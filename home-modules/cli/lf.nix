{ pkgs, config, ... }: {

  xdg.configFile."lf/icons".source = ./../../etc/icons;

  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    commands = {
      dragon-out = ''%${pkgs.dragon-drop}/bin/dragon-drop -a -x "$fx"'';
    };
    keybindings = {
      e = ''$$EDITOR $f'';
    };
  };
}
