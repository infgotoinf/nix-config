{
  console = {
    font = ../etc/fonts/Unifont-APL8x16-17.0.03.psf.gz;
    # font = "Lat2-Terminus16";
    earlySetup = true;
    useXkbConfig = true; # use xkb.options in tty.
  };

  environment.variables = {
    TERM = "xterm-256color";
  };
}
