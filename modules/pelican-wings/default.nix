{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.pelican-wings;
  pelican-wings = pkgs.callPackage ./package.nix { };
in
{
  options.modules.pelican-wings = {
    enable = mkEnableOption "Enable Pelican Wings";
  };

  config = mkIf cfg.enable {
    systemd.services.pelican-wings = {
      description = "Pelican Wings Daemon";
      after = [ "network-online.target" "docker.service" ];
      wants = [ "network-online.target" "docker.service" ];
      partOf = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "pelican";
        Group = "pelican";
        WorkingDirectory = "/var/lib/pelican";
        LimitNOFILE = 4096;
        PIDFile = "/run/pelican-wings/daemon.pid";
        ExecStart = "${pelican-wings}/bin/pelican-wings --config /var/lib/pelican/config.yml";
        Restart = "always";
        StartLimitInterval = 180;
        StartLimitBurst = 30;
        RestartSec = "5s";

        # Hardening measures
        ProtectSystem = "full";
        PrivateTmp = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
      };
    };

    # Create user and group
    users.users.pelican = {
      group = "pelican";
      isSystemUser = true;
      home = "/var/lib/pelican";
      createHome = true;
      extraGroups = [ "docker" ];
      description = "Pelican Wings daemon user";
    };

    users.groups.pelican = {};

    networking.firewall.allowedTCPPorts = [ 8443 ];
  };
}
