{
  programs.notmuch = {
    enable = true;
    # hooks = {
    #   preNew = "mbsync -a";
    # };
  };

  programs.mbsync = {
    enable = true;
  };

  # programs.aerc = {
  #   enable = true;
  #   extraConfig = {
  #     general.unsafe-accounts-conf = true;

  #     ui.stylesets = "default";
  #   };
  # };
  # home.file.".config/aerc/stylesets/default" = {
  #   source = "${./.}/default";
  #   force = true;
  # };

  # programs.alot = {
  #   enable = true;
  # };

  programs.neomutt = {
    enable = true;
    # vimKeys = true;
    # sidebar.enable = true;
    # Thanks https://gist.github.com/LukeSmithxyz/de94948264649a9264193e96f5610c44
    extraConfig = ''
      bind index gT noop
      bind pager gT noop

      source ${./.}/mutt-wizard.muttrc
    '';
  };
}
