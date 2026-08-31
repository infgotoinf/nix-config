{ pkgs, config, ... }:
{
  # services.mopidy = {
  #   enable = true;
  #   extensionPackages = with pkgs.mopidyPackages; [
  #     mopidy-bandcamp
  #     mopidy-soundcloud
  #     mopidy-youtube
  #     mopidy-mpd
  #   ];
  #   settings = {

  #   };
  # };

  programs.rmpc = {
    enable = true;
    config = ''(
      keybinds: (global: { "H": PreviousTab, "L": NextTab  })
    )'';
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}/playlists";
    playlistDirectory = "${config.xdg.userDirs.music}/playlists";
    network.startWhenNeeded = true;
    extraConfig = ''
      audio_output {
        name "Pipewire"
        type "pipewire"
      }
    '';
  };

  # For i3status-rust status
  services.mpdris2 = {
    enable = true;
  };

  home.packages = with pkgs; [
    mpc
  ];
}
