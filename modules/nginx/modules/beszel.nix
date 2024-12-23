{ lib, config, ... }:
with lib;
let
  cfg = config.modules.nginx.beszel;
  serverName = "beszel.${config.modules.nginx.domainName}";
in
{
  options.modules.nginx.beszel = {
    enable = mkEnableOption "Enable beszel reverse proxy";
    port = mkOption {
      type = types.int;
      default = 8090;
      description = "Local beszel port";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."${serverName}" = {
      listen = [{ port = 80; addr="0.0.0.0"; }];
      
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;  # Important for beszel
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };
} 