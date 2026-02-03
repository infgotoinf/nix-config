{
  config = {
    terminal = "wezterm";
    defaultWorkspace = "workspace number 1";
    assigns = {
      #"1: console" = [{ class = "^Wezterm$"; }];
    };
    gaps = {
      outer = 5;
    };

    bars = [
      
    ];

    startup = [
      { command = "wezterm"; always = true; }
      { command = "vieb"; }
    ];

    /*window = [
   
    ];*/
  };
  extraConfig = ''
  '';
}
