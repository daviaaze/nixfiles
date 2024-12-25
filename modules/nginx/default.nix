{ lib, config, ... }:
with lib;
let
  cfg = config.modules.nginx;
in
{
  imports = [
    ./modules/pelican-panel.nix
    ./modules/beszel.nix
  ];

  options.modules.nginx = {
    enable = mkEnableOption "Enable nginx";

    domainName = mkOption {
      type = types.str;
      default = "daviaaze.com";
      description = ''
        The domain name to use for the nginx server.
      '';
    };

    acmeEmail = mkOption {
      type = types.str;
      default = "daviaaze@gmail.com";
      description = ''
        The email address to use for ACME certificates.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;

      # Add a default virtual host that returns 404
      virtualHosts."_" = {
        listen = [
          { port = 80; addr = "0.0.0.0"; }
          { port = 80; addr = "127.0.0.1"; }
          { port = 80; addr = "[::1]"; }
        ];
        locations."/" = {
          return = "404";
        };
      };
    };
  };
}
