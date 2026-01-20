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
    ignores = [
      ".*"
      "build"
    ];
  };
}
