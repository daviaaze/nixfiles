{ pkgs, lib, config, ... }:

with lib; let
  cfg = config.modules.pelican-wings;
  pelican-wings = pkgs.callPackage ./package.nix { };
in
{
  options = {
    modules.pelican-wings = {
      enable = mkEnableOption "Pelican Wings";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8080 8443 ];

    virtualisation.docker.enable = true;

    environment.systemPackages = [
      pelican-wings
    ];

    systemd.services.pelican-wings = {
      description = "Wings Daemon";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      partOf = [ "docker.service" ];

      serviceConfig = {
        User = "root";
        WorkingDirectory = "/var/lib/pelican-wings";
        LimitNOFILE = 4096;
        PIDFile = "/var/run/pelican-wings/daemon.pid";
        ExecStart = "${pelican-wings}/bin/pelican-wings";
        Restart = "on-failure";
        startLimitInterval = 180;
        startLimitBurst = 30;
        RestartSec = "5";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
