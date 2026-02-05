{ 
  config = rec{
    terminal = "wezterm";
    defaultWorkspace = "workspace number 1";
    assigns = {
      #"1: console" = [{ class = "^Wezterm$"; }];
    };
    gaps = {
      outer = 1;
    };

    bars = [
      
    ];

    startup = [
      { command = "wezterm"; always = true; }
      #{ command = "vieb"; }
    ];

    /*window = [
   
    ];*/
  };
  extraConfig = ''
  '';
}
