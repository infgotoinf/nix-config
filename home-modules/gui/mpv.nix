{
  programs.mpv = {
    enable = true;
    scriptOpts.visualizer = {
      # mode = "noalbumart";
      name = "avectorscope";
      height = 9;
      quality = "high";
      # forcewindow = true;
    };
  };

  xdg.configFile."mpv/scripts/visualizer.lua".source = ./visualizer.lua;
}
