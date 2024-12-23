{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.pelican-wings;
  pelican-wings = pkgs.callPackage ./package.nix { };
  dataDir = "/var/lib/pelican-wings";
in
{
  options.modules.pelican-wings = {
    enable = mkEnableOption "Enable Pelican Wings";
  };

  config = mkIf cfg.enable {
    systemd.services.pelican-wings = {
      description = "Wings Daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "pelican-wings";
        Group = "pelican-wings";
        WorkingDirectory = dataDir;
        ExecStart = "${pelican-wings}/bin/pelican-wings";
        Restart = "always";
        RestartSec = "3";

        # Hardening measures
        ProtectSystem = "full";
        PrivateTmp = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
      };
    };

    # Create user and group
    users.users.pelican-wings = {
      group = "pelican-wings";
      home = dataDir;
      createHome = true;
      isSystemUser = true;
      description = "Pelican Wings daemon user";
    };

    users.groups.pelican-wings = {};

    # Ensure data directory exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 pelican-wings pelican-wings - -"
    ];
  };
}
