{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "-inf";
	      email = "infgotoinf@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
    ];
  };
}
