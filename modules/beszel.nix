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
        default = 8091;
        description = "Local beszel port";
      };

      key = mkOption {
        type = types.str;
        description = "Beszel key";
      };

      hub = mkOption {
        type = types.submodule {
          options = {
            enable = mkEnableOption "Beszel hub";
            port = mkOption {
              type = types.int;
              default = 8090;
              description = "Local beszel hub port";
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.beszel
    ];

    systemd.services.beszel-agent = mkIf cfg.hub.enable {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Envirionment = [
          "PORT=${toString cfg.port}"
          "KEY=${cfg.key}"
        ];
        User = "nginx";
        Group = "nginx";
        Restart = "always";
        WorkingDirectory = "/var/lib/beszel/agent";
        ExecStart = "${pkgs.beszel}/bin/beszel-agent";
        startLimitInterval = 180;
        startLimitBurst = 30;
        RestartSec = "5";
      };
    };

    systemd.services.beszel-hub = mkIf cfg.hub.enable {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nginx";
        Group = "nginx";
        Restart = "always";
        WorkingDirectory = "/var/lib/beszel/hub";
        ExecStart = "${pkgs.beszel}/bin/beszel-hub serve --http '0.0.0.0:${toString cfg.hub.port}'";
        startLimitInterval = 180;
        startLimitBurst = 30;
        RestartSec = "5";
      };
    };
  };
}
