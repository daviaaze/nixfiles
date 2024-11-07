{ lib, pkgs, ... }:
{
  services.activitywatch = {
    package = pkgs.aw-server-rust;
    watchers.awatcher = {
      package = pkgs.nur.repos.bhasherbel.aw-awatcher;
      name = "awatcher";
      executable = "awatcher";
      settingsFilename = "config.toml";
      settings = {
        idle-timeout-seconds = 180;
        poll-time-idle-seconds = 5;
        poll-time-window-seconds = 1;
      };
    };
  };
  systemd.user.services.activitywatch.Service.Restart = lib.mkForce "always";
  systemd.user.services.activitywatch-watcher-awatcher.Service.Restart = lib.mkForce "always";
}
