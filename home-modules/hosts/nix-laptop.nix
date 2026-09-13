{ config, ... }:
{
  accounts.email = {
    maildirBasePath = "Mail";
    accounts."-inf" = {
      address = "infgotoinf@gmail.com";
      userName = config.accounts.email.accounts."-inf".address;
      realName = "-inf";
      primary = true;

      # https://aerc-docs.com/providers/gmail/
      passwordCommand = "pass email/gmail";

      notmuch = {
        enable = true;
        neomutt.enable = true;
      };
      # mbsync = {
      #   enable = true;
      #   create = "maildir";
      #   patterns = [
      #     "INBOX"
      #     "[Gmail]/Drafts"
      #     "[Gmail]/Sent Mail"
      #     "[Gmail]/Spam"
      #     "[Gmail]/Trash"
      #   ];
      # };
      # aerc.enable = true;
      neomutt.enable = true;
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };
    };
  };
  programs.git.settings.user = {
    name = config.accounts.email.accounts."-inf".realName;
    email = config.accounts.email.accounts."-inf".address;
  };
}
