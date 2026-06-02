{ pkgs, config, ... }:

{
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs.mopidyPackages; [
      mopidy-bandcamp
      mopidy-soundcloud
      mopidy-youtube
      mopidy-mpd
    ];
    settings = {

    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}";
    network.startWhenNeeded = true;
  };

  home.packages = with pkgs; [
    mpd
    mpc
  ];
}
