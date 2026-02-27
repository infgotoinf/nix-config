{
  # For some reason then I go into follow link mode I have to wait about 2-3 seconds till the
  # letters appear and the issue fixes if I change from 12pt to any other. I guess this issue
  # is driver specific, cause I have this issue only on my PC amoung with issue with proper
  # raylib render (f***, Nvidia!) 
  # stylix.targets.qutebrowser.fonts.override = { sizes.applications = 11; };
  
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      # auto_save.session = true;
    };
  };
}
