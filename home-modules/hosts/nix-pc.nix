{
  imports = [
    ./email.nix
  ];

  # i3.enable = true;
  sway.enable = true;

  drawing.enable = true;
  music-production.enable = true;
  modeling.enable = true;
  video-editing.enable = true;

  discord.enable = true;

  has_nvidia_gpu = true;

  # services.wayvnc = {
  #   enable = true;
  #   settings = {
  #     address = "0.0.0.0";
  #     port = 5900;
  #   };
  # };
}
