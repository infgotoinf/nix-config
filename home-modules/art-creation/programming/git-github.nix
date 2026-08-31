{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      # Moved to ../../hosts
      # user = {
      #   name = "-inf";
      #   email = "infgotoinf@gmail.com";
      # };
      init.defaultBranch = "main";
      core.editor = "hx";
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
      gh-dash
    ];
  };

  services.git-sync = {
    enable = true;
  };

  home.packages = with pkgs; [
    act
  ];
}
