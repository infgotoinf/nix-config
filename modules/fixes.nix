{ username, ... }:
{
  security.sudo.extraConfig = ''
    Defaults pwfeedback

    Defaults use_pty
  '';

  # For lutris esync
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [{
    domain = username;
    type = "hard";
    item = "nofile";
    value = "524288";
  }];

  # systemd.user.settings.Manager = {
  #   DefaultTimeoutStopSec = 10;
  # };
  systemd.user.extraConfig = "DefaultTimeoutStartSec=10";

  services.journald.extraConfig = ''
    Storage=volotile
    RateLimitInterval=30s
    SystemMaxUse=16M
  '';
}
