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
      description = "Wings Daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "pelican-wings";
        Group = "pelican-wings";
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
      isSystemUser = true;
      extraGroups = [ "docker" ];
      description = "Pelican Wings daemon user";
    };

    users.groups.pelican-wings = {};
  };
}
