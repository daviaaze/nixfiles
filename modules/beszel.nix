{ pkgs, lib, config, ... }:

with lib; let
  cfg = config.modules.beszel;
in
{
  options = {
    modules.beszel = {
      enable = mkEnableOption "Beszel";
      port = mkOption {
        type = types.int;
        default = 8090;
        description = "Local beszel port";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.beszel
    ];

    systemd.services.beszel = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nginx";
        Group = "nginx";
        Restart = "always";
        ExecStart = "${pkgs.beszel}/bin/beszel serve --http '0.0.0.0:${toString cfg.port}'";
        startLimitInterval = 180;
        startLimitBurst = 30;
        RestartSec = "5";
      };
    };
  };
}
