{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.cloudflared;
in
{
  options.modules.cloudflared = {
    enable = mkEnableOption "Cloudflared";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cloudflared
    ];

    users.users.cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
    users.groups.cloudflared = { };

    systemd.services.cloudflared = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" "systemd-resolved.service" ];
      script = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=$(cat ${config.sops.secrets.cloudflared_token.path})";
      startLimitIntervalSec = 0;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10";
        User = "cloudflared";
        Group = "cloudflared";
      };
    };
  };
}
